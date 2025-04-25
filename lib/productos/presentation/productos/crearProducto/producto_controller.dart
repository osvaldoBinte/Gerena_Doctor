import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:managegym/db/database_connection.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/producto_model.dart';

class ProductoController extends GetxController {
  // Controladores para los campos de texto
  final nombreProductoController = TextEditingController();
  final codigoBarrasController = TextEditingController();
  final stockInicialController = TextEditingController();
  final precioController = TextEditingController();
  
  // Estado observable para la imagen
  final isImageSelected = false.obs;
  final selectedImagePath = Rx<String?>(null);
  final textoBotonImagen = 'AGREGAR IMAGEN'.obs;
  
  // Estado observable para la categoría
  final categoriaSeleccionada = Rx<String?>(null);
  
  // Lista de categorías (esto podría venir de la base de datos)
  final List<String> categorias = [
    'Categoria 1',
    'Categoria 2',
    'Categoria 3',
    'Categoria 4',
    'Categoria 5'
  ];
  
  // FormKey para validación
  final formKey = GlobalKey<FormState>();
  
  // Estado para manejar la carga al guardar
  final isLoading = false.obs;
  
  // Método para seleccionar una imagen
  Future<void> selectImage() async {
    XTypeGroup typeGroup = XTypeGroup(
      label: 'images',
      extensions: <String>['jpg', 'png'],
    );
    
    final XFile? file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
    
    if (file == null) {
      // Operación cancelada por el usuario
      return;
    }
    
    final String fileName = file.name;
    final String filePath = file.path;
    
    selectedImagePath.value = filePath;
    textoBotonImagen.value = 'CAMBIAR IMAGEN';
    isImageSelected.value = true;
    
    print('Nombre del archivo: $fileName');
    print('Ruta del archivo: $filePath');
  }
  
  // Método para guardar un nuevo producto
  Future<void> guardarProducto() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;
        
        // Validación adicional para la categoría
        if (categoriaSeleccionada.value == null) {
          Get.snackbar(
            'Error',
            'Por favor selecciona una categoría',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
          );
          isLoading.value = false;
          return;
        }
        
        // Convertir el precio y stock a los tipos correctos
        final double precio = double.tryParse(precioController.text) ?? 0.0;
        final int stock = int.tryParse(stockInicialController.text) ?? 0;
        
        // Obtener ID de categoría (esto es un ejemplo, ajusta según tu estructura)
        // En un caso real, tendríamos que buscar el ID de la categoría basado 
        // en el nombre seleccionado
        int? idCategoria = categorias.indexOf(categoriaSeleccionada.value!) + 1;
        
        // Crear producto en la base de datos
        // Modificar en el controlador
final int? idProducto = await ProductoDB.crearProducto(
  titulo: nombreProductoController.text,
  descripcion: '',
  precioVenta: precio,
  stock: stock,
  idCategoria: null, // Usar null en lugar del índice de la lista
  idCodigoBarras: null, // También null aquí
  conn: Database.conn,
);
        
        if (idProducto != null) {
          // Si se guardó el producto correctamente
          Get.back(); // Cerrar el modal
          
          Get.snackbar(
            'Éxito',
            'Producto guardado correctamente',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
          );
          
          // Aquí puedes agregar lógica para manejar la imagen si es necesario
          // Por ejemplo, guardar la imagen en un directorio y actualizar la ruta en la base de datos
          
          // Limpiar los campos
          limpiarCampos();
        } else {
          Get.snackbar(
            'Error',
            'No se pudo guardar el producto',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
          );
        }
      } catch (e) {
        print('Error al guardar producto: $e');
        Get.snackbar(
          'Error',
          'Ocurrió un error: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
  
  // Método para limpiar los campos después de guardar
  void limpiarCampos() {
    nombreProductoController.clear();
    codigoBarrasController.clear();
    stockInicialController.clear();
    precioController.clear();
    categoriaSeleccionada.value = null;
    selectedImagePath.value = null;
    isImageSelected.value = false;
    textoBotonImagen.value = 'AGREGAR IMAGEN';
  }
  
  // Método para cambiar la categoría seleccionada
  void cambiarCategoria(String? categoria) {
    categoriaSeleccionada.value = categoria;
  }
  
  // Asegúrate de liberar los controladores cuando se destruya el controlador
  @override
  void onClose() {
    nombreProductoController.dispose();
    codigoBarrasController.dispose();
    stockInicialController.dispose();
    precioController.dispose();
    super.onClose();
  }
}