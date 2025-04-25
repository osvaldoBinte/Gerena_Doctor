import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:managegym/db/database_connection.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/producto_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ProductoController extends GetxController {
  // Controladores para los campos de texto
  final nombreProductoController = TextEditingController();
  final codigoBarrasController = TextEditingController();
  final stockInicialController = TextEditingController();
  final precioController = TextEditingController();
  final descripcionController = TextEditingController();
  final idCodigoBarras = TextEditingController();

  // Estado observable para la imagen
  final isImageSelected = false.obs;
  final selectedImagePath = Rx<String?>(null);

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

  Future<void> selectImage() async {
    XTypeGroup typeGroup = XTypeGroup(
      label: 'images',
      extensions: <String>['jpg', 'png'],
    );

    final XFile? file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

    if (file == null) return;

    final String filePath = file.path;

    // 1. Obtén el directorio de documentos de la app
    final Directory appDir = await getApplicationDocumentsDirectory();

    // 2. Crea la carpeta 'imagenes_productos' si no existe
    final Directory imagesDir = Directory(path.join(appDir.path, 'imagenes_productos'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    // 3. Prepara el destino: nombre único para la imagen (puedes mejorarlo)
    final String fileName = path.basename(filePath);
    final String newPath = path.join(imagesDir.path, fileName);

    // 4. Copia la imagen a la carpeta interna
    await File(filePath).copy(newPath);

    // 5. Guarda la nueva ruta en el observable
    selectedImagePath.value = newPath;
    isImageSelected.value = true;

    print('Imagen copiada en: $newPath');
  }

  // Método para guardar un nuevo producto
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

        // Obtener ID de categoría (esto es un ejemplo, ajusta según tu estructura)
        int? idCategoria = categorias.indexOf(categoriaSeleccionada.value!) + 1;

        // Crear producto en la base de datos
        final int? idProducto = await ProductoDB.crearProducto(
          titulo: nombreProductoController.text,
          descripcion: descripcionController.text,
          precioVenta: precio,
          stock: stock,
          idCategoria: idCategoria,
          idCodigoBarras: int.tryParse(idCodigoBarras.text),
          imagenProducto: selectedImagePath.value,
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

  // Método para limpiar los campos después de guardar
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
    descripcionController.dispose();
    idCodigoBarras.dispose();
    super.onClose();
  }
}