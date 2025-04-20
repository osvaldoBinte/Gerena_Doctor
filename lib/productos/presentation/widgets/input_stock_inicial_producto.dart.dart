import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';

class InputStockInicialProductoWidget extends StatelessWidget {
  const InputStockInicialProductoWidget({
    super.key,
    required this.colorTextoDark,
    required this.stockInicialController,
  });

  final Color colorTextoDark;
  final TextEditingController stockInicialController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormField(
        style: TextStyle(color: colorTextoDark),
        controller: stockInicialController,
        validator: (value) {
          //validar que sea un numero
          if (value == null || value.isEmpty) {
            return 'Campo requerido';
          }
          if (double.tryParse(value) == null) {
            return 'El precio debe ser un número';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        decoration:  InputDecoration(
          labelText: 'Cantidad de stock inicial',
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
