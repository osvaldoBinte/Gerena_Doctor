import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';

class HeaderTableClientsHome extends StatelessWidget {
  const HeaderTableClientsHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration:  BoxDecoration(
          color:  colores.colorCabezeraTabla,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3, // Ocupa 2 partes del espacio
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child:  Text(
                  'Nombre',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: colores.colorTexto, fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ),
            Expanded(
              flex: 1, // Ocupa 3 partes del espacio
              child: Container(
                height: 50,
                padding: const EdgeInsets.all(2),
                child:  Text(
                  'No. telefono',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: colores.colorTexto, fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ),
            Expanded(
              flex: 3, // Ocupa 1 parte del espacio
              child: Container(
                height: 50,
                padding: const EdgeInsets.all(2),
                child:  Text(
                  'Ultima suscripccion',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: colores.colorTexto, fontWeight: FontWeight.bold , fontSize: 17),
                ),
              ),
            ),
            Expanded(
              flex: 1, // Ocupa 1 parte del espacio
              child: Container(
                height: 50,
                padding: const EdgeInsets.all(2),
                child:  Text(
                  'Status',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: colores.colorTexto, fontWeight: FontWeight.bold , fontSize: 17),
                ),
              ),
            ),
            Expanded(
              flex: 3, // Ocupa 1 parte del espacio
              child: Container(
                height: 50,
                padding: const EdgeInsets.all(2),
                child:  Text(
                  'Rango de fecha',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: colores.colorTexto, fontWeight: FontWeight.bold , fontSize: 17),
                ),
              ),
            ),
            Expanded(
              flex: 1, // Ocupa 1 parte del espacio
              child: Container(
                height: 50,
                padding: const EdgeInsets.all(2),
                child:  Text(
                  'Sexo',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: colores.colorTexto, fontWeight: FontWeight.bold , fontSize: 17),
                ),  
              ),
            ),
             Expanded(
              flex: 2   , // Ocupa 1 parte del espacio
              child: Container(
                height: 50,
                padding: const EdgeInsets.all(2),
              ),
            ),
          ],
        ));
  }
}
