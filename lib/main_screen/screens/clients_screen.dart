import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/header_table_clients_home_widget.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';
import 'package:managegym/shared/admin_colors.dart';

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

AdminColors colores = AdminColors();

class _ClientsScreenState extends State<ClientsScreen> {
  String actualmonth = meses[DateTime.now().month - 1];

  // Estados para botones de filtro
  bool hoverButtontodosLosClientes = false;
  bool hoverButtonSuscripccionesApuntoExpirar = false;
  bool hoverButtonNuevosClientes = false;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Botones para filtrar usuarios
        Row(
          children: [
            SizedBox(
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                highlightColor: const Color.fromARGB(255, 167, 85, 85),
                onTap: () {
                  setState(() {
                    index = 0;
                  });
                },
                onHover: (value) {
                  setState(() {
                    hoverButtontodosLosClientes = value;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  decoration: BoxDecoration(
                    color: (index == 0 || hoverButtontodosLosClientes)
                        ? Colors.orange
                        : Colors.black,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "Todos los clientes",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                  });
                },
                onHover: (value) {
                  setState(() {
                    hoverButtonSuscripccionesApuntoExpirar = value;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  decoration: BoxDecoration(
                    color: (index == 1 || hoverButtonSuscripccionesApuntoExpirar)
                        ? Colors.orange
                        : Colors.black,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "Suscripcciones a punto de expirar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                  });
                },
                onHover: (value) {
                  setState(() {
                    hoverButtonNuevosClientes = value;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  decoration: BoxDecoration(
                    color: (index == 2 || hoverButtonNuevosClientes)
                        ? Colors.orange
                        : Colors.black,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "Nuevos clientes",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 800,
              height: 50,
              child: TextField(
                style: TextStyle(color: colores.colorTexto),
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
              style: TextStyle(
                  fontSize: 20,
                  color: colores.colorTexto,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
        const SizedBox(height: 20),
        const HeaderTableClientsHome(),
        SizedBox(
          height: MediaQuery.of(context).size.height - 300,
          width: double.infinity,
          child: ListView.builder(
            itemCount: 60, // <-- Aquí deberías usar la cantidad real de clientes
            itemBuilder: (context, index) {
              return RowTableClientsHomeWidget(
                index: index,
                idUsuario: index, // <-- Cambia esto por el id real del usuario
                name: "Cliente $index",
                phoneNumber: "555-000-$index",
                lastSubscription: "Básica",
                status: "Activo",
                dateRange: "01/01/2025 - 01/02/2025",
                sex: "M",
                suscripcionesDisponibles: const [], // Llena esto con tus datos reales de suscripciones
              );
            },
          ),
        ),
      ],
    );
  }
}