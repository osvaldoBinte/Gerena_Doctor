
import 'package:flutter/material.dart';


class TitleBarProductos extends StatelessWidget {
  const TitleBarProductos({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 40, 40, 40),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text("Nombre", 
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17))),
          Expanded(flex: 1, child: Text("Precio", 
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17))),
          Expanded(flex: 1, child: Text("Cantidad", 
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17))),
          Expanded(flex: 2, child: Text("Total" ,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17))),
        ],
      ),
    );
  }
}
