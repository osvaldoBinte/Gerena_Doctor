import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/header_table_clients_home_widget.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

List<String> meses = [
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Mayo',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre'
];

class _ClientsScreenState extends State<ClientsScreen> {
  String actualmonth = meses[DateTime.now().month - 1];
  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        //boton para filtrar a los usuarios
        Row(
          children: [
            Text(
              'Clientes',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 800,
              height: 50,
              child: TextField(
                style: const TextStyle(
                    color: Colors.white), // Cambia el color del texto a blanco
                decoration: InputDecoration(
                  hintText: 'Buscar cliente por nombre o numero de telefono',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 255, 255, 255), width: 8),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
            Text(
              "${DateTime.now().day} de $actualmonth del ${DateTime.now().year}",
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        HeaderTableClientsHome(),
        SizedBox(
          //coontenedor de la lista de clientes registrados
          height: //maximo 450
              MediaQuery.of(context).size.height - 300,
          width: double.infinity,
          child: ListView.builder(
            itemCount: 60,
            itemBuilder: (context, index) {
              return RowTableClientsHomeWidget(
                index: index,
                name: "luis antonio martinez marroquin",
                phoneNumber: "2292134420",
                lastSubscription: "Suscripccion basica de un año",
                status: "activo",
                dateRange: "12/12/12 - 12/12/13",
                sex: "H",
              );
            },
          ),
        ),
      ],
    );
  }
}
