import 'package:flutter/material.dart';
import 'package:managegym/shared/admin_colors.dart';

class RowProductoVenta extends StatefulWidget {
  final String nombre;
  final String precio;
  final String stock;
  final String? codigoBarras;
  final Color colorTexto;
  final int index;
  final Function(int)? onTap;

  const RowProductoVenta({
    Key? key,
    required this.nombre,
    required this.precio,
    required this.stock,
    this.codigoBarras,
    required this.colorTexto,
    required this.index,
    this.onTap,
  }) : super(key: key);

  @override
  State<RowProductoVenta> createState() => _RowProductoVentaState();
}

class _RowProductoVentaState extends State<RowProductoVenta> {
  bool _isHovered = false;
  bool _isFocused = false;
  final AdminColors colores = AdminColors();

  Color getRowColor() {
    if (_isHovered || _isFocused) {
      return colores.colorHoverRow; // Color de selección
    }
    if (widget.index % 2 == 0) {
      return colores.colorRowPar; // Color de fila par
    } else {
      return colores.colorRowNoPar; // Color de fila impar
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: FocusableActionDetector(
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        child: InkWell(
          onTap: () => widget.onTap?.call(widget.index),
          child: Container(
            width: double.infinity,
            height: 40,
            color: getRowColor(),
            child: Row(
              children: [
                // Nombre del producto
                Expanded(
                  flex: 2,
                  child: Text(
                    widget.nombre,
                    style: TextStyle(color: widget.colorTexto),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Precio
                Expanded(
                  flex: 1,
                  child: Text(
                    '\$${widget.precio}',
                    style: TextStyle(color: widget.colorTexto),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Stock
                Expanded(
                  flex: 1,
                  child: Text(
                    widget.stock,
                    style: TextStyle(color: widget.colorTexto),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Código de barras
                widget.codigoBarras != null && widget.codigoBarras != 'N/A'
                    ? Expanded(
                        flex: 2,
                        child: Text(
                          widget.codigoBarras!,
                          style: TextStyle(color: widget.colorTexto),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : Expanded(
                        flex: 2,
                        child: Text(
                          'Sin código',
                          style: TextStyle(
                            color: widget.colorTexto.withOpacity(0.5),
                            fontStyle: FontStyle.italic,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}