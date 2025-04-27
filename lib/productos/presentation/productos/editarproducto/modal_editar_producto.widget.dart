import 'dart:io';
import 'dart:convert'; // <-- necesario para base64
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/connection/producto_model.dart';
import 'package:managegym/productos/presentation/productos/editarproducto/editar_producto_controller.dart';
import 'package:managegym/productos/presentation/widgets/input_codigo_barras_producto.dart';
import 'package:managegym/productos/presentation/widgets/input_nombre_producto.dart';
import 'package:managegym/productos/presentation/widgets/input_precio_producto.dart';
import 'package:managegym/productos/presentation/widgets/input_stock_inicial_producto.dart.dart';
import 'package:managegym/shared/admin_colors.dart';

class ModalEditarProducto extends StatelessWidget {
  final Producto? producto;
  
  ModalEditarProducto({Key? key, this.producto}) : super(key: key) {
    final controller = Get.put(EditarProductoController());
    if (producto != null) {
      controller.initializeProducto(producto!);
    }
  }
  
  final Color colorTextoDark = const Color.fromARGB(255, 255, 255, 255);
  final Color colorFondoDark = const Color.fromARGB(255, 33, 33, 33);
  final AdminColors colores = AdminColors();
  
  @override
  Widget build(BuildContext context) {
    final EditarProductoController controller = Get.find<EditarProductoController>();
    return AlertDialog(
      backgroundColor: colores.colorFondoModal,
      content: Container(
        width: 1390,
        height: 558,
        child: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // FORMULARIO EN UNA COLUMNA
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 12,
                      child: Column(
                        children: [
                          Form(
                            key: controller.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MODIFICAR PRODUCTO',
                                  style: TextStyle(
                                    color: colores.colorTexto,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                InputNombreProductoWidget(
                                  nombreProductoController: controller.nombreProductoController
                                ),
                                const SizedBox(height: 20),
                                InputCodigoDeBarrasProductoWidget(
                                  codigoBarrasController: controller.codigoBarrasController
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    InputPrecioProductoWidget(
                                      precioController: controller.precioController
                                    ),
                                    const SizedBox(width: 20),
                                    InputStockInicialProductoWidget(
                                      stockInicialController: controller.stockInicialController
                                    ),
                                    SizedBox(width: 20),
                                    SizedBox(
                                      width: 200,
                                      child: DropdownMenu<String>(
                                        initialSelection: controller.categoriaSeleccionada.value,
                                        width: 400,
                                        onSelected: (value) {
                                          controller.cambiarCategoria(value);
                                        },
                                        dropdownMenuEntries: controller.categorias
                                            .map((categoria) => DropdownMenuEntry<String>(
                                                  value: categoria,
                                                  label: categoria,
                                                ))
                                            .toList(),
                                        label: Text('Categoría',
                                          style: TextStyle(color: colores.colorTexto)),
                                        textStyle: TextStyle(color: colores.colorTexto),
                                        inputDecorationTheme: InputDecorationTheme(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: colores.colorTexto),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: colores.colorTexto),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //boton para agregar imagen
                                    const SizedBox(width: 20),
                                    InkWell(
                                      onTap: controller.selectImage,
                                      child: Container(
                                        width: 200,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 255, 131, 55),
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: Center(
                                          child: Text(
                                            controller.textoBotonImagen.value,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
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
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton.filled(
                            onPressed: () async {
                              final bool elimado = await controller.eliminarProducto();
                              if (elimado) {
                                Navigator.of(context).pop(true); // Cerrar el modal y notificar que se eliminó
                              }
                            },
                            icon: Icon(Icons.delete_forever_outlined),
                            style: IconButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 255, 75, 55),
                            ),
                          )
                        ]
                      )
                    ),
                  ],
                ),
                // Vista previa de la imagen
                Obx(() {
                  if (controller.isImageSelected.value && controller.selectedImagePath.value != null) {
                    // Imagen NUEVA seleccionada
                    return Container(
                      width: 200,
                      height: 200,
                      child: Image.file(
                        File(controller.selectedImagePath.value!),
                        fit: BoxFit.cover,
                      ),
                    );
                  } else if (controller.imagenBase64.value != null && controller.imagenBase64.value!.isNotEmpty) {
                    // Imagen ORIGINAL en base64
                    try {
                      return Container(
                        width: 200,
                        height: 200,
                        child: Image.memory(
                          base64Decode(controller.imagenBase64.value!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 80, color: Colors.white30),
                        ),
                      );
                    } catch (e) {
                      return Container(
                        width: 200,
                        height: 200,
                        child: Icon(Icons.broken_image, size: 80, color: Colors.white30),
                      );
                    }
                  } else {
                    // Sin imagen, placeholder
                    return Container(
                      width: 200,
                      height: 200,
                      child: IconButton(
                        icon: Icon(Icons.add_a_photo, color: colores.colorTexto),
                        onPressed: controller.selectImage,
                      ),
                    );
                  }
                }),
                // BOTONES ABAJO
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: controller.isLoading.value 
                        ? null 
                        : () async {
                            final bool actualizado = await controller.actualizarProducto();
                            if (actualizado) {
                              Navigator.of(context).pop(true); // Notificar que se actualizó
                            }
                          },
                      child: Container(
                        width: 350,
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                        ),
                      ),
                    ),
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
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ),
      ),
    );
  }
}