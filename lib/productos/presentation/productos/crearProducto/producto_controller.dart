import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:managegym/db/database_connection.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/producto_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ProductoController extends GetxController {
  // Controladores para los campos de texto y otras propiedades se mantienen igual
  final nombreProductoController = TextEditingController();
  final codigoBarrasController = TextEditingController();
  final stockInicialController = TextEditingController();
  final precioController = TextEditingController();
  final descripcionController = TextEditingController();
  final idCodigoBarras = TextEditingController();

  final isImageSelected = false.obs;
  final selectedImagePath = Rx<String?>(null);
  
  final categoriaSeleccionada = Rx<String?>(null);
  final List<String> categorias = [
    'Categoria 1',
    'Categoria 2',
    'Categoria 3',
    'Categoria 4',
    'Categoria 5'
  ];
  
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  Future<void> selectImage() async {
    XTypeGroup typeGroup = XTypeGroup(
      label: 'images',
      extensions: <String>['jpg', 'png'],
    );

    final XFile? file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

    if (file == null) return;

    // Simplemente guarda la ruta temporal para la vista previa
    selectedImagePath.value = file.path;
    isImageSelected.value = true;

    print('Imagen seleccionada: ${file.path}');
  }

  // Método para guardar un nuevo producto - MODIFICADO para usar Base64
Future<void> guardarProducto() async {
  if (formKey.currentState!.validate()) {
    try {
      isLoading.value = true;

      // Validación adicional para la categoría
      if (categoriaSeleccionada.value == null) {
        Get.snackbar('Error', 'Por favor selecciona una categoría',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
        isLoading.value = false;
        return;
      }

      // Convertir el precio y stock a los tipos correctos
      final double precio = double.tryParse(precioController.text) ?? 0.0;
      final int stock = int.tryParse(stockInicialController.text) ?? 0;

      // Obtener ID de categoría
      int? idCategoria = categorias.indexOf(categoriaSeleccionada.value!) + 1;

      // Variable para almacenar la imagen en Base64
      String? imagenBase64;
      
      // Convertir la imagen a Base64 si hay una imagen seleccionada
      if (isImageSelected.value && selectedImagePath.value != null) {
        // Crear un objeto File desde la ruta
        File imageFile = File(selectedImagePath.value!);
        
        // Convertir la imagen a Base64
        List<int> imageBytes = await imageFile.readAsBytes();
        imagenBase64 = base64Encode(imageBytes);
        
        print('Imagen convertida a Base64');
      }

      // Crear producto en la base de datos
      final int? idProducto = await ProductoDB.crearProducto(
        titulo: nombreProductoController.text,
        descripcion: descripcionController.text,
        precioVenta: precio,
        stock: stock,
        idCategoria: idCategoria,
        idCodigoBarras: int.tryParse(idCodigoBarras.text),
        imagenProducto: imagenBase64, // Usar Base64 en lugar de ruta
        conn: Database.conn,
      );

        if (idProducto != null) {
          // Si se guardó el producto correctamente
          Get.back(); // Cerrar el modal

          Get.snackbar('Éxito', 'Producto guardado correctamente',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);

          // Limpiar los campos
          limpiarCampos();
        } else {
          Get.snackbar('Error', 'No se pudo guardar el producto',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        print('Error al guardar producto: $e');
        Get.snackbar('Error', 'Ocurrió un error: $e',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      } finally {
        isLoading.value = false;
      }
    }
  }

  // El resto del código permanece igual
  void limpiarCampos() {
    nombreProductoController.clear();
    codigoBarrasController.clear();
    stockInicialController.clear();
    precioController.clear();
    descripcionController.clear();
    idCodigoBarras.clear();
    categoriaSeleccionada.value = null;
    selectedImagePath.value = null;
    isImageSelected.value = false;
  }

  void cambiarCategoria(String? categoria) {
    categoriaSeleccionada.value = categoria;
  }

  @override
  void onClose() {
    nombreProductoController.dispose();
    codigoBarrasController.dispose();
    stockInicialController.dispose();
    precioController.dispose();
    descripcionController.dispose();
    idCodigoBarras.dispose();
    super.onClose();
  }
}