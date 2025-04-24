import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:managegym/db/database_connection.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/producto_model.dart';

class AgregarStockController extends GetxController {
  // Controlador para el campo de texto
  final cantidadController = TextEditingController();
  
  // Producto seleccionado
  final producto = Rx<Producto?>(null);
  
  // ID del producto
  final idProducto = RxInt(0);
  
  // Nombre del producto
  final nombreProducto = RxString('');
  
  // Estado de carga
  final isLoading = false.obs;
  
  // FormKey para validación
  final formKey = GlobalKey<FormState>();
  
  // Callback para cuando se actualiza el stock
  Function(int)? onStockUpdated;
  
  @override
  void onInit() {
    super.onInit();
    
    // Si se recibe argumentos, inicializar los campos
    if (Get.arguments != null) {
      if (Get.arguments is Map) {
        Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
        
        if (args.containsKey('idProducto')) {
          idProducto.value = args['idProducto'];
        }
        
        if (args.containsKey('nombreProducto')) {
          nombreProducto.value = args['nombreProducto'];
        }
        
        if (args.containsKey('producto') && args['producto'] is Producto) {
          producto.value = args['producto'];
        }
        
        if (args.containsKey('onStockUpdated') && args['onStockUpdated'] is Function(int)) {
          onStockUpdated = args['onStockUpdated'];
        }
      } else if (Get.arguments is Producto) {
        producto.value = Get.arguments;
        idProducto.value = producto.value!.id;
        nombreProducto.value = producto.value!.titulo;
      }
    }
    
    // Si tenemos un ID pero no un nombre, obtener el producto
    if (idProducto.value > 0 && nombreProducto.value.isEmpty) {
      cargarProducto();
    }
  }
  
  // Método para cargar un producto por ID
  Future<void> cargarProducto() async {
    try {
      isLoading.value = true;
      
      // Verificar conexión a la base de datos
      try {
        Database.conn;
      } catch (e) {
        await Database.connect();
      }
      
      // Cargar el producto
      final productoDb = await ProductoDB.obtenerProductoPorId(
        id: idProducto.value,
        conn: Database.conn
      );
      
      if (productoDb != null) {
        producto.value = productoDb;
        nombreProducto.value = productoDb.titulo;
      }
    } catch (e) {
      print('Error al cargar producto: $e');
      Get.snackbar(
        'Error',
        'No se pudo cargar el producto: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Método para agregar stock
  Future<bool> agregarStock() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        isLoading.value = true;
        
        // Verificar que tenemos un ID de producto
        if (idProducto.value <= 0) {
          Get.snackbar(
            'Error',
            'No se especificó un producto',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
          );
          return false;
        }
        
        // Obtener la cantidad a agregar
        final int cantidad = int.tryParse(cantidadController.text) ?? 0;
        
        if (cantidad <= 0) {
          Get.snackbar(
            'Error',
            'La cantidad debe ser mayor a 0',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
          );
          return false;
        }
        
        // Actualizar el stock en la base de datos
        final bool exito = await ProductoDB.establecerStock(
          id: idProducto.value,
          cantidad: cantidad,
          conn: Database.conn
        );
        
        if (exito) {
          Get.snackbar(
            'Éxito',
            'Stock actualizado correctamente',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
          );
          
          // Llamar al callback si existe
          if (onStockUpdated != null) {
            onStockUpdated!(cantidad);
          }
          
          return true;
        } else {
          Get.snackbar(
            'Error',
            'No se pudo actualizar el stock',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
          );
          return false;
        }
      } catch (e) {
        print('Error al agregar stock: $e');
        Get.snackbar(
          'Error',
          'Ocurrió un error: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM
        );
        return false;
      } finally {
        isLoading.value = false;
      }
    }
    return false;
  }
  
  // Método para validar que el valor sea un número
  String? validarCantidad(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo requerido';
    }
    if (int.tryParse(value) == null) {
      return 'Campo debe ser un número entero';
    }
    if (int.parse(value) <= 0) {
      return 'La cantidad debe ser mayor a 0';
    }
    return null;
  }
  
  // Liberar recursos
  @override
  void onClose() {
    cantidadController.dispose();
    super.onClose();
  }
}