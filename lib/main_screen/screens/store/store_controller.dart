import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:managegym/db/database_connection.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/producto_model.dart';

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
    
    // Inicializa la conexión a la base de datos si no está inicializada
    initializeDB();
  }
  
  Future<void> initializeDB() async {
    try {
      // Verifica si la conexión a la base de datos ya está inicializada
      // Esta es una solución provisional - ajusta según tu estructura de base de datos
      try {
        // Intenta acceder a la conexión - si no está inicializada, lanzará un error
        Database.conn;
      } catch (e) {
        // Si hay un error, inicializa la conexión
        await Database.connect();
        print('✅ Conexión a la base de datos inicializada desde el controlador de tienda');
      }
      
      // Carga los productos
      await loadProductos();
    } catch (e) {
      print('❌ Error al inicializar la base de datos: $e');
      // Mostrar un mensaje de error al usuario
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
      productos.value = productosDB;
      
      // Inicializa la lista filtrada con todos los productos
      filteredProductos.value = productosDB;
      
      isLoading.value = false;
    } catch (e) {
      print('❌ Error al cargar productos: $e');
      isLoading.value = false;
      
      // Mostrar mensaje de error
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
      // Si no hay texto de búsqueda, muestra todos los productos
      filteredProductos.value = productos;
    } else {
      // Filtra productos que coincidan con el texto de búsqueda
      filteredProductos.value = productos.where((producto) {
        // Busca en título y código de barras (si existe)
        final matchesTitle = producto.titulo.toLowerCase().contains(text.toLowerCase());
        
        // Si tienes un campo para código de barras, agrega esta condición
        // final matchesBarcode = producto.codigoBarras?.toLowerCase().contains(text.toLowerCase()) ?? false;
        
        return matchesTitle; // || matchesBarcode;
      }).toList();
    }
    
    // Aplica el ordenamiento actual si existe
    _applySorting();
  }
  
  // Método para ordenar por nombre
  void sortByName() {
    if (activeSort.value == 'name') {
      // Si ya estamos ordenando por nombre, cambia la dirección
      sortByNameAsc.value = !sortByNameAsc.value;
    } else {
      // Si no estamos ordenando por nombre, establece como activo
      activeSort.value = 'name';
      sortByNameAsc.value = true;
    }
    
    _applySorting();
  }
  
  // Método para ordenar por precio
  void sortByPrice() {
    if (activeSort.value == 'price') {
      // Si ya estamos ordenando por precio, cambia la dirección
      sortByPriceAsc.value = !sortByPriceAsc.value;
    } else {
      // Si no estamos ordenando por precio, establece como activo
      activeSort.value = 'price';
      sortByPriceAsc.value = true;
    }
    
    _applySorting();
  }
  
  // Método privado para aplicar el ordenamiento actual
  void _applySorting() {
    // Crea una copia de la lista filtrada
    final productosList = List<Producto>.from(filteredProductos);
    
    if (activeSort.value == 'name') {
      // Ordena por nombre
      productosList.sort((a, b) {
        final result = a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase());
        return sortByNameAsc.value ? result : -result;
      });
    } else if (activeSort.value == 'price') {
      // Ordena por precio
      productosList.sort((a, b) {
        final result = a.precioVenta.compareTo(b.precioVenta);
        return sortByPriceAsc.value ? result : -result;
      });
    }
    
    // Actualiza la lista filtrada con el nuevo orden
    filteredProductos.value = productosList;
  }
  
  // Método para actualizar el stock de un producto
  Future<void> updateStock(int idProducto, int cantidad) async {
    try {
      // Actualiza el stock en la base de datos
      final success = await ProductoDB.establecerStock(
        id: idProducto,
        cantidad: cantidad,
        conn: Database.conn,
      );
      
      if (success) {
        // Recarga los productos para reflejar el cambio
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
      // Elimina el producto de la base de datos
      final success = await ProductoDB.eliminarProducto(
        id: idProducto,
        conn: Database.conn,
      );
      
      if (success) {
        // Recarga los productos para reflejar el cambio
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
    // Libera los recursos
    searchController.dispose();
    super.onClose();
  }
}