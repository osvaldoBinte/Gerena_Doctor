import 'package:flutter/material.dart';

class HeaderTableClientsHome extends StatelessWidget {
  const HeaderTableClientsHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color:  Color.fromARGB(255, 40, 40, 40),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3, // Ocupa 2 partes del espacio
              child: Container(
                height: 50,
                color: const Color.fromARGB(255, 40, 40, 40),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: const Text(
                  'Nombre',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ),
            Expanded(
              flex: 1, // Ocupa 3 partes del espacio
              child: Container(
                height: 50,
                color: const Color.fromARGB(255, 40, 40, 40),
                padding: const EdgeInsets.all(2),
                child: const Text(
                  'No. telefono',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ),
            Expanded(
              flex: 3, // Ocupa 1 parte del espacio
              child: Container(
                height: 50,
                color: const Color.fromARGB(255, 40, 40, 40),
                padding: const EdgeInsets.all(2),
                child: const Text(
                  'Ultima suscripccion',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold , fontSize: 17),
                ),
              ),
            ),
            Expanded(
              flex: 1, // Ocupa 1 parte del espacio
              child: Container(
                height: 50,
                color: const Color.fromARGB(255, 40, 40, 40),
                padding: const EdgeInsets.all(2),
                child: const Text(
                  'Status',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold , fontSize: 17),
                ),
              ),
            ),
            Expanded(
              flex: 3, // Ocupa 1 parte del espacio
              child: Container(
                height: 50,
                color: const Color.fromARGB(255, 40, 40, 40),
                padding: const EdgeInsets.all(2),
                child: const Text(
                  'Rango de fecha',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold , fontSize: 17),
                ),
              ),
            ),
            Expanded(
              flex: 1, // Ocupa 1 parte del espacio
              child: Container(
                height: 50,
                color: const Color.fromARGB(255, 40, 40, 40),
                padding: const EdgeInsets.all(2),
                child: const Text(
                  'Sexo',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold , fontSize: 17),
                ),  
              ),
            ),
             Expanded(
              flex: 2   , // Ocupa 1 parte del espacio
              child: Container(
                height: 50,
                color: const Color.fromARGB(255, 40, 40, 40),
                padding: const EdgeInsets.all(2),
              ),
            ),
          ],
        ));
  }
}
