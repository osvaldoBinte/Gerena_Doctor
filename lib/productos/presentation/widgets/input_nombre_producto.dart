import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';
import 'package:managegym/shared/admin_colors.dart';

class InputNombreProductoWidget extends StatelessWidget {
  const InputNombreProductoWidget({
    super.key,
    required this.colorTextoDark,
    required this.nombreProductoController,
  });

  final Color colorTextoDark;
  final TextEditingController nombreProductoController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormField(
        style: TextStyle(color: colores.colorTexto),
        controller: nombreProductoController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo requerido';
          }
          if (value.length < 3) {
            return 'El apellido debe tener al menos 3 caracteres';
          }
          return null;
        },
        decoration:  InputDecoration(
          labelText: 'Nombre del producto',
          labelStyle: TextStyle(color: colores.colorTexto),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colores.colorTexto),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colores.colorTexto),
          ),
        ),
      ),
    );
  }
}
