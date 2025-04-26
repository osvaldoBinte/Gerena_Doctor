import 'package:get/get.dart';
import 'package:managegym/main_screen/widgets/connection/categoriaModel.dart';

class TIpoMembresiaController extends GetxController {
  var categorias = <TIpoMembresia>[].obs;
  var cargando = false.obs;

  @override
  void onInit() {
    super.onInit();
    cargarCategorias();
  }

  Future<void> cargarCategorias() async {
    cargando.value = true;
    final lista = await TIpoMembresiaModel.obtenerTodasLasCategorias();
    categorias.assignAll(lista);
    cargando.value = false;
  }

  List<String> get titulosCategorias =>
      categorias.map((cat) => cat.titulo).toList();

  Future<bool> agregarCategoria({
    required String titulo,
    required String descripcion,
    required double precio,
    required int tiempoDuracion,
  }) async {
    final nueva = await TIpoMembresiaModel.insertarTipoMembresia(
      titulo: titulo,
      descripcion: descripcion,
      precio: precio,
      tiempoDuracion: tiempoDuracion,
    );
    if (nueva != null) {
      await cargarCategorias();
      return true;
    }
    return false;
  }

  Future<bool> eliminarCategoria(int id) async {
    final eliminado = await TIpoMembresiaModel.eliminarTipoMembresia(id);
    if (eliminado) {
      await cargarCategorias();
      return true;
    }
    return false;
  }
}