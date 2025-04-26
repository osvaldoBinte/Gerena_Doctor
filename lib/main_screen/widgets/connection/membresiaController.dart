import 'package:get/get.dart';
import 'categoriaModel.dart';

class CategoriaController extends GetxController {
  var categorias = <Categoria>[].obs;
  var cargando = false.obs;

  List<String> get titulosCategorias => categorias.map((c) => c.titulo).toList();

  @override
  void onInit() {
    super.onInit();
    cargarCategorias();
  }

  Future<void> cargarCategorias() async {
    cargando.value = true;
    categorias.value = await CategoriaModel.obtenerTodasLasCategorias();
    cargando.value = false;
  }

  Future<bool> agregarCategoria({required String titulo}) async {
    final cat = await CategoriaModel.insertarCategoria(titulo: titulo);
    if (cat != null) {
      await cargarCategorias();
      return true;
    }
    return false;
  }

  Future<bool> eliminarCategoria(int id) async {
    final ok = await CategoriaModel.eliminarCategoria(id);
    if (ok) {
      await cargarCategorias();
      return true;
    }
    return false;
  }
}