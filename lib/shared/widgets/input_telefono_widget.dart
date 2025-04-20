import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';


class InputTelefonoWidget extends StatelessWidget {
  const InputTelefonoWidget({
    super.key,
    required TextEditingController telefonoController,
  }) : _telefonoController = telefonoController;

  final TextEditingController _telefonoController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormField(
        style: TextStyle(color: colores.colorTexto),
        controller: _telefonoController,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo requerido';
          }
          if (value.length < 10) {
            return 'El telefono debe tener al menos 10 digitos';
          }
          return null;
        },
        decoration:  InputDecoration(
          labelText: 'Numero de telefono',
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