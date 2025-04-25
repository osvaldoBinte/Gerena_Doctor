
import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';


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
        color: colores.colorCabezeraTabla,
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text("Nombre", 
              style: TextStyle(
                  color: colores.colorTexto,
                  fontWeight: FontWeight.bold,
                  fontSize: 17))),
          Expanded(flex: 1, child: Text("Precio", 
              style: TextStyle(
                  color: colores.colorTexto,
                  fontWeight: FontWeight.bold,
                  fontSize: 17))),
          Expanded(flex: 1, child: Text("Cantidad", 
              style: TextStyle(
                  color: colores.colorTexto,
                  fontWeight: FontWeight.bold,
                  fontSize: 17))),
          Expanded(flex: 2, child: Text("Total" ,
              style: TextStyle(
                  color: colores.colorTexto,
                  fontWeight: FontWeight.bold,
                  fontSize: 17))),
        ],
      ),
    );
  }
}
