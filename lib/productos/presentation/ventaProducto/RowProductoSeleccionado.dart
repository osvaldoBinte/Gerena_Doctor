import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/shared/admin_colors.dart';

class RowProductoSeleccionado extends StatelessWidget {
  final String nombre;
  final String precio;
  final RxInt? cantidadRx;
  final String index;
  final VoidCallback? onRemove;
  final Function(int)? onChangeQuantity;
  
  const RowProductoSeleccionado({
    Key? key, 
    required this.nombre, 
    required this.precio, 
    required this.cantidadRx, 
    required this.index,
    this.onRemove,
    this.onChangeQuantity,
  }) : super(key: key);

  // Calcula el color de fondo basado en el índice
  Color isPair() {
    final AdminColors colores = AdminColors();
    return int.parse(index) % 2 == 0 
        ? colores.colorRowPar 
        : colores.colorRowNoPar;
  }

  @override
  Widget build(BuildContext context) {
    final AdminColors colores = AdminColors();
    final double precioDouble = double.parse(precio);
    
    return Container(
      width: double.infinity,
      height: 40,
      color: isPair(),
      child: Row(
        children: [
          // Nombre del producto
          Expanded(
            flex: 4,
            child: Text(
              nombre,
              style: TextStyle(
                color: colores.colorTexto,
                fontSize: 17
              ),
              overflow: TextOverflow.ellipsis,
            )
          ),
          
          // Precio unitario
          Expanded(
            flex: 2,
            child: Text(
              '\$${precio}',
              style: TextStyle(
                color: colores.colorTexto,
                fontSize: 17
              ),
              overflow: TextOverflow.ellipsis,
            )
          ),
          
          // Cantidad (editable)
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: colores.colorTexto, size: 16),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () {
                    if (cantidadRx != null && onChangeQuantity != null) {
                      int newQuantity = cantidadRx!.value - 1;
                      if (newQuantity > 0) {
                        onChangeQuantity!(newQuantity);
                      } else if (onRemove != null) {
                        onRemove!();
                      }
                    }
                  },
                ),
                SizedBox(width: 8),
                Obx(() => Text(
                  cantidadRx?.value.toString() ?? "0",
                  style: TextStyle(
                    color: colores.colorTexto,
                    fontSize: 17
                  ),
                )),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.add, color: colores.colorTexto, size: 16),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () {
                    if (cantidadRx != null && onChangeQuantity != null) {
                      int newQuantity = cantidadRx!.value + 1;
                      onChangeQuantity!(newQuantity);
                    }
                  },
                ),
              ],
            )
          ),
          
          // Subtotal
          Expanded(
            flex: 3,
            child: Obx(() {
              double subtotal = precioDouble * (cantidadRx?.value ?? 0);
              return Text(
                '\$${subtotal.toStringAsFixed(2)}',
                style: TextStyle(
                  color: colores.colorTexto,
                  fontSize: 17
                ),
                overflow: TextOverflow.ellipsis,
              );
            })
          ),
          
          // Botón eliminar
          Expanded(
            flex: 2, 
            child: IconButton(
              onPressed: onRemove,
              icon: Icon(Icons.delete_forever, color: colores.colorTexto),
              tooltip: 'Eliminar producto',
            )
          ),
        ],
      ),
    );
  }
}