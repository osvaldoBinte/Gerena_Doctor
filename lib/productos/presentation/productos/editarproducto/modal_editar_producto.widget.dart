import 'dart:io';
import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/main_screen/widgets/connection/categoriaController.dart';
import 'package:managegym/main_screen/widgets/connection/categoriaModel.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/connection/producto_model.dart';
import 'package:managegym/productos/presentation/productos/editarproducto/editar_producto_controller.dart';
import 'package:managegym/productos/presentation/widgets/input_codigo_barras_producto.dart';
import 'package:managegym/productos/presentation/widgets/input_nombre_producto.dart';
import 'package:managegym/productos/presentation/widgets/input_precio_producto.dart';
import 'package:managegym/productos/presentation/widgets/input_stock_inicial_producto.dart.dart';
import 'package:managegym/shared/admin_colors.dart';

class ModalEditarProducto extends StatelessWidget {
  final Producto? producto;
  final AdminColors colors = AdminColors();

  ModalEditarProducto({Key? key, this.producto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditarProductoController controller = Get.put(EditarProductoController());
    final CategoriaController categoriaController =
        Get.isRegistered<CategoriaController>()
            ? Get.find<CategoriaController>()
            : Get.put(CategoriaController());

    // Siempre cargar categorías y luego inicializar el producto
    return FutureBuilder(
      future: categoriaController.cargarCategorias(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        // Sincroniza categorías y selecciona la del producto
        controller.cargarCategoriasYSeleccionar(categoriaController.categorias);

        // Solo ahora inicializa el producto (esto es seguro porque ya tienes las categorías correctas)
        if (producto != null && controller.idProducto == null) {
          controller.initializeProducto(producto!);
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
                  'MODIFICAR PRODUCTO',
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
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InputNombreProductoWidget(
                                nombreProductoController: controller.nombreProductoController,
                              ),
                              const SizedBox(height: 15),
                              InputCodigoDeBarrasProductoWidget(
                                codigoBarrasController: controller.codigoBarrasController,
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: InputPrecioProductoWidget(
                                      precioController: controller.precioController,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: InputStockInicialProductoWidget(
                                      stockInicialController: controller.stockInicialController,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Obx(() {
                                if (controller.categorias.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Text(
                                      'No hay categorías disponibles',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                }
                                return DropdownButtonFormField<Categoria>(
                                  value: controller.categoriaSeleccionada.value,
                                  items: controller.categorias
                                      .map((categoria) => DropdownMenuItem<Categoria>(
                                            value: categoria,
                                            child: Text(
                                              categoria.titulo,
                                              style: TextStyle(color: colors.colorTexto),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    controller.cambiarCategoria(value);
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
                                  ),
                                  dropdownColor: colors.colorFondoModal,
                                  hint: Text(
                                    "Seleccionar categoría",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      // Columna derecha: Imagen
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Obx(() {
                            final bool hasNewImage = controller.isImageSelected.value;
                            final bool hasOldImage = controller.imagenBase64.value != null && controller.imagenBase64.value!.isNotEmpty;
                            return DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(16),
                              dashPattern: [8, 4],
                              color: Colors.orange,
                              strokeWidth: 2,
                              child: InkWell(
                                onTap: controller.selectImage,
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: (hasNewImage || hasOldImage)
                                        ? Colors.transparent
                                        : Colors.orange.withOpacity(0.06),
                                  ),
                                  child: hasNewImage
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: Image.file(
                                            File(controller.selectedImagePath.value!),
                                            fit: BoxFit.cover,
                                            width: 180,
                                            height: 180,
                                          ),
                                        )
                                      : hasOldImage
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(16),
                                              child: Image.memory(
                                                base64Decode(controller.imagenBase64.value!),
                                                fit: BoxFit.cover,
                                                width: 180,
                                                height: 180,
                                                errorBuilder: (context, error, stackTrace) =>
                                                    Icon(Icons.broken_image, color: Colors.orange, size: 60),
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
                          onTap: controller.isLoading.value
                              ? null
                              : () async {
                                  final categoria = controller.categoriaSeleccionada.value;
                                  if (categoria == null) {
                                    Get.snackbar('Error', 'Selecciona una categoría');
                                    return;
                                  }
                                  final actualizado = await controller.actualizarProducto();
                                  if (actualizado == true) {
                                    Navigator.of(context).pop(true);
                                  }
                                },
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            width: 300,
                            height: 50,
                            decoration: BoxDecoration(
                              color: controller.isLoading.value
                                  ? Colors.grey
                                  : Color.fromARGB(255, 255, 131, 55),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: controller.isLoading.value
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                      'ACTUALIZAR PRODUCTO',
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
      },
    );
  }
}