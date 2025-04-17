import 'package:flutter/material.dart';

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

        label: const Text('Sexo',
            style: TextStyle(color: Colors.white)),
        textStyle: const TextStyle(color: Colors.white),
        inputDecorationTheme: const InputDecorationTheme(
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