import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/connection/producto_model.dart';
import 'package:managegym/productos/presentation/productos/agregarstock/agregar_stock_controller.dart';
import 'package:managegym/shared/admin_colors.dart';

class ModalAgregarStock extends StatelessWidget {
  final int? idProducto;
  final String? nombreProducto;
  final Producto? producto;
  final Function(int)? onStockUpdated;
  
  ModalAgregarStock({
    Key? key,
    this.idProducto,
    this.nombreProducto,
    this.producto,
    this.onStockUpdated,
  }) : super(key: key) {
    // Inicializar el controlador con los parámetros recibidos
    final controller = Get.put(AgregarStockController());
    
    if (idProducto != null) {
      controller.idProducto.value = idProducto!;
    }
    
    if (nombreProducto != null) {
      controller.nombreProducto.value = nombreProducto!;
    }
    
    if (producto != null) {
      controller.producto.value = producto;
      controller.idProducto.value = producto!.id;
      controller.nombreProducto.value = producto!.titulo;
    }
    
    if (onStockUpdated != null) {
      controller.onStockUpdated = onStockUpdated;
    }
  }

  final Color colorTextoDark = const Color.fromARGB(255, 255, 255, 255);
  final Color colorFondoDark = const Color.fromARGB(255, 33, 33, 33);
  final AdminColors colores = AdminColors();

  @override
  Widget build(BuildContext context) {
    // Obtener el controlador
    final AgregarStockController controller = Get.find<AgregarStockController>();
    
    return AlertDialog(
      backgroundColor: colores.colorFondoModal,
      content: Container(
        width: 400,
        height: 400,
        child: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Column(
                    children: [
                      Text(
                        'AGREGAR STOCK',
                        style: TextStyle(
                          color: colores.colorTexto,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(() => Text(
                        controller.nombreProducto.value.isNotEmpty
                          ? controller.nombreProducto.value
                          : 'Producto seleccionado',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colores.colorTexto,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      const SizedBox(height: 20),
                      Form(
                        key: controller.formKey,
                        child: TextFormField(
                          style: TextStyle(color: colores.colorTexto),
                          controller: controller.cantidadController,
                          validator: controller.validarCantidad,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Cantidad a agregar',
                            labelStyle: TextStyle(color: colores.colorTexto),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colores.colorTexto),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colores.colorTexto),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Mostrar stock actual si está disponible
                      if (controller.producto.value != null)
                        Text(
                          'Stock actual: ${controller.producto.value!.stock}',
                          style: TextStyle(
                            color: colores.colorTexto,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: controller.isLoading.value
                        ? null
                        : () async {
                            final bool exito = await controller.agregarStock();
                            if (exito) {
                              Navigator.of(context).pop(true);
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
                                'AGREGAR STOCK',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                )
              ],
            ),
          ),
      ),
    );
  }
}