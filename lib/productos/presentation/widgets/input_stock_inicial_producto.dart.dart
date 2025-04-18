import 'package:flutter/material.dart';

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
        decoration: const InputDecoration(
          labelText: 'Cantidad de stock inicial',
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
