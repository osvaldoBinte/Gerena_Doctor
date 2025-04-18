import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/header_table_clients_home_widget.dart';
import 'package:managegym/clientes/presentation/widgets/modal_register_client_widget.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';
import 'package:managegym/productos/presentation/widgets/modal_agregar_producto.dart';
import 'package:managegym/suscripcciones/presentation/widgets/card_subscription_widget.dart';
import 'package:managegym/suscripcciones/presentation/widgets/modal_agregar_suscripcion.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
int? hoveringIndex;

void _showModalRegisterUser(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const ModalRegisterClientWidget();
    },
  );
}

class _HomeScreenState extends State<HomeScreen> {
  String actualmonth = meses[DateTime.now().month - 1];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose(); // Limpia el controlador al destruir el widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              "${DateTime.now().day} de ${actualmonth} del ${DateTime.now().year}",
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const HeaderTableClientsHome(), //cabezera de la tabla
        SizedBox(
          //coontenedor de la lista de clientes registrados
          height: 450,
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
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: Row(
            //botones de acceso rapido

            children: [
              QuickActionButton(
                text: 'REGISTRAR UN NUEVO USUARIO',
                icon: Icons.person_add,
                accion: () {
                  _showModalRegisterUser(context);
                },
              ),
              const SizedBox(width: 20),
              QuickActionButton(
                text: 'AGREGAR UNA NUEVA SUSCRIPCCION',
                icon: Icons.person_add,
                accion: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ModalAgregarSuscripccion();
                      });
                },
              ),
              const SizedBox(width: 20),
              QuickActionButton(
                text: 'AGREGAR UN NUEVO PRODUCTO',
                icon: Icons.person_add,
                accion: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const ModalAgregarProducto();
                    },
                  );
                },
              ),
              const SizedBox(width: 20),
              QuickActionButton(
                text: 'REALIZAR UNA VENTA',
                icon: Icons.person_add,
                accion: () {
                  Navigator.pushNamed(
                      context, '/venta'); // Navegar a la pantalla de venta
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Row(
          children: [
            Text(
              "MIS SUSCRIPCCIONES",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            width: double.infinity, // Abarca todo el ancho disponible
            height: double.infinity,
            child: Scrollbar(
              thumbVisibility: true,
              controller:
                  _scrollController, // Controlador para el desplazamiento
              child: SingleChildScrollView(
                controller:
                    _scrollController, // se asigna el controlador del scrollbar
                scrollDirection:
                    Axis.vertical, // Habilita el desplazamiento vertical
                child: const Wrap(
                  spacing: 20, // Espaciado horizontal entre tarjetas
                  runSpacing: 20, // Espaciado vertical entre filas
                  children: [
                    CardSubscriptionWidget(),
                    CardSubscriptionWidget(),
                    CardSubscriptionWidget(),
                    CardSubscriptionWidget(),
                    CardSubscriptionWidget(),
                    CardSubscriptionWidget(),
                    CardSubscriptionWidget(),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class QuickActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function() accion;
  const QuickActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.accion,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Acción al hacer clic en el botón "Ver más"
        accion();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 131, 55),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 5),
            Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class RowTableClientsHome {}
