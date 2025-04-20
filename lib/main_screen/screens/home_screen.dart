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
// IMPORTA tu modelo de usuario y base de datos:
import 'package:managegym/main_screen/connection/registrarUsuario/registrarUsuarioModel.dart';
import 'package:managegym/db/database_connection.dart';

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

void _showModalRegisterUser(
    BuildContext context, List<TipoMembresia> suscripciones) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ModalRegisterClientWidget(suscripcionesDisponibles: suscripciones);
    },
  );
}

class _HomeScreenState extends State<HomeScreen> {
  String actualmonth = meses[DateTime.now().month - 1];
  final SuscripcionController suscripcionController =
      Get.put(SuscripcionController());

  // Estados para usuarios
  List<Usuario> usuarios = [];
  bool usuariosCargando = true;

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

Future<void> cargarUsuarios() async {
  try {
    final conn = Database.conn;
    final lista = await UsuarioDB.obtenerUsuarios(conn: conn);
    print('Usuarios obtenidos: ${lista.length}');
    setState(() {
      usuarios = lista;
      usuariosCargando = false;
    });
  } catch (e) {
    print('Error al cargar usuarios: $e');
    setState(() {
      usuarios = [];
      usuariosCargando = false;
    });
  }
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
                style: const TextStyle(color: Colors.white),
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
        const HeaderTableClientsHome(),
        SizedBox(
          height: 450,
          width: double.infinity,
          child: usuariosCargando
              ? const Center(child: CircularProgressIndicator())
              : usuarios.isEmpty
                  ? const Center(child: Text("No hay usuarios registrados"))
                  : ListView.builder(
                      itemCount: usuarios.length,
                      itemBuilder: (context, index) {
                        final usuario = usuarios[index];
                        return RowTableClientsHomeWidget(
                          index: index,
                          name: "${usuario.nombre} ${usuario.apellidos}",
                          phoneNumber: usuario.telefono,
                          lastSubscription: "No implementado", // Puedes mejorar esto
                          status: usuario.status ?? "activo",
                          dateRange: usuario.fechaNacimiento != null
                              ? "${usuario.fechaNacimiento!.day}/${usuario.fechaNacimiento!.month}/${usuario.fechaNacimiento!.year}"
                              : "Sin fecha",
                          sex: usuario.sexo,
                          suscripcionesDisponibles:
                              suscripcionController.suscripciones,
                        );
                      },
                    ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              QuickActionButton(
                text: 'REGISTRAR UN NUEVO USUARIO',
                icon: Icons.person_add,
                accion: () {
                  _showModalRegisterUser(
                      context, suscripcionController.suscripciones);
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
                  Navigator.pushNamed(context, '/venta');
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