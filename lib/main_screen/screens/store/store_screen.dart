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
  
  // Instanciar el controlador de tienda
  final StoreController storeController = Get.put(StoreController());
  
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
                    icon: Icons.add_box_outlined,
                    accion: () {
                      showDialog(
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
              text: 'Ordenar por nombre ${storeController.activeSort.value == 'name' 
                ? (storeController.sortByNameAsc.value ? '↑' : '↓') 
                : ''}',
              onChanged: (isAscending) {
                storeController.sortByName();
              },
              isActive: storeController.activeSort.value == 'name',
            )),
            const SizedBox(width: 10),
            // Botón para ordenar por precio
            Obx(() => FilterButton(
              text: 'Ordenar por precio ${storeController.activeSort.value == 'price' 
                ? (storeController.sortByPriceAsc.value ? '↑' : '↓') 
                : ''}',
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
              const Expanded(
                flex: 2,
                child: SizedBox(),
              ),
              // Nombre
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
              // Categoría
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
              // Precio unitario
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
              // Cantidad disponible
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
              // Código de barras
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
              // Disponible
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
                  
                  return ProductRowWidget(
                    producto: producto,
                    image: null, // O tu widget de imagen
                    nombre: producto.titulo,
                    categoria: 'Categoría', // Necesitarías obtener el nombre de la categoría
                    precioUnitario: '\$${producto.precioVenta.toStringAsFixed(2)}',
                    cantidadDisponible: '${producto.stock}',
                    codigoBarras: 'N/A', // Reemplazar con el código de barras real si lo tienes
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

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      color: getRowColor(),
      child: Row(
        children: [
          // InkWell para toda la fila menos el icono
          Expanded(
            flex: 15,
            child: InkWell(
              focusNode: _focusNode,
              borderRadius: BorderRadius.circular(0),
              onTap: () {
                // Aquí abres tu modal de edición
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ModalEditarProducto();
                  },
                ).then((value) {
                  // Recargar productos después de editar
                  if (value == true) {
                    Get.find<StoreController>().loadProductos();
                  }
                });
              },
              onHover: (hovering) {
                setState(() {
                  isHovering = hovering;
                });
              },
              onFocusChange: (focus) {
                setState(() {
                  isFocused = focus;
                });
              },
              child: Row(
                children: [
                  // Imagen o espacio vacío
                  Expanded(
                    flex: 2,
                    child: widget.image ??
                        Container(
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              color: Colors.white54,
                              size: 40,
                            ),
                          ),
                        ),
                  ),
                  // Nombre
                  Expanded(
                    flex: 3,
                    child: Text(
                      widget.nombre,
                      style: TextStyle(
                        color: colores.colorTexto,
                        fontSize: 18,
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
                        fontSize: 18,
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
                        fontSize: 20,
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
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Disponible
                  Expanded(
                    flex: 1,
                    child: Text(
                      widget.disponible,
                      style: TextStyle(
                        color: colores.colorTexto,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
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
                    // Abre el modal de agregar stock
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ModalAgregarStock(
                         
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