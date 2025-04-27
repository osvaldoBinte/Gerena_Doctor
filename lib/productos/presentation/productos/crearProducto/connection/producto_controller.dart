import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:managegym/db/database_connection.dart';
import 'package:managegym/main_screen/widgets/connection/categoriaModel.dart';
import 'package:managegym/main_screen/widgets/connection/categoriaController.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/connection/producto_model.dart';

class ProductoController extends GetxController {
  final nombreProductoController = TextEditingController();
  final codigoBarrasController = TextEditingController();
  final stockInicialController = TextEditingController();
  final precioController = TextEditingController();
  final descripcionController = TextEditingController();

  final isImageSelected = false.obs;
  final selectedImagePath = Rx<String?>(null);

  final categoriaSeleccionada = Rx<Categoria?>(null);
  final categorias = <Categoria>[].obs;

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  void cambiarCategoria(Categoria? categoria) {
    categoriaSeleccionada.value = categoria;
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<CategoriaController>()) {
      final categoriaController = Get.find<CategoriaController>();
      categorias.assignAll(categoriaController.categorias);
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

    selectedImagePath.value = file.path;
    isImageSelected.value = true;
    print('Imagen seleccionada: ${file.path}');
  }

  // Método para guardar un nuevo producto usando Base64
  Future<void> guardarProducto() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;

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

        final int? idCategoria = categoriaSeleccionada.value?.id;

        if (idCategoria == null) {
          Get.snackbar('Error', 'No se encontró la categoría seleccionada',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
          isLoading.value = false;
          return;
        }

        String? imagenBase64;

        if (isImageSelected.value && selectedImagePath.value != null) {
          File imageFile = File(selectedImagePath.value!);
          List<int> imageBytes = await imageFile.readAsBytes();
          imagenBase64 = base64Encode(imageBytes);
          print('Imagen convertida a Base64');
        }

        // --- GESTIÓN DEL CÓDIGO DE BARRAS ---
        String codigoBarras = codigoBarrasController.text.trim();
        int? idCodigoBarras;

        if (codigoBarras.isNotEmpty) {
          // Buscar si ya existe el código de barras
          idCodigoBarras = await ProductoDB.buscarCodigoBarrasId(
            codigoBarras: codigoBarras,
            conn: Database.conn,
          );
          // Si no existe, insertar
          if (idCodigoBarras == null) {
            idCodigoBarras = await ProductoDB.insertarCodigoBarras(
              codigoBarras: codigoBarras,
              conn: Database.conn,
            );
          }
        } else {
          idCodigoBarras = null;
        }

        // 2. Crear producto en la base de datos usando el idCodigoBarras generado o encontrado
        final int? idProducto = await ProductoDB.crearProducto(
          titulo: nombreProductoController.text,
          descripcion: descripcionController.text,
          precioVenta: precio,
          stock: stock,
          idCategoria: idCategoria,
          idCodigoBarras: idCodigoBarras,
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
    categoriaSeleccionada.value = categorias.isNotEmpty ? categorias.first : null;
    selectedImagePath.value = null;
    isImageSelected.value = false;
  }

  @override
  void onClose() {
    nombreProductoController.dispose();
    codigoBarrasController.dispose();
    stockInicialController.dispose();
    precioController.dispose();
    descripcionController.dispose();
    super.onClose();
  }
}