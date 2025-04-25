import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/main_screen/screens/home_screen.dart';
import 'package:managegym/main_screen/screens/store/store_controller.dart';
import 'package:managegym/productos/presentation/productos/filter/filter_button.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/modal_agregar_producto.dart';
import 'package:managegym/productos/presentation/productos/agregarstock/modal_agregar_stock.dart';
import 'package:managegym/productos/presentation/productos/editarproducto/modal_editar_producto.widget.dart';
import 'package:managegym/shared/admin_colors.dart';

class StoreScreen extends StatelessWidget {
  StoreScreen({Key? key}) : super(key: key);

  final AdminColors colores = AdminColors();
  final StoreController storeController = Get.put(StoreController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ... (Todo igual hasta la tabla)
        // Cabecera de la tabla
        Container(
          width: double.infinity,
          height: 50,
          color: colores.colorCabezeraTabla,
          child: Row(
            children: [
              const Expanded(
                flex: 2,
                child: SizedBox(),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Nombre',
                  style: TextStyle(
                    color: colores.colorTexto,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Categoría',
                  style: TextStyle(
                    color: colores.colorTexto,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Precio unitario',
                  style: TextStyle(
                    color: colores.colorTexto,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Cantidad disponible',
                  style: TextStyle(
                    color: colores.colorTexto,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Código de barras',
                  style: TextStyle(
                    color: colores.colorTexto,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Disponible',
                  style: TextStyle(
                    color: colores.colorTexto,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                child: SizedBox(),
              ),
            ],
          ),
        ),
        // Contenido de la tabla (lista de productos) con Obx para reactividad
        Expanded(
          child: Obx(() {
            if (storeController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: colores.colorTexto,
                ),
              );
            }

            if (storeController.filteredProductos.isEmpty) {
              return Center(
                child: Text(
                  'No se encontraron productos',
                  style: TextStyle(
                    color: colores.colorTexto,
                    fontSize: 18,
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: storeController.refreshProductos,
              child: ListView.builder(
                itemCount: storeController.filteredProductos.length,
                itemBuilder: (context, index) {
                  final producto = storeController.filteredProductos[index];
                  final bool disponible = producto.stock > 0;

                  return ProductRowWidget(
                    producto: producto,
                    image: (producto.imagenProducto != null && producto.imagenProducto!.isNotEmpty)
                        ? Container(
                            margin: const EdgeInsets.all(12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Image.file(
                                  File(producto.imagenProducto!),
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 70,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: const Icon(Icons.broken_image, color: Colors.white54, size: 40),
                                      ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.all(12),
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                color: Colors.orange,
                                size: 40,
                              ),
                            ),
                          ),
                    nombre: producto.titulo,
                    categoria: 'Categoría', // Aquí puedes poner el nombre real si lo obtienes
                    precioUnitario: '\$${producto.precioVenta.toStringAsFixed(2)}',
                    cantidadDisponible: '${producto.stock}',
                    codigoBarras: producto.idCodigoBarras?.toString() ?? 'N/A',
                    disponible: disponible ? 'Sí' : 'No',
                    index: index,
                    onDelete: () => storeController.deleteProducto(producto.id),
                    onUpdateStock: (cantidad) => storeController.updateStock(producto.id, cantidad),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}

class ProductRowWidget extends StatefulWidget {
  final Widget? image;
  final String nombre;
  final String categoria;
  final String precioUnitario;
  final String cantidadDisponible;
  final String codigoBarras;
  final String disponible;
  final int index;
  final dynamic producto; // El producto completo para pasarlo al modal de edición
  final VoidCallback? onDelete;
  final Function(int)? onUpdateStock;

  const ProductRowWidget({
    Key? key,
    this.image,
    required this.nombre,
    required this.categoria,
    required this.precioUnitario,
    required this.cantidadDisponible,
    required this.codigoBarras,
    required this.disponible,
    required this.index,
    this.producto,
    this.onDelete,
    this.onUpdateStock,
  }) : super(key: key);

  @override
  State<ProductRowWidget> createState() => _ProductRowWidgetState();
}

class _ProductRowWidgetState extends State<ProductRowWidget> {
  bool isHovering = false;
  bool isFocused = false;
  final FocusNode _focusNode = FocusNode();
  final AdminColors colores = AdminColors();

  Color getRowColor() {
    if (isHovering || isFocused) {
      return colores.colorHoverRow; // Color de selección
    }
    return widget.index % 2 == 0
        ? colores.colorRowPar
        : colores.colorRowNoPar; // Color alternante
  }

  Widget buildDisponibleBadge() {
    bool disponible = widget.disponible == 'Sí';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: disponible ? Colors.green[400] : Colors.red[400],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        disponible ? 'Sí' : 'No',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: getRowColor(),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isHovering
            ? [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.12),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : [],
      ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: Row(
        children: [
          // Imagen
          Expanded(flex: 2, child: widget.image ?? const SizedBox()),
          // Nombre
          Expanded(
            flex: 3,
            child: Text(
              widget.nombre,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Categoría
          Expanded(
            flex: 3,
            child: Text(
              widget.categoria,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Precio unitario
          Expanded(
            flex: 2,
            child: Text(
              widget.precioUnitario,
              style: const TextStyle(
                color: Color(0xFFFFA726),
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Cantidad disponible
          Expanded(
            flex: 2,
            child: Text(
              widget.cantidadDisponible,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Código de barras
          Expanded(
            flex: 3,
            child: Text(
              widget.codigoBarras,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Disponible
          Expanded(
            flex: 1,
            child: Center(child: buildDisponibleBadge()),
          ),
          // IconButton para gestionar stock
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.inventory, color: colores.colorTexto, size: 28),
                  tooltip: 'Agregar stock',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ModalAgregarStock(
                          idProducto: widget.producto?.id,
                          nombreProducto: widget.nombre,
                          producto: widget.producto,
                          onStockUpdated: (cantidad) {
                            if (widget.onUpdateStock != null) {
                              widget.onUpdateStock!(cantidad);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}