import 'package:flutter/material.dart';
import 'package:managegym/main_screen/screens/home_screen.dart';
import 'package:managegym/productos/presentation/widgets/filter_button.dart';
import 'package:managegym/productos/presentation/widgets/modal_agregar_producto.dart';
import 'package:managegym/productos/presentation/widgets/modal_agregar_stock.dart';
import 'package:managegym/productos/presentation/widgets/modal_editar_producto.widget.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //botones de accion rapidas
            SizedBox(
              child: Row(
                children: [
                  QuickActionButton(
                    text: 'AGREGAR UN NUEVO PRODUCTO',
                    icon: Icons.person_add,
                    accion: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ModalAgregarProducto();
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  QuickActionButton(
                    text: 'REALIZAR UNA VENTA',
                    icon: Icons.person_add,
                    accion: () {
                  
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 800,
              height: 50,
              child: TextField(
                onChanged: (value) => {},
                style: const TextStyle(
                    color: Colors.white), // Cambia el color del texto a blanco
                decoration: InputDecoration(
                  hintText: 'Buscar Producto por nombre o codigo de barras',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 255, 255, 255), width: 8),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        //botones para filtrar
        Row(
          children: [
            FilterButton(
              text: 'Ordenar por nombre',
              onChanged: (isAscending) {
                // Lógica para ordenar por nombre
              },
            ),
            const SizedBox(width: 10),
            FilterButton(
              text: 'Ordenar por precio',
              onChanged: (isAscending) {
                // Lógica para ordenar por precio
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 50,
          color: const Color(0xFF181818),
          child: const Row(
            children: [
              // Espacio para la imagen
              const Expanded(
                flex: 2,
                child: SizedBox(),
              ),
              // Nombre
              const Expanded(
                flex: 3,
                child: Text(
                  'Nombre',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              // Categoría
              const Expanded(
                flex: 3,
                child: Text(
                  'Categoría',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              // Precio unitario
              const Expanded(
                flex: 2,
                child: Text(
                  'Precio unitario',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              // Cantidad disponible
              const Expanded(
                flex: 2,
                child: Text(
                  'Cantidad disponible',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              // Código de barras
              const Expanded(
                flex: 3,
                child: Text(
                  'Código de barras',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              // Disponible
              const Expanded(
                flex: 1,
                child: Text(
                  'Disponible',
                  style: TextStyle(
                    color: Colors.white,
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
        Expanded(
          child: ListView.builder(
            itemCount:
                20, // Cambia esto por la cantidad de productos que tengas
            itemBuilder: (context, index) {
              return ProductRowWidget(
                image: null, // O tu widget de imagen
                nombre: 'Producto $index',
                categoria: 'Categoría $index',
                precioUnitario: '\$${(index + 1) * 10}',
                cantidadDisponible: '${(index + 1) * 5}',
                codigoBarras: '00000$index',
                disponible: index % 2 == 0 ? 'Sí' : 'No',
                index: index,
              );
            },
          ),
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

  const ProductRowWidget({
    super.key,
    this.image,
    required this.nombre,
    required this.categoria,
    required this.precioUnitario,
    required this.cantidadDisponible,
    required this.codigoBarras,
    required this.disponible,
    required this.index,
  });

  @override
  State<ProductRowWidget> createState() => _ProductRowWidgetState();
}

class _ProductRowWidgetState extends State<ProductRowWidget> {
  bool isHovering = false;
  bool isFocused = false;
  final FocusNode _focusNode = FocusNode();

  Color getRowColor() {
    if (isHovering || isFocused) {
      return const Color.fromARGB(255, 255, 131, 55); // Color de selección
    }
    return widget.index % 2 == 0
        ? const Color.fromARGB(255, 33, 33, 33)
        : const Color.fromARGB(255, 54, 54, 54);
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
            flex: 15, // Suma de los flex de los siguientes Expanded (2+3+3+2+2+3+1=16, puedes ajustar)
            child: InkWell(
              focusNode: _focusNode,
              borderRadius: BorderRadius.circular(0),
              onTap: () {
                // Aquí abres tu modal
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ModalEditarProducto(
                   
                    );
                  },
                );
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
                      style: const TextStyle(
                        color: Colors.white,
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
                      style: const TextStyle(
                        color: Colors.white,
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
                      style: const TextStyle(
                        color: Colors.white,
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
                      style: const TextStyle(
                        color: Colors.white,
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
                      style: const TextStyle(
                        color: Colors.white,
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
                      style: const TextStyle(
                        color: Colors.white,
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
          // IconButton final fuera del InkWell
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.inventory, color: Colors.white, size: 28),
              tooltip: 'Ver stock',
              onPressed: () {
                // Aquí abre tu modal de stock o realiza la acción deseada
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return  ModalAgregarStock();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
