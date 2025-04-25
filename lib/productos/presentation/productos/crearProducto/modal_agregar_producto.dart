import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/producto_controller.dart';
import 'package:managegym/productos/presentation/widgets/input_codigo_barras_producto.dart';
import 'package:managegym/productos/presentation/widgets/input_nombre_producto.dart';
import 'package:managegym/productos/presentation/widgets/input_precio_producto.dart';
import 'package:managegym/productos/presentation/widgets/input_stock_inicial_producto.dart.dart';
import 'package:managegym/shared/admin_colors.dart';

class ModalAgregarProducto extends StatelessWidget {
  ModalAgregarProducto({Key? key}) : super(key: key);

  final Color colorTextoDark = const Color.fromARGB(255, 255, 255, 255);
  final Color colorFondoDark = const Color.fromARGB(255, 33, 33, 33);
  final AdminColors colors = AdminColors();

  // Usando GetX, instanciamos el controlador
  final ProductoController productoController = Get.put(ProductoController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colors.colorFondoModal,
      content: Container(
        width: 1300,
        height: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // FORMULARIO EN UNA COLUMNA
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AGREGAR PRODUCTO',
                  style: TextStyle(
                    color: colors.colorTexto,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: productoController.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputNombreProductoWidget(
                          colorTextoDark: colorTextoDark,
                          nombreProductoController: productoController.nombreProductoController),
                      const SizedBox(height: 20),
                      InputCodigoDeBarrasProductoWidget(
                          colorTextoDark: colorTextoDark,
                          codigoBarrasController: productoController.codigoBarrasController),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          InputPrecioProductoWidget(
                              colorTextoDark: colorTextoDark,
                              precioController: productoController.precioController),
                          const SizedBox(width: 20),
                          InputStockInicialProductoWidget(
                              colorTextoDark: colorTextoDark,
                              stockInicialController: productoController.stockInicialController),
                          SizedBox(width: 20),
                          // DropdownMenu usando Obx para reactividad
                          SizedBox(
                            width: 200,
                            child: Obx(() => DropdownMenu<String>(
                                  initialSelection: productoController.categoriaSeleccionada.value,
                                  width: 400,
                                  onSelected: (value) {
                                    productoController.cambiarCategoria(value);
                                  },
                                  dropdownMenuEntries: productoController.categorias
                                      .map((categoria) => DropdownMenuEntry<String>(
                                            value: categoria,
                                            label: categoria,
                                          ))
                                      .toList(),
                                  label: Text('Categoría',
                                      style: TextStyle(color: colors.colorTexto)),
                                  textStyle: TextStyle(color: colors.colorTexto),
                                  inputDecorationTheme: InputDecorationTheme(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: colors.colorTexto),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: colors.colorTexto),
                                    ),
                                  ),
                                )),
                          ),
                          // Botón para agregar imagen con Obx para reactividad
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: productoController.selectImage,
                            child: Container(
                              width: 200,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 131, 55),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Obx(() => Text(
                                      productoController.textoBotonImagen.value,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
            // Vista previa de la imagen con Obx para reactividad
            Container(
              width: 200,
              height: 200,
              child: Obx(() => productoController.isImageSelected.value
                  ? Image.file(
                      File(productoController.selectedImagePath.value!),
                      fit: BoxFit.cover,
                    )
                  : IconButton(
                      icon: Icon(Icons.add_a_photo, color: colors.colorTexto),
                      onPressed: productoController.selectImage,
                    )),
            ),
            // BOTONES ABAJO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => InkWell(
                      onTap: productoController.isLoading.value
                          ? null
                          : productoController.guardarProducto,
                      child: Container(
                        width: 350,
                        height: 50,
                        decoration: BoxDecoration(
                          color: productoController.isLoading.value
                              ? Colors.grey
                              : Color.fromARGB(255, 255, 131, 55),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: productoController.isLoading.value
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'GUARDAR NUEVO PRODUCTO',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    )),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 75, 55),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Text(
                        'CANCELAR',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}