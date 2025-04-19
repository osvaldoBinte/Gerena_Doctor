import 'package:flutter/material.dart';


class RowClienteVenta extends StatefulWidget {
  final String nombre;
  final String telefono;
  final Color colorTexto;
  final int index;
  final void Function(int index)? onTap;

  const RowClienteVenta({
    super.key,
    required this.nombre,
    required this.telefono,
    required this.colorTexto,
    required this.index,
    this.onTap,
  });

  @override
  State<RowClienteVenta> createState() => _RowClienteVentaState();
}

class _RowClienteVentaState extends State<RowClienteVenta> {
  bool _isHovered = false;
  bool _isFocused = false;

  Color isPair(int index) {
    if (_isHovered || _isFocused) {
      return const Color.fromARGB(255, 255, 131, 55); // Color de selección
    }
    if (index % 2 == 0) {
      return const Color.fromARGB(255, 40, 40, 40);
    } else {
      return const Color.fromARGB(255, 50, 50, 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onShowHoverHighlight: (hovering) {
        setState(() {
          _isHovered = hovering;
        });
      },
      onShowFocusHighlight: (focusing) {
        setState(() {
          _isFocused = focusing;
        });
      },
      child: InkWell(
        onTap: () => widget.onTap?.call(widget.index),
        child: Container(
          width: double.infinity,
          height: 40,
          color: isPair(widget.index),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  widget.nombre,
                  style: TextStyle(color: widget.colorTexto),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  widget.telefono,
                  style: TextStyle(color: widget.colorTexto),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}