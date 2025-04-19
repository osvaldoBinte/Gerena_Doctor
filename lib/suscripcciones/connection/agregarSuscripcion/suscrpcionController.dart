import 'package:flutter/foundation.dart';
import 'package:managegym/suscripcciones/connection/agregarSuscripcion/SuscrpcionModel.dart';

class Agregarsuscrpcioncontroller {
  static Future<TipoMembresia?> agregarSuscripcion(String titulo, String descripcion, double precio, int tiempoDuracion) async {
    debugPrint('Datos de suscripción: titulo: $titulo, descripcion: $descripcion, precio: $precio, tiempoDuracion: $tiempoDuracion');

    if (titulo.isEmpty || descripcion.isEmpty || precio <= 0 || tiempoDuracion <= 0) {
      debugPrint('Error: Datos de suscripción inválidos');
      throw Exception('Datos de suscripción inválidos');
    }

    final tipoMembresia = await AgregarSuscripcionModel.insertarTipoMembresia(
      titulo: titulo,
      descripcion: descripcion,
      precio: precio,
      tiempoDuracion: tiempoDuracion,
    );
    if (tipoMembresia == null) {
      debugPrint('Error: No se pudo insertar la suscripción');
      throw Exception('No se pudo insertar la suscripción');
    }
    return tipoMembresia;
  }

  static Future<List<TipoMembresia>> listarSuscripciones() async {
    return await AgregarSuscripcionModel.obtenerTodasLasSuscripciones();
  }
}