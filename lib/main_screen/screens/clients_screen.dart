import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/header_table_clients_home_widget.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';
import 'package:managegym/main_screen/widgets/custom_button_widget.dart';

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

bool hoverButtontodosLosClientes = false;
bool hoverButtonSuscripccionesApuntoExpirar = false;
bool hoverButtonNuevosClientes = false;
int index = 0;

class _ClientsScreenState extends State<ClientsScreen> {
  String actualmonth = meses[DateTime.now().month - 1];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //boton para filtrar a los usuarios
        Row(
          children: [
            SizedBox(
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                highlightColor: const Color.fromARGB(255, 167, 85, 85),
                onTap: () {
                  setState(() {
                    index = 0;
                    print("index: $index");
                  });
                },
                onHover: (value) {
                  setState(() {
                    hoverButtontodosLosClientes = value;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  decoration: BoxDecoration(
                    color: (index == 0 || hoverButtontodosLosClientes)
                        ? Colors.orange
                        : Colors.black,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text("Todos los clientes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
            SizedBox(
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                highlightColor: const Color.fromARGB(255, 167, 85, 85),
                onTap: () {
                  setState(() {
                    index = 1;
                    print("index: $index");
                  });
                },
                onHover: (value) {
                  setState(() {
                    hoverButtonSuscripccionesApuntoExpirar = value;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  decoration: BoxDecoration(
                    color:
                        (index == 1 || hoverButtonSuscripccionesApuntoExpirar)
                            ? Colors.orange
                            : Colors.black,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text("Suscripcciones a punto de expirar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
            SizedBox(
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                highlightColor: const Color.fromARGB(255, 167, 85, 85),
                onTap: () {
                  setState(() {
                    index = 2;
                    print("index: $index");
                  });
                },
                onHover: (value) {
                  setState(() {
                    hoverButtonNuevosClientes = value;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  decoration: BoxDecoration(
                    color: (index == 2 || hoverButtonNuevosClientes)
                        ? Colors.orange
                        : Colors.black,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text("Nuevos clientes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
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
                sex: "H", suscripcionesDisponibles: [],
              );
            },
          ),
        ),
      ],
    );
  }
}


