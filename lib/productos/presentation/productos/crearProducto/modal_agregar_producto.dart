import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/main_screen/widgets/connection/categoriaController.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/producto_controller.dart';
import 'package:managegym/productos/presentation/widgets/input_codigo_barras_producto.dart';
import 'package:managegym/productos/presentation/widgets/input_nombre_producto.dart';
import 'package:managegym/productos/presentation/widgets/input_precio_producto.dart';
import 'package:managegym/productos/presentation/widgets/input_stock_inicial_producto.dart.dart';
import 'package:managegym/shared/admin_colors.dart';

class ModalAgregarProducto extends StatelessWidget {
  ModalAgregarProducto({Key? key}) : super(key: key);

  final AdminColors colors = AdminColors();
  final ProductoController productoController = Get.put(ProductoController());

  @override
  Widget build(BuildContext context) {
    final TIpoMembresiaController categoriaController =
        Get.isRegistered<TIpoMembresiaController>()
            ? Get.find<TIpoMembresiaController>()
            : Get.put(TIpoMembresiaController());

    if (categoriaController.categorias.isEmpty) {
      categoriaController.cargarCategorias().then((_) {
        productoController.categorias.assignAll(categoriaController.titulosCategorias);
        productoController.categoriaSeleccionada.value = null;
      });
    } else {
      productoController.categorias.assignAll(categoriaController.titulosCategorias);
      productoController.categoriaSeleccionada.value = null;
    }

    return AlertDialog(
      backgroundColor: colors.colorFondoModal,
      content: Container(
        width: 900,
        height: 500,
        child: Column(
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
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna izquierda: Inputs
                  Expanded(
                    flex: 2,
                    child: Form(
                      key: productoController.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputNombreProductoWidget(
                            nombreProductoController: productoController.nombreProductoController,
                          ),
                          const SizedBox(height: 15),
                          InputCodigoDeBarrasProductoWidget(
                            codigoBarrasController: productoController.codigoBarrasController,
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: InputPrecioProductoWidget(
                                  precioController: productoController.precioController,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: InputStockInicialProductoWidget(
                                  stockInicialController: productoController.stockInicialController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Obx(() {
                            if (productoController.categorias.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  'No hay categorías disponibles',
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            }
                            return DropdownButtonFormField<String>(
                              value: productoController.categoriaSeleccionada.value,
                              items: productoController.categorias
                                  .map((categoria) => DropdownMenuItem<String>(
                                        value: categoria,
                                        child: Text(
                                          categoria,
                                          style: TextStyle(color: colors.colorTexto),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                productoController.cambiarCategoria(value);
                              },
                              decoration: InputDecoration(
                                labelText: 'Categoría',
                                labelStyle: TextStyle(color: colors.colorTexto),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: colors.colorTexto),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: colors.colorTexto),
                                ),
                                // Elimina hintText/hintStyle y usa `hint`:
                              ),
                              dropdownColor: colors.colorFondoModal,
                              hint: Text(
                                "Seleccionar categoría",
                                style: TextStyle(color: Colors.white), // <-- BLANCO AQUÍ, FUNCIONA SIEMPRE
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  // Columna derecha: Imagen (solo preview y tap para seleccionar)
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Obx(() {
                        final bool hasImage = productoController.isImageSelected.value;
                        return DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(16),
                          dashPattern: [8, 4],
                          color: Colors.orange,
                          strokeWidth: 2,
                          child: InkWell(
                            onTap: productoController.selectImage,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: hasImage
                                    ? Colors.transparent
                                    : Colors.orange.withOpacity(0.06),
                              ),
                              child: hasImage
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.file(
                                        File(productoController.selectedImagePath.value!),
                                        fit: BoxFit.cover,
                                        width: 180,
                                        height: 180,
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_a_photo,
                                            color: Colors.orange, size: 60),
                                        SizedBox(height: 10),
                                        Text(
                                          "Click para seleccionar\nuna imagen",
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Botones abajo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => InkWell(
                      onTap: productoController.isLoading.value
                          ? null
                          : productoController.guardarProducto,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 300,
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    )),
                InkWell(
                  onTap: () {
                    productoController.limpiarCampos();
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 150,
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}