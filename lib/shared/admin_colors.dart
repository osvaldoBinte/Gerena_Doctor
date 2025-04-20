import 'package:flutter/material.dart';

class AdminColors with ChangeNotifier {
  static final AdminColors _instance = AdminColors._internal();

  factory AdminColors() => _instance;

  AdminColors._internal();

  // Colores actuales
  late Color colorFondo;
  late Color colornavbar;
  late Color colorTexto;
  late Color colorCabezeraTabla;
  late Color colorRowPar;
  late Color colorRowNoPar;
  late Color colorFondoModal;
  late Color colorAccionButtons;
  late Color colorCancelar;
  late Color colorBotonNavbar;
  late Color colorHoverRow;

  void setDarkTheme() {
    colorFondo = const Color.fromARGB(255, 33, 33, 33);
    colornavbar = const Color.fromARGB(255, 19, 19, 19);
    colorTexto = Colors.white;
    colorCabezeraTabla = const Color(0xFF333333);
    colorRowPar = const Color.fromARGB(255, 33, 33, 33);
    colorRowNoPar = const Color.fromARGB(255, 54, 54, 54);
    colorFondoModal = const Color.fromARGB(255, 40, 40, 40);
    colorAccionButtons = const Color.fromARGB(255, 255, 131, 55);
    colorCancelar = const Color(0xFFFF4B37);
    colorBotonNavbar =  Colors.black;
    colorHoverRow = const Color.fromARGB(255, 255, 131, 55);
    notifyListeners();
  }

  void setLightTheme() {
    colorFondo = Colors.white;
    colorTexto = Colors.black;
    colornavbar = const Color(0xFFF5F5F5);
    colorCabezeraTabla = const Color(0xFFF5F5F5);
    colorRowPar = const Color(0xFFF0F0F0);
    colorRowNoPar = const Color(0xFFFFFFFF);
    colorFondoModal = const Color(0xFFF8F8F8);
     colorAccionButtons = const Color.fromARGB(255, 255, 131, 55);
    colorCancelar = Colors.red;
    colorBotonNavbar =  const Color.fromARGB(255, 255, 255, 255);
    colorHoverRow = const Color.fromARGB(255, 255, 131, 55);
    notifyListeners();
  }
}