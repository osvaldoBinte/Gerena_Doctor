import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:managegym/db/database_connection.dart';
import 'package:managegym/main_screen/widgets/connection/categoriaController.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/producto_model.dart';

class ProductoController extends GetxController {
  // Controladores para los campos de texto
  final nombreProductoController = TextEditingController();
  final codigoBarrasController = TextEditingController();
  final stockInicialController = TextEditingController();
  final precioController = TextEditingController();
  final descripcionController = TextEditingController();
  final idCodigoBarras = TextEditingController();

  final isImageSelected = false.obs;
  final selectedImagePath = Rx<String?>(null);

  // Categoría seleccionada y lista dinámica de categorías
  final categoriaSeleccionada = Rx<String?>(null);
  final categorias = <String>[].obs;

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Cargar categorías reales del controlador global de categorías
    if (Get.isRegistered<TIpoMembresiaController>()) {
      final categoriaController = Get.find<TIpoMembresiaController>();
      categorias.assignAll(categoriaController.categorias.map((c) => c.titulo));
      if (categorias.isNotEmpty && categoriaSeleccionada.value == null) {
        categoriaSeleccionada.value = categorias.first;
      }
    }
  }

  Future<void> selectImage() async {
    XTypeGroup typeGroup = XTypeGroup(
      label: 'images',
      extensions: <String>['jpg', 'png'],
    );

    final XFile? file = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

    if (file == null) return;

    // Guarda la ruta temporal para la vista previa
    selectedImagePath.value = file.path;
    isImageSelected.value = true;
    print('Imagen seleccionada: ${file.path}');
  }

  // Método para guardar un nuevo producto usando Base64
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

        // Obtener ID de categoría usando el nombre seleccionado (firstWhereOrNull de GetX)
        int? idCategoria;
        if (Get.isRegistered<TIpoMembresiaController>()) {
          final categoriaController = Get.find<TIpoMembresiaController>();
          final categoriaObjeto = categoriaController.categorias
              .firstWhereOrNull((cat) => cat.titulo == categoriaSeleccionada.value);
          if (categoriaObjeto != null) {
            idCategoria = categoriaObjeto.id;
          }
        }

        if (idCategoria == null) {
          Get.snackbar('Error', 'No se encontró la categoría seleccionada',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
          isLoading.value = false;
          return;
        }

        // Variable para almacenar la imagen en Base64
        String? imagenBase64;

        // Convertir la imagen a Base64 si hay una imagen seleccionada
        if (isImageSelected.value && selectedImagePath.value != null) {
          File imageFile = File(selectedImagePath.value!);
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
          imagenProducto: imagenBase64,
          conn: Database.conn,
        );

        if (idProducto != null) {
          Get.back(); // Cerrar el modal

          Get.snackbar('Éxito', 'Producto guardado correctamente',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);

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

  void limpiarCampos() {
    nombreProductoController.clear();
    codigoBarrasController.clear();
    stockInicialController.clear();
    precioController.clear();
    descripcionController.clear();
    idCodigoBarras.clear();
    categoriaSeleccionada.value = categorias.isNotEmpty ? categorias.first : null;
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