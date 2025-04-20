import 'package:get/get.dart';
import 'package:managegym/suscripcciones/connection/agregarSuscripcion/SuscrpcionModel.dart';

class SuscripcionController extends GetxController {
  var suscripciones = <TipoMembresia>[].obs;
  var cargando = false.obs;

  @override
  void onInit() {
    super.onInit();
    cargarSuscripciones();
  }

  Future<void> cargarSuscripciones() async {
    cargando.value = true;
    final lista = await AgregarSuscripcionModel.obtenerTodasLasSuscripciones();
    suscripciones.assignAll(lista);
    cargando.value = false;
  }

  Future<bool> agregarSuscripcion({
    required String titulo,
    required String descripcion,
    required double precio,
    required int tiempoDuracion,
  }) async {
    final nueva = await AgregarSuscripcionModel.insertarTipoMembresia(
      titulo: titulo,
      descripcion: descripcion,
      precio: precio,
      tiempoDuracion: tiempoDuracion,
    );
    if (nueva != null) {
      await cargarSuscripciones();
      return true;
    }
    return false;
  }

  Future<bool> actualizarSuscripcion({
    required int id,
    required String titulo,
    required String descripcion,
    required double precio,
    required int tiempoDuracion,
  }) async {
    final ok = await AgregarSuscripcionModel.actualizarTipoMembresia(
      id: id,
      titulo: titulo,
      descripcion: descripcion,
      precio: precio,
      tiempoDuracion: tiempoDuracion,
    );
    if (ok) {
      await cargarSuscripciones();
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>> puedeEliminarSuscripcion(int id) async {
    final tieneVentas = await AgregarSuscripcionModel.tieneVentasAsociadas(id);
    if (tieneVentas) {
      return {
        'puede': false,
        'mensaje': 'No se puede eliminar porque esta suscripción tiene ventas asociadas'
      };
    }
    return {'puede': true, 'mensaje': ''};
  }

  Future<bool> eliminarSuscripcion({
    required int id,
  }) async {
    final verificacion = await puedeEliminarSuscripcion(id);
    if (!verificacion['puede']) {
      print('No se puede eliminar: ${verificacion['mensaje']}');
      return false;
    }
    
    final ok = await AgregarSuscripcionModel.eliminarTipoMembresia(id: id);
    if (ok) {
      await cargarSuscripciones();
      return true;
    }
    return false;
  }
}