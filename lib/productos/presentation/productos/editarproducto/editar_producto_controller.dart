import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:managegym/db/database_connection.dart';
import 'package:managegym/main_screen/widgets/connection/categoriaModel.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/connection/producto_model.dart';

class EditarProductoController extends GetxController {
  final nombreProductoController = TextEditingController();
  final codigoBarrasController = TextEditingController();
  final stockInicialController = TextEditingController();
  final precioController = TextEditingController();
  final descripcionController = TextEditingController();

  final isImageSelected = false.obs;
  final selectedImagePath = Rx<String?>(null);
  final imagenBase64 = Rx<String?>(null);

  final categoriaSeleccionada = Rx<Categoria?>(null);
  final categorias = <Categoria>[].obs;

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  int? idProducto;
  int? idCodigoBarras;
  String? codigoBarrasOriginal;

  void cargarCategoriasYSeleccionar(List<Categoria> cats) {
    categorias.assignAll(cats);
    if (idProducto != null && categorias.isNotEmpty) {
      if (categoriaSeleccionada.value == null) {
        final prodCategoriaId = categoriaSeleccionada.value?.id ?? categorias.first.id;
        categoriaSeleccionada.value = categorias.firstWhereOrNull((cat) => cat.id == prodCategoriaId) ?? categorias.first;
      }
    }
    if (categoriaSeleccionada.value == null && categorias.isNotEmpty) {
      categoriaSeleccionada.value = categorias.first;
    }
  }

  void initializeProducto(Producto producto) {
    idProducto = producto.id;
    idCodigoBarras = producto.idCodigoBarras;
    codigoBarrasOriginal = producto.codigoBarras ?? '';
    nombreProductoController.text = producto.titulo;
    codigoBarrasController.text = producto.codigoBarras ?? '';
    stockInicialController.text = producto.stock.toString();
    precioController.text = producto.precioVenta.toStringAsFixed(2);
    descripcionController.text = producto.descripcion ?? '';
    imagenBase64.value = producto.imagenProducto;
    if (producto.idCategoria != null && categorias.isNotEmpty) {
      categoriaSeleccionada.value = categorias.firstWhereOrNull((cat) => cat.id == producto.idCategoria);
    } else {
      categoriaSeleccionada.value = null;
    }
    selectedImagePath.value = null;
    isImageSelected.value = false;
  }

  void cambiarCategoria(Categoria? categoria) {
    categoriaSeleccionada.value = categoria;
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
  }

  Future<bool> actualizarProducto() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;

        if (categoriaSeleccionada.value == null) {
          Get.snackbar('Error', 'Por favor selecciona una categoría',
              backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
          isLoading.value = false;
          return false;
        }
        if (idProducto == null) {
          Get.snackbar('Error', 'ID de producto no válido',
              backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
          isLoading.value = false;
          return false;
        }

        final double precio = double.tryParse(precioController.text) ?? 0.0;
        final int stock = int.tryParse(stockInicialController.text) ?? 0;
        final int? idCategoria = categoriaSeleccionada.value?.id;

        String? nuevaImagenBase64 = imagenBase64.value;
        if (isImageSelected.value && selectedImagePath.value != null) {
          File imageFile = File(selectedImagePath.value!);
          List<int> imageBytes = await imageFile.readAsBytes();
          nuevaImagenBase64 = base64Encode(imageBytes);
        }

        // --- ACTUALIZACIÓN DE CÓDIGO DE BARRAS ---
        int? nuevoIdCodigoBarras = idCodigoBarras;
        String codigoIngresado = codigoBarrasController.text.trim();

        if (codigoIngresado != codigoBarrasOriginal) {
          // Si se cambió el código de barras, crea uno nuevo y usa su ID
          if (codigoIngresado.isNotEmpty) {
            nuevoIdCodigoBarras = await ProductoDB.insertarCodigoBarras(
              codigoBarras: codigoIngresado,
              conn: Database.conn,
            );
            if (nuevoIdCodigoBarras == null) {
              Get.snackbar('Error', 'No se pudo actualizar el código de barras',
                  backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
              isLoading.value = false;
              return false;
            }
          } else {
            // Si se borra el código de barras, asigna null
            nuevoIdCodigoBarras = null;
          }
        }

        final bool exito = await ProductoDB.editarProducto(
          id: idProducto!,
          titulo: nombreProductoController.text,
          descripcion: descripcionController.text,
          precioVenta: precio,
          stock: stock,
          idCategoria: idCategoria,
          idCodigoBarras: nuevoIdCodigoBarras,
          imagenProducto: nuevaImagenBase64,
          conn: Database.conn,
        );

        if (exito) {
          Get.snackbar('Éxito', 'Producto actualizado correctamente',
              backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
          // Actualiza el estado interno
          idCodigoBarras = nuevoIdCodigoBarras;
          codigoBarrasOriginal = codigoIngresado;
          return true;
        } else {
          Get.snackbar('Error', 'No se pudo actualizar el producto',
              backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
          return false;
        }
      } catch (e) {
        print('Error al actualizar producto: $e');
        Get.snackbar('Error', 'Ocurrió un error: $e',
            backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
        return false;
      } finally {
        isLoading.value = false;
      }
    }
    return false;
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