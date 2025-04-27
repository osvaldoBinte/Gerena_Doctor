import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:managegym/db/database_connection.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/connection/producto_model.dart';

class StoreController extends GetxController {
  // Variables observables para la lista de productos
  final productos = <Producto>[].obs;
  final filteredProductos = <Producto>[].obs;

  // Variable para controlar el estado de carga
  final isLoading = true.obs;

  // Variable para el texto de búsqueda
  final searchText = ''.obs;

  // Variables para ordenamiento
  final sortByNameAsc = true.obs;
  final sortByPriceAsc = true.obs;
  final activeSort = RxString(''); // 'name' o 'price'

  // Controlador para el campo de búsqueda
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    initializeDB();
  }

  Future<void> initializeDB() async {
    try {
      try {
        Database.conn;
      } catch (e) {
        await Database.connect();
        print('✅ Conexión a la base de datos inicializada desde el controlador de tienda');
      }
      await loadProductos();
    } catch (e) {
      print('❌ Error al inicializar la base de datos: $e');
      Get.snackbar(
        'Error de conexión',
        'No se pudo conectar a la base de datos: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> loadProductos() async {
    try {
      isLoading.value = true;
      // Carga los productos desde la base de datos
      final productosDB = await ProductoDB.obtenerProductos(conn: Database.conn);

      // Actualiza la lista observable
      productos.assignAll(productosDB);

      // Inicializa la lista filtrada con todos los productos
      filteredProductos.assignAll(productosDB);

      isLoading.value = false;
    } catch (e) {
      print('❌ Error al cargar productos: $e');
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'No se pudieron cargar los productos: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Método para buscar productos
  void searchProductos(String text) {
    searchText.value = text;
    if (text.isEmpty) {
      filteredProductos.assignAll(productos);
    } else {
      filteredProductos.assignAll(productos.where((producto) {
        final matchesTitle = producto.titulo.toLowerCase().contains(text.toLowerCase());
        final matchesBarcode = producto.codigoBarras?.toLowerCase().contains(text.toLowerCase()) ?? false;
        return matchesTitle || matchesBarcode;
      }).toList());
    }
    _applySorting();
  }
  // Método para asignar un valor exacto de stock (no suma)
Future<void> asignarStock(int idProducto, int cantidad) async {
  try {
    // Establece la cantidad exacta en la base de datos
    final success = await ProductoDB.asignarStock(
      id: idProducto,
      cantidad: cantidad,
      conn: Database.conn,
    );
    if (success) {
      await loadProductos();
      Get.snackbar(
        'Éxito',
        'Stock actualizado correctamente',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        'No se pudo actualizar el stock',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } catch (e) {
    print('❌ Error al actualizar stock: $e');
    Get.snackbar(
      'Error',
      'No se pudo actualizar el stock: $e',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

  // Método para ordenar por nombre
  void sortByName() {
    if (activeSort.value == 'name') {
      sortByNameAsc.value = !sortByNameAsc.value;
    } else {
      activeSort.value = 'name';
      sortByNameAsc.value = true;
    }
    _applySorting();
  }

  // Método para ordenar por precio
  void sortByPrice() {
    if (activeSort.value == 'price') {
      sortByPriceAsc.value = !sortByPriceAsc.value;
    } else {
      activeSort.value = 'price';
      sortByPriceAsc.value = true;
    }
    _applySorting();
  }

  // Método privado para aplicar el ordenamiento actual
  void _applySorting() {
    final productosList = List<Producto>.from(filteredProductos);
    if (activeSort.value == 'name') {
      productosList.sort((a, b) {
        final result = a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase());
        return sortByNameAsc.value ? result : -result;
      });
    } else if (activeSort.value == 'price') {
      productosList.sort((a, b) {
        final result = a.precioVenta.compareTo(b.precioVenta);
        return sortByPriceAsc.value ? result : -result;
      });
    }
    filteredProductos.assignAll(productosList);
  }

  // Método para actualizar el stock de un producto (ahora suma al stock actual)
  Future<void> updateStock(int idProducto, int cantidad) async {
    try {
      // Suma la cantidad al stock actual en la base de datos
      final success = await ProductoDB.agregarStock(
        id: idProducto,
        cantidad: cantidad,
        conn: Database.conn,
      );
      if (success) {
        await loadProductos();
        Get.snackbar(
          'Éxito',
          'Stock actualizado correctamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'No se pudo actualizar el stock',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('❌ Error al actualizar stock: $e');
      Get.snackbar(
        'Error',
        'No se pudo actualizar el stock: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Método para eliminar un producto
  Future<void> deleteProducto(int idProducto) async {
    try {
      final success = await ProductoDB.eliminarProducto(
        id: idProducto,
        conn: Database.conn,
      );
      if (success) {
        await loadProductos();
        Get.snackbar(
          'Éxito',
          'Producto eliminado correctamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'No se pudo eliminar el producto',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('❌ Error al eliminar producto: $e');
      Get.snackbar(
        'Error',
        'No se pudo eliminar el producto: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Método para recargar productos manualmente (pull-to-refresh)
  Future<void> refreshProductos() async {
    await loadProductos();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}