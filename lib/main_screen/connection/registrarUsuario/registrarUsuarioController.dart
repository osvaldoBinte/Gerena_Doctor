import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:managegym/main_screen/connection/registrarUsuario/registrarUsuarioModel.dart';
import 'package:managegym/db/database_connection.dart';

class UsuarioController extends GetxController {
  var cargando = false.obs;
  var idUsuarioCreado = RxnInt();
  var error = RxnString();

  /// Obtiene un usuario actualizado de la base de datos por su ID
  Future<Usuario?> obtenerUsuarioPorId(int id) async {
    final conn = Database.conn;
    try {
      print('[UsuarioController] Llamando a UsuarioDB.obtenerUsuarioPorId con id: $id');
      final usuario = await UsuarioDB.obtenerUsuarioPorId(id: id, conn: conn);
      if (usuario == null) {
        print('[UsuarioController] Usuario no encontrado');
      } else {
        print('[UsuarioController] Usuario obtenido:');
        print('Nombre: ${usuario.nombre}');
        print('Apellidos: ${usuario.apellidos}');
        print('Correo: ${usuario.correo}');
        print('Teléfono: ${usuario.telefono}');
        print('FechaNacimiento: ${usuario.fechaNacimiento}');
        print('Sexo: ${usuario.sexo}');
      }
      return usuario;
    } catch (e) {
      debugPrint('Error al obtener usuario por id: $e');
      error.value = 'No se pudo obtener el usuario';
      return null;
    }
  }

  /// Crea un usuario completo, junto con sus métodos de acceso, membresía y pago.
  Future<int?> crearUsuarioCompleto({
    required String nombre,
    required String apellidos,
    required String correo,
    required String telefono,
    DateTime? fechaNacimiento,
    required String sexo,
    required String qr,
    required String plantillaHuella,
    required int idTipoMembresia,
    required double precioMembresia,
    required int duracionMembresia,
    required DateTime fechaInicioMembresia,
    required DateTime fechaFinMembresia,
    double? montoPago,
    String? metodoPago,
    String? numeroReferencia,
    DateTime? fechaProximoPago,
  }) async {
    cargando.value = true;
    error.value = null;
    idUsuarioCreado.value = null;
    final conn = Database.conn;
    try {
      // 1. Crear usuario
      final idUsuario = await UsuarioDB.crearUsuario(
        nombre: nombre,
        apellidos: apellidos,
        correo: correo,
        telefono: telefono,
        fechaNacimiento: fechaNacimiento,
        sexo: sexo,
        conn: conn,
      );
      if (idUsuario == null) throw Exception('No se pudo crear el usuario');
      idUsuarioCreado.value = idUsuario;
      debugPrint('Usuario creado con id: $idUsuario');

      // 2. Crear métodos de acceso (Huella y QR)
      final idMetodoHuella = await UsuarioDB.crearMetodoAcceso(
        idUsuario: idUsuario,
        tipoAcceso: 'Huella',
        conn: conn,
      );
      final idMetodoQR = await UsuarioDB.crearMetodoAcceso(
        idUsuario: idUsuario,
        tipoAcceso: 'QR',
        conn: conn,
      );
      debugPrint('Método de acceso Huella id: $idMetodoHuella, QR id: $idMetodoQR');

      // 3. Guardar QR
      if (idMetodoQR != null) {
        await UsuarioDB.crearCodigoQR(
          qr: qr,
          idUsuario: idUsuario,
          idMetodoAcceso: idMetodoQR,
          conn: conn,
        );
        debugPrint('QR guardado');
      }

      // 4. Guardar huella
      if (idMetodoHuella != null) {
        await UsuarioDB.crearRegistroHuella(
          plantilla: plantillaHuella,
          idMetodoAcceso: idMetodoHuella,
          conn: conn,
        );
        debugPrint('Huella guardada');
      }

      // 5. Registrar venta de membresía
      final idVentaMembresia = await UsuarioDB.crearVentaMembresia(
        idTipoMembresia: idTipoMembresia,
        idUsuario: idUsuario,
        precio: precioMembresia,
        duracion: duracionMembresia,
        conn: conn,
      );
      debugPrint('Venta Membresía registrada: $idVentaMembresia');

      int? idMembresiaUsuario;
      // 6. Registrar membresía activa
      if (idVentaMembresia != null) {
        idMembresiaUsuario = await UsuarioDB.crearMembresiaUsuario(
          idUsuario: idUsuario,
          idVentaMembresia: idVentaMembresia,
          inicio: fechaInicioMembresia,
          fin: fechaFinMembresia,
          conn: conn,
        );
        debugPrint('Membresía activa creada: $idMembresiaUsuario');
      }

      // 7. Registrar historial de pago si corresponde
      if (idMembresiaUsuario != null &&
          montoPago != null &&
          metodoPago != null) {
        final idPago = await UsuarioDB.crearHistorialPago(
          idMembresiaUsuario: idMembresiaUsuario,
          montoPago: montoPago,
          metodoPago: metodoPago,
          numeroReferencia: numeroReferencia,
          fechaProximoPago: fechaProximoPago,
          conn: conn,
        );
        debugPrint('Historial de pago creado: $idPago');
      }

      return idUsuario;
    } catch (e) {
      error.value = e.toString();
      debugPrint('Error en crearUsuarioCompleto: $e');
      return null;
    } finally {
      cargando.value = false;
    }
  }
}