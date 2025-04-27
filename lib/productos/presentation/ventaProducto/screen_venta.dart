import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/main_screen/widgets/title_bar_producto_seleccionado.dart';
import 'package:managegym/productos/presentation/ventaProducto/RowProductoSeleccionado.dart';
import 'package:managegym/productos/presentation/ventaProducto/RowProductoVenta.dart';
import 'package:managegym/productos/presentation/ventaProducto/ventaProductos_controller.dart';
import 'package:managegym/shared/admin_colors.dart';

class ScreenVenta extends StatelessWidget {
  ScreenVenta({Key? key}) : super(key: key);

  final Color colorTextoDark = const Color.fromARGB(255, 255, 255, 255);
  final Color colorFondoDark = const Color.fromARGB(255, 33, 33, 33);
  final Color colorFondoModalDark = const Color.fromARGB(2, 217, 217, 217);
  final AdminColors colores = AdminColors();

  // Instanciar el controlador
  final VentaProductosController ventaController = Get.put(VentaProductosController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colores.colorFondo,
      body: SafeArea(
        child: Row(
          children: [
            // Primera columna (izquierda)
            Expanded(
              child: ContenedorIzquierdo(),
            ),
            // Segunda columna (derecha)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: colores.colorFondoModal,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "PRODUCTOS SELECCIONADOS",
                                  style: TextStyle(
                                    color: colores.colorTexto,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            const TitleBarProductos(),
                            Expanded(
                              // Usando Obx para actualización reactiva
                              child: Obx(() {
                               if (ventaController.productosCarrito.isEmpty) {

                                  return Center(
                                    child: Text(
                                      "No hay productos seleccionados",
                                      style: TextStyle(
                                        color: colores.colorTexto,
                                        fontSize: 18,
                                      ),
                                    ),
                                  );
                                }
                                
                                return ListView.builder(
                                  itemCount: ventaController.productosCarrito.length,
                                  itemBuilder: (context, index) {
                                    final productoVenta = ventaController.productosCarrito[index];
                                    return RowProductoSeleccionado(
                                      index: index.toString(),
                                      nombre: productoVenta.producto.titulo,
                                      precio: productoVenta.producto.precioVenta.toStringAsFixed(2),
                                      cantidadRx: productoVenta.cantidad,

                                      onRemove: () => ventaController.eliminarDelCarrito(index),
                                      onChangeQuantity: (newQuantity) => ventaController.cambiarCantidadProducto(index, newQuantity),

                                    );
                                  },
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ContenedorIzquierdo() {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ContainerRealizarVenta(),
          const SizedBox(height: 20),
        
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    width: 800,
                    height: 50,
                    child: TextField(
                      onChanged: (value) {
                        ventaController.buscarProductos(value);
                      },
                      controller: ventaController.buscadorProductoController,
                      style: TextStyle(color: colores.colorTexto),
                      decoration: InputDecoration(
                        hintText: 'Buscar producto por nombre o código de barras',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 8
                          ),
                        ),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 50,
                    color: colores.colorCabezeraTabla,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Nombre",
                            style: TextStyle(
                              color: colores.colorTexto,
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Precio",
                            style: TextStyle(
                              color: colores.colorTexto,
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Stock",
                            style: TextStyle(
                              color: colores.colorTexto,
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                            ),
                          ),
                        ),
                        // Expanded para el código de barras (opcional)
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Código de Barras",
                            style: TextStyle(
                              color: colores.colorTexto,
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Lista de productos encontrados
                  SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: Obx(() {
                      if (ventaController.isSearching.value) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: colores.colorTexto,
                          ),
                        );
                      }
                      
                      if (ventaController.productosEncontrados.isEmpty) {
                        return Center(
                          child: Text(
                            "No se encontraron productos",
                            style: TextStyle(
                              color: colores.colorTexto,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }
                      
                      return ListView.builder(
                        itemCount: ventaController.productosEncontrados.length,
                        itemBuilder: (context, index) {
                          final producto = ventaController.productosEncontrados[index];
                          return RowProductoVenta(
                            nombre: producto.titulo,
                            precio: producto.precioVenta.toStringAsFixed(2),
                            stock: producto.stock.toString(),
                            codigoBarras: producto.codigoBarras ?? 'N/A',
                            colorTexto: colorTextoDark,
                            index: index,
                            onTap: (i) {
                              ventaController.agregarProductoAlCarrito(producto);
                            },
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            )
          )
        ],
      ),
    );
  }

  Widget ContainerRealizarVenta() {
    return Container(
      decoration: BoxDecoration(
        color: colores.colorFondoModal,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(24),
      ),
      width: double.infinity,
      height: 390,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Form(
            key: ventaController.formKey,
            child: Column( 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "REALIZAR VENTA",
                      style: TextStyle(
                        color: colores.colorTexto,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Obx(() => Text(
                  "Total a pagar: \$${ventaController.totalVenta.value.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: colores.colorTexto,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )
                )),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      "Paga con: ",
                      style: TextStyle(
                        color: colores.colorTexto,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        style: TextStyle(color: colores.colorTexto),
                        controller: ventaController.pagoController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo requerido';
                          }
                          if (double.tryParse(value) == null) {
                            return 'El precio debe ser un número';
                          }
                          final pago = double.parse(value);
                          if (pago < ventaController.totalVenta.value) {
                            return 'Pago insuficiente';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Pesos',
                          labelStyle:
                              TextStyle(color: colores.colorTexto, fontSize: 20),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colores.colorTexto),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colores.colorTexto),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                Obx(() => Text(
                  "Cambio: \$${ventaController.cambio.value.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: colores.colorTexto,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ],
            )
          ),
          // BOTONES
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => InkWell(
                onTap: ventaController.isProcessingVenta.value 
                    ? null 
                    : () async {
                        if (ventaController.formKey.currentState!.validate()) {
                          await ventaController.procesarVenta();
                        }
                      },
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    color: ventaController.isProcessingVenta.value
                        ? Colors.grey
                        : Color.fromARGB(255, 255, 131, 55),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: ventaController.isProcessingVenta.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'REALIZAR VENTA',
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
                  ventaController.cancelarVenta();
                  // Opcional: regresar a la pantalla anterior
                  // Navigator.pushNamed(context, '/home');
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
          )
        ],
      ),
    );
  }
}