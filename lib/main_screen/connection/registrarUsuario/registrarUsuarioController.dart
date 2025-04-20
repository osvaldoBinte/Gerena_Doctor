import 'package:flutter/foundation.dart';
import 'package:managegym/main_screen/connection/registrarUsuario/registrarUsuarioModel.dart';
import 'package:managegym/db/database_connection.dart';

class UsuarioController {
  static Future<int?> crearUsuarioCompleto({
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
    final conn = Database.conn;
    try {
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
      debugPrint('Usuario creado con id: $idUsuario');

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

      if (idMetodoQR != null) {
        await UsuarioDB.crearCodigoQR(
          qr: qr,
          idUsuario: idUsuario,
          idMetodoAcceso: idMetodoQR,
          conn: conn,
        );
        debugPrint('QR guardado');
      }

      if (idMetodoHuella != null) {
        await UsuarioDB.crearRegistroHuella(
          plantilla: plantillaHuella,
          idMetodoAcceso: idMetodoHuella,
          conn: conn,
        );
        debugPrint('Huella guardada');
      }

      // ATENCIÓN: nombre correcto de la tabla de venta membresías, usa todo minúscula y sin tildes.
      final idVentaMembresia = await UsuarioDB.crearVentaMembresia(
        idTipoMembresia: idTipoMembresia,
        idUsuario: idUsuario,
        precio: precioMembresia,
        duracion: duracionMembresia,
        conn: conn,
      );
      debugPrint('Venta Membresía registrada: $idVentaMembresia');

      int? idMembresiaUsuario;
      if (idVentaMembresia != null) {
        idMembresiaUsuario = await UsuarioDB.crearMembresiaUsuario(
          idUsuario: idUsuario,
          idVentaMembresia: idVentaMembresia,
          inicio: fechaInicioMembresia,
          fin: fechaFinMembresia,
          conn: conn,
        );
        debugPrint('Membresía activa creada');
      }

      // Historial de pago
      if (idMembresiaUsuario != null && montoPago != null && metodoPago != null) {
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
      debugPrint('Error en crearUsuarioCompleto: $e');
      return null;
    }
  }
}