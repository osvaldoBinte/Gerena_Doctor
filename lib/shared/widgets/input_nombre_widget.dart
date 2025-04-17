import 'package:flutter/material.dart';

class InputNombreWidget extends StatelessWidget {
  const InputNombreWidget({
    super.key,
    required this.colorTextoDark,
    required TextEditingController nombreController,
  }) : _nombreController = nombreController;

  final Color colorTextoDark;
  final TextEditingController _nombreController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormField(
        style: TextStyle(color: colorTextoDark),
        controller: _nombreController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo requerido';
          }
          if (value.length < 3) {
            return 'El nombre debe tener al menos 3 caracteres';
          }
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Nombre',
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
