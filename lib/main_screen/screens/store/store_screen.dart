import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/main_screen/screens/home_screen.dart';
import 'package:managegym/main_screen/screens/store/store_controller.dart';
import 'package:managegym/main_screen/widgets/connection/categoriaController.dart';
import 'package:managegym/main_screen/widgets/modal_categorias.dart';
import 'package:managegym/productos/presentation/productos/editarproducto/modal_editar_producto.widget.dart';
import 'package:managegym/productos/presentation/productos/filter/filter_button.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/modal_agregar_producto.dart';
import 'package:managegym/productos/presentation/productos/agregarstock/modal_agregar_stock.dart';
import 'package:managegym/shared/admin_colors.dart';

class StoreScreen extends StatelessWidget {
  final void Function(int) onChangeIndex;
  StoreScreen({Key? key, required this.onChangeIndex}) : super(key: key);

  final AdminColors colores = AdminColors();

  // Instanciar el controlador de tienda
  final StoreController storeController = Get.put(StoreController());
  // Instanciar el controlador de categorías (si no está registrado)
  final CategoriaController categoriaController =
      Get.put(CategoriaController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botones de acción rápida
            SizedBox(
              child: Row(
                children: [
                  QuickActionButton(
                    text: 'AGREGAR UN NUEVO PRODUCTO',
                    icon: Icons.add,
                    accion: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return ModalAgregarProducto();
                        },
                      ).then((_) {
                        // Recargar productos después de cerrar el modal
                        storeController.loadProductos();
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  QuickActionButton(
                    text: 'REALIZAR UNA VENTA',
                    icon: Icons.point_of_sale,
                    accion: () {
                      // Lógica para realizar una venta
                      onChangeIndex(4); 
                    },
                  ),
                  const SizedBox(width: 20),
                  QuickActionButton(
                    text: 'AGREGAR CATEGORIAS',
                    icon: Icons.add,
                    accion: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ModalCategorias();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            // Campo de búsqueda
            SizedBox(
              width: 800,
              height: 50,
              child: TextField(
                controller: storeController.searchController,
                onChanged: (value) => storeController.searchProductos(value),
                style: TextStyle(color: colores.colorTexto),
                decoration: InputDecoration(
                  hintText: 'Buscar Producto por nombre o código de barras',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: colores.colorTexto, width: 8),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Botones para filtrar
        Row(
          children: [
            // Botón para ordenar por nombre
            Obx(() => FilterButton(
                  text:
                      'Ordenar por nombre ${storeController.activeSort.value == 'name' ? (storeController.sortByNameAsc.value ? '↑' : '↓') : ''}',
                  onChanged: (isAscending) {
                    storeController.sortByName();
                  },
                  isActive: storeController.activeSort.value == 'name',
                )),
            const SizedBox(width: 10),
            // Botón para ordenar por precio
            Obx(() => FilterButton(
                  text:
                      'Ordenar por precio ${storeController.activeSort.value == 'price' ? (storeController.sortByPriceAsc.value ? '↑' : '↓') : ''}',
                  onChanged: (isAscending) {
                    storeController.sortByPrice();
                  },
                  isActive: storeController.activeSort.value == 'price',
                )),
          ],
        ),
        const SizedBox(height: 20),
        // Cabecera de la tabla
        Container(
          width: double.infinity,
          height: 50,
          color: colores.colorCabezeraTabla,
          child: Row(
            children: [
              // Espacio para la imagen
              Container(
                height: 110,
                width: 110,
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

                  // Verifica si el producto tiene stock disponible
                  final bool disponible = producto.stock > 0;

                  // Buscar el nombre de la categoría usando el idCategoria del producto
                  final categoriaNombre = categoriaController.categorias
                          .firstWhereOrNull(
                              (cat) => cat.id == producto.idCategoria)
                          ?.titulo ??
                      'Sin categoría';

                  return ProductRowWidget(
                    producto: producto,
                    image: (producto.imagenProducto != null &&
                            producto.imagenProducto!.isNotEmpty)
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
                                child: _buildProductImage(
                                    producto.imagenProducto!),
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.all(12),
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(78, 206, 206, 206),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.image,
                                color: colores.colorTexto,
                                size: 40,
                              ),
                            ),
                          ),
                    nombre: producto.titulo,
                    categoria: categoriaNombre,
                    precioUnitario:
                        '\$${producto.precioVenta.toStringAsFixed(2)}',
                    cantidadDisponible: '${producto.stock}',
                    codigoBarras: producto.codigoBarras ??
                        'N/A', // Usa el código real si lo tienes
                    disponible: disponible ? 'Sí' : 'No',
                    index: index,
                    onDelete: () => storeController.deleteProducto(producto.id),
                    onUpdateStock: (cantidad) =>
                        storeController.updateStock(producto.id, cantidad),
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

Widget _buildProductImage(String base64img) {
  try {
    return Image.memory(
      base64Decode(base64img),
      fit: BoxFit.cover,
      width: 70,
      height: 70,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 70,
        height: 70,
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image, color: Colors.white54, size: 40),
      ),
    );
  } catch (e) {
    // Si hay un error al decodificar, muestra un placeholder
    return Container(
      width: 70,
      height: 70,
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, color: Colors.white54, size: 40),
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
  final dynamic
      producto; // El producto completo para pasarlo al modal de edición
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
    return InkWell(
      onTap: () {
        print('Fila seleccionada: ${widget.nombre}');
        showDialog(context: context, builder: (context){
          return ModalEditarProducto(
            producto: widget.producto,
          );
        });
      },
      onHover: (hovering) {
        setState(() {
          isHovering = hovering;
        });
      },
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: isHovering
              ? colores.colorAccionButtons // <-- Color al hacer hover/click
              : (widget.index % 2 == 0
                  ? colores.colorRowPar
                  : colores.colorRowNoPar),
        ),
        child: Row(
          children: [
            // Imagen
            SizedBox(
                height: 110,
                width: 110,
                child: widget.image ?? const SizedBox()),

            // Nombre
            Expanded(
              flex: 3,
              child: Text(
                widget.nombre,
                style: TextStyle(
                  color: colores.colorTexto,
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
                style: TextStyle(
                  color: colores.colorTexto,
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
                style: TextStyle(
                  color: colores.colorTexto,
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
                style: TextStyle(
                  color: colores.colorTexto,
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
                style: TextStyle(
                  color: colores.colorTexto,
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
            // IconButton para gestionar stock y eliminar producto
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.inventory,
                        color: colores.colorTexto, size: 28),
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
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent, size: 28),
                    tooltip: 'Eliminar producto',
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
