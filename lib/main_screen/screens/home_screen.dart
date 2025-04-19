import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/clientes/presentation/widgets/header_table_clients_home_widget.dart';
import 'package:managegym/clientes/presentation/widgets/modal_register_client_widget.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';
import 'package:managegym/productos/presentation/widgets/modal_agregar_producto.dart';
import 'package:managegym/suscripcciones/connection/agregarSuscripcion/suscrpcionController.dart';
import 'package:managegym/suscripcciones/presentation/widgets/card_subscription_widget.dart';
import 'package:managegym/suscripcciones/presentation/widgets/modal_agregar_suscripcion.dart';
import 'package:managegym/suscripcciones/connection/agregarSuscripcion/SuscrpcionModel.dart';

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

  // Inicia el controlador de GetX (una sola vez por pantalla)
  final SuscripcionController suscripcionController = Get.put(SuscripcionController());

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
              "${DateTime.now().day} de $actualmonth del ${DateTime.now().year}",
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
                        return const ModalAgregarSuscripccion();
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
        // LISTADO DINÁMICO DE SUSCRIPCIONES CON GETX
        Expanded(
          child: Obx(() {
            if (suscripcionController.cargando.value) {
              return const Center(child: CircularProgressIndicator());
            }
            final suscripciones = suscripcionController.suscripciones;
            if (suscripciones.isEmpty) {
              return const Center(child: Text("No hay suscripciones"));
            }
            final ScrollController scrollController = ScrollController();
            return Scrollbar(
              thumbVisibility: true,
              controller: scrollController,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 20,
                  runSpacing: 20,
                  children: suscripciones
                      .map((s) => CardSubscriptionWidget(
                            suscripcion: s,
                          ))
                      .toList(),
                ),
              ),
            );
          }),
        ),
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

// Define esto en tu proyecto real
class RowTableClientsHome {}