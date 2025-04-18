import 'package:flutter/material.dart';

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
        style: TextStyle(color: colorTextoDark),
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
        decoration: const InputDecoration(
          labelText: 'Nombre del producto',
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
