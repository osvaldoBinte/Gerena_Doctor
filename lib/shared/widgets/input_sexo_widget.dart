import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';

class InputSexoWidget extends StatelessWidget {
  final String? sexoController;
  final Function(String?) onSelected;
  
  InputSexoWidget({
    super.key, required this.sexoController, required this.onSelected, 
  });

    List<String> sexo = [
      
    'Masculino',
    'Femenino',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: DropdownMenu<String>(
        initialSelection: "",
        width: 400,
        onSelected: onSelected,
        
        dropdownMenuEntries: sexo
            .map((sexo) => DropdownMenuEntry<String>(
                  value: sexo,
                  label: sexo,
                ))
            .toList(),

        label:  Text('Sexo',
            style: TextStyle(color: colores.colorTexto)),
        textStyle:  TextStyle(color: colores.colorTexto),
        inputDecorationTheme:  InputDecorationTheme(
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