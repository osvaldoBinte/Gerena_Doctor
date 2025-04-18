import 'package:flutter/material.dart';

class InputCodigoDeBarrasProductoWidget extends StatelessWidget {
  const InputCodigoDeBarrasProductoWidget({
    super.key,
    required this.colorTextoDark,
    required this.codigoBarrasController,
  });

  final Color colorTextoDark;
  final TextEditingController codigoBarrasController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormField(
        style: TextStyle(color: colorTextoDark),
        controller: codigoBarrasController,
        validator: (value) {
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Codigo de barra',
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
