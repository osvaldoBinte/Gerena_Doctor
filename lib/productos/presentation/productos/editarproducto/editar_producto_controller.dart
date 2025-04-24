import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:managegym/db/database_connection.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/producto_model.dart';

class EditarProductoController extends GetxController {
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
  
  // Producto que se está editando
  final producto = Rx<Producto?>(null);
  
  // ID de producto a editar
  final idProducto = RxInt(0);
  
  // Indicador de carga
  final isLoading = false.obs;
  
  // FormKey para validación
  final formKey = GlobalKey<FormState>();
  
  // Lista de categorías (esto podría venir de la base de datos)
  final categorias = <String>[
    'Categoria 1',
    'Categoria 2',
    'Categoria 3',
    'Categoria 4',
    'Categoria 5'
  ].obs;
  
  @override
  void onInit() {
    super.onInit();
    
    // Si se recibe un producto, inicializa los campos
    if (Get.arguments != null && Get.arguments is Producto) {
      initializeProducto(Get.arguments);
    }
  }
  
  // Método para inicializar los campos con los datos del producto
  void initializeProducto(Producto productoParaEditar) {
    producto.value = productoParaEditar;
    idProducto.value = productoParaEditar.id;
    
    // Inicializar controladores de texto
    nombreProductoController.text = productoParaEditar.titulo;
    
    // Aquí podrías agregar lógica para establecer el código de barras si lo tienes en tu modelo
    // codigoBarrasController.text = productoParaEditar.codigoBarras ?? '';
    
    stockInicialController.text = productoParaEditar.stock.toString();
    precioController.text = productoParaEditar.precioVenta.toStringAsFixed(2);
    
    // Establecer la categoría seleccionada
    if (productoParaEditar.idCategoria != null) {
      // Aquí deberías obtener el nombre de la categoría basado en su ID
      // Por ahora, establecemos un valor temporal
      categoriaSeleccionada.value = 'Categoria ${productoParaEditar.idCategoria}';
    }
    
    // Si el producto tiene una imagen, actualizamos el estado
    // Esto dependería de cómo almacenas las rutas de las imágenes
    // Si tienes un campo para la ruta de la imagen en tu modelo, podrías hacer:
    // if (productoParaEditar.imagePath != null && productoParaEditar.imagePath!.isNotEmpty) {
    //   selectedImagePath.value = productoParaEditar.imagePath;
    //   isImageSelected.value = true;
    //   textoBotonImagen.value = 'CAMBIAR IMAGEN';
    // }
  }
  
  // Método para obtener el producto desde la base de datos
  Future<void> loadProductById(int id) async {
    try {
      isLoading.value = true;
      
      // Verificar conexión a la base de datos
      try {
        Database.conn;
      } catch (e) {
        await Database.connect();
      }
      
      // Obtener el producto de la base de datos
      final productoDb = await ProductoDB.obtenerProductoPorId(
        id: id,
        conn: Database.conn
      );
      
      if (productoDb != null) {
        initializeProducto(productoDb);
      } else {
        Get.snackbar(
          'Error',
          'No se encontró el producto',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM
        );
      }
    } catch (e) {
      print('Error al cargar el producto: $e');
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
  
  // Método para actualizar un producto
  Future<bool> actualizarProducto() async {
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
          return false;
        }
        
        // Obtener ID de producto
        if (idProducto.value <= 0) {
          Get.snackbar(
            'Error',
            'ID de producto no válido',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
          );
          isLoading.value = false;
          return false;
        }
        
        // Convertir el precio y stock a los tipos correctos
        final double precio = double.tryParse(precioController.text) ?? 0.0;
        final int stock = int.tryParse(stockInicialController.text) ?? 0;
        
        // Obtener ID de categoría basado en la selección
        // En un caso real, tendríamos que buscar el ID de la categoría
        // basado en el nombre seleccionado
        int? idCategoria;
        if (categoriaSeleccionada.value != null) {
          final index = categorias.indexOf(categoriaSeleccionada.value!);
          if (index >= 0) {
            idCategoria = index + 1; // Asumiendo que los IDs empiezan en 1
          }
        }
        
        // Actualizar producto en la base de datos
        final bool exito = await ProductoDB.editarProducto(
          id: idProducto.value,
          titulo: nombreProductoController.text,
          descripcion: "", // Puedes agregar un campo para descripción si lo necesitas
          precioVenta: precio,
          stock: stock,
          idCategoria: idCategoria,
          idCodigoBarras: null, // Implementa la lógica para código de barras si es necesario
          conn: Database.conn,
        );
        
        if (exito) {
          Get.snackbar(
            'Éxito',
            'Producto actualizado correctamente',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
          );
          
          // Actualizar la imagen si es necesario
          // (esto dependería de tu modelo y de cómo manejas el almacenamiento de imágenes)
          
          return true;
        } else {
          Get.snackbar(
            'Error',
            'No se pudo actualizar el producto',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM
          );
          return false;
        }
      } catch (e) {
        print('Error al actualizar producto: $e');
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
  
  // Método para eliminar un producto
  Future<bool> eliminarProducto() async {
    try {
      isLoading.value = true;
      
      if (idProducto.value <= 0) {
        Get.snackbar(
          'Error',
          'ID de producto no válido',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM
        );
        return false;
      }
      
      // Mostrar diálogo de confirmación
      final bool confirmar = await Get.dialog(
        AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar este producto? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ) ?? false;
      
      if (!confirmar) {
        isLoading.value = false;
        return false;
      }
      
      // Eliminar producto
      final bool exito = await ProductoDB.eliminarProducto(
        id: idProducto.value,
        conn: Database.conn,
      );
      
      if (exito) {
        Get.snackbar(
          'Éxito',
          'Producto eliminado correctamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'No se pudo eliminar el producto',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM
        );
        return false;
      }
    } catch (e) {
      print('Error al eliminar producto: $e');
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