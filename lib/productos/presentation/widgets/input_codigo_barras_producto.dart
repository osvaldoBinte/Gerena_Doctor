import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';

class InputCodigoDeBarrasProductoWidget extends StatelessWidget {
  const InputCodigoDeBarrasProductoWidget({
    super.key,
    required this.codigoBarrasController,
  });

  final TextEditingController codigoBarrasController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormField(
        style: TextStyle(color: colores.colorTexto),
        controller: codigoBarrasController,
        validator: (value) {
          return null;
        },
        decoration:  InputDecoration(
          labelText: 'Codigo de barra',
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
