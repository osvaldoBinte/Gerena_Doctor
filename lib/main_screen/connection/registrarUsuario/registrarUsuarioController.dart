import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:managegym/main_screen/connection/registrarUsuario/registrarUsuarioModel.dart';
import 'package:managegym/db/database_connection.dart';

class UsuarioController extends GetxController {
  var cargando = false.obs;
  var idUsuarioCreado = RxnInt();
  var error = RxnString();

  /// Obtiene el historial de pagos de un usuario, incluyendo nombre de la suscripción, fechas y estado.
  Future<List<Map<String, dynamic>>> obtenerHistorialPagosUsuario(int idUsuario) async {
    final conn = Database.conn;
    try {
      final result = await UsuarioDB.obtenerHistorialPagosUsuario(
        idUsuario: idUsuario,
        conn: conn,
      );
      debugPrint('[UsuarioController] Historial de pagos obtenido (${result.length} registros)');
      return result;
    } catch (e) {
      debugPrint('Error al obtener historial de pagos: $e');
      error.value = 'No se pudo obtener el historial de pagos';
      return [];
    }
  }

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

  /// Crea una venta de membresía para un usuario existente.
  Future<int?> crearVentaMembresia({
    required int idTipoMembresia,
    required int idUsuario,
    required double precio,
    required int duracion,
  }) async {
    try {
      final conn = Database.conn;
      return await UsuarioDB.crearVentaMembresia(
        idTipoMembresia: idTipoMembresia,
        idUsuario: idUsuario,
        precio: precio,
        duracion: duracion,
        conn: conn,
      );
    } catch (e) {
      debugPrint('Error en crearVentaMembresia: $e');
      error.value = 'No se pudo crear la venta de membresía';
      return null;
    }
  }

  /// Crea la membresía activa para el usuario.
  Future<int?> crearMembresiaUsuario({
    required int idUsuario,
    required int idVentaMembresia,
    required DateTime inicio,
    required DateTime fin,
  }) async {
    try {
      final conn = Database.conn;
      return await UsuarioDB.crearMembresiaUsuario(
        idUsuario: idUsuario,
        idVentaMembresia: idVentaMembresia,
        inicio: inicio,
        fin: fin,
        conn: conn,
      );
    } catch (e) {
      debugPrint('Error en crearMembresiaUsuario: $e');
      error.value = 'No se pudo crear la membresía del usuario';
      return null;
    }
  }

  /// Crea el historial de pago de una membresía de usuario.
  Future<int?> crearHistorialPago({
    required int idMembresiaUsuario,
    required double montoPago,
    required String metodoPago,
    String? numeroReferencia,
    DateTime? fechaProximoPago,
  }) async {
    try {
      final conn = Database.conn;
      return await UsuarioDB.crearHistorialPago(
        idMembresiaUsuario: idMembresiaUsuario,
        montoPago: montoPago,
        metodoPago: metodoPago,
        numeroReferencia: numeroReferencia,
        fechaProximoPago: fechaProximoPago,
        conn: conn,
      );
    } catch (e) {
      debugPrint('Error en crearHistorialPago: $e');
      error.value = 'No se pudo crear el historial de pago';
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