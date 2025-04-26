import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';



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
      return colores.colorRowPar;
    }else{
      return colores.colorRowNoPar;
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
              flex: 4,
              child: Text("Nombre",
                  style: TextStyle(
                      color: colores.colorTexto,
                      fontSize: 17))),
          Expanded(
              flex: 2,
              child: Text("Precio",
                  style: TextStyle(
                      color: colores.colorTexto,
                      fontSize: 17))),
          Expanded(
              flex: 2,
              child: Text("Cantidad",
                  style: TextStyle(
                      color: colores.colorTexto,
                      fontSize: 17))),
          Expanded(
              flex: 3,
              child: Text("Total",
                  style: TextStyle(
                      color: colores.colorTexto,
                      fontSize: 17))),
           Expanded(flex: 2, child: IconButton(onPressed: (){
            print("Eliminar producto seleccionado $index");
           }, icon: Icon(Icons.delete_forever, color: colores.colorTexto,))),
        ],
      ),
    );
  }
}
