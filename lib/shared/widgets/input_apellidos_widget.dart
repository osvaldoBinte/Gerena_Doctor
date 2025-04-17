import 'package:flutter/material.dart';


class InputApellidoWidget extends StatelessWidget {
  const InputApellidoWidget({
    super.key,
    required this.colorTextoDark,
    required TextEditingController apellidosController,
  }) : _apellidosController = apellidosController;

  final Color colorTextoDark;
  final TextEditingController _apellidosController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormField(
        style: TextStyle(color: colorTextoDark),
        controller: _apellidosController,
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
          labelText: 'Apellidos',
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