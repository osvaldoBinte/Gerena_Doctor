import 'package:flutter/material.dart';


class InputTelefonoWidget extends StatelessWidget {
  const InputTelefonoWidget({
    super.key,
    required this.colorTextoDark,
    required TextEditingController telefonoController,
  }) : _telefonoController = telefonoController;

  final Color colorTextoDark;
  final TextEditingController _telefonoController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormField(
        style: TextStyle(color: colorTextoDark),
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
        decoration: const InputDecoration(
          labelText: 'Numero de telefono',
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