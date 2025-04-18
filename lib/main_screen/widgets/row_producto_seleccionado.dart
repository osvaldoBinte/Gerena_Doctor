import 'package:flutter/material.dart';



class RowProductoSeleccionado extends StatelessWidget {
  final String nombre;
  final String precio;
  final String cantidad;
  final String index;
  
  const RowProductoSeleccionado({
    super.key, required this.nombre, required this.precio, required this.cantidad, required this.index,
  });

  Color isPair(){
    if(int.parse(index) % 2 == 0){
      return const Color.fromARGB(255, 40, 40, 40);
    }else{
      return const Color.fromARGB(255, 33, 33, 33);
    }
  }

  @override
  Widget build(BuildContext context) {

    return  Container(
      width: double.infinity,
      height: 40,
      color: isPair(),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text("Nombre",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17))),
          Expanded(
              flex: 1,
              child: Text("Precio",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17))),
          Expanded(
              flex: 1,
              child: Text("Cantidad",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17))),
          Expanded(
              flex: 2,
              child: Text("Total",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17))),
        ],
      ),
    );
  }
}
