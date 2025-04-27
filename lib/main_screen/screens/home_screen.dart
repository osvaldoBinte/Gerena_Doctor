import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/clientes/presentation/widgets/header_table_clients_home_widget.dart';
import 'package:managegym/clientes/presentation/widgets/modal_register_client_widget.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/modal_agregar_producto.dart';
import 'package:managegym/shared/admin_colors.dart';
import 'package:managegym/suscripcciones/connection/agregarSuscripcion/suscrpcionController.dart';
import 'package:managegym/suscripcciones/presentation/widgets/card_subscription_widget.dart';
import 'package:managegym/suscripcciones/presentation/widgets/modal_agregar_suscripcion.dart';
import 'package:managegym/suscripcciones/connection/agregarSuscripcion/SuscrpcionModel.dart';
import 'package:managegym/main_screen/connection/registrarUsuario/registrarUsuarioModel.dart';
import 'package:managegym/db/database_connection.dart';

class UsuarioExtraInfo {
  final Usuario usuario;
  final int diasRestantes;
  final String ultimaMembresia;
  UsuarioExtraInfo({
    required this.usuario,
    required this.diasRestantes,
    required this.ultimaMembresia,
  });
}

class HomeScreen extends StatefulWidget {
  final void Function(int) onChangeIndex;
  const HomeScreen({super.key, required this.onChangeIndex});

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
  BuildContext context,
  List<TipoMembresia> suscripciones,
  VoidCallback onRegistroExitoso,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ModalRegisterClientWidget(
        suscripcionesDisponibles: suscripciones,
        onRegistroExitoso: onRegistroExitoso,
      );
    },
  );
}

class _HomeScreenState extends State<HomeScreen> {
  String actualmonth = meses[DateTime.now().month - 1];
  final SuscripcionController suscripcionController =
      Get.put(SuscripcionController());

  List<UsuarioExtraInfo> usuarios = [];
  List<UsuarioExtraInfo> usuariosFiltrados = [];
  bool usuariosCargando = true;
  final TextEditingController _searchController = TextEditingController();

  AdminColors colores = AdminColors();

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> cargarUsuarios() async {
    setState(() => usuariosCargando = true);
    try {
      final conn = Database.conn;
      final lista = await UsuarioDB.obtenerUsuarios(conn: conn);
      final usuariosInfo = <UsuarioExtraInfo>[];
      for (final usuario in lista) {
        final dias = await UsuarioDB.obtenerDiasMembresiaRestantes(
          idUsuario: usuario.id,
          conn: conn,
        );
        final titulo = await UsuarioDB.obtenerTituloUltimaMembresiaActiva(
          idUsuario: usuario.id,
          conn: conn,
        );
        usuariosInfo.add(UsuarioExtraInfo(
          usuario: usuario,
          diasRestantes: dias,
          ultimaMembresia: titulo,
        ));
      }
      setState(() {
        usuarios = usuariosInfo;
        _aplicarFiltro();
        usuariosCargando = false;
      });
    } catch (e) {
      print('Error al cargar usuarios: $e');
      setState(() {
        usuarios = [];
        usuariosFiltrados = [];
        usuariosCargando = false;
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      _aplicarFiltro();
    });
  }

  void _aplicarFiltro() {
    String filtro = _searchController.text.toLowerCase();
    if (filtro.isEmpty) {
      usuariosFiltrados = List.from(usuarios);
    } else {
      usuariosFiltrados = usuarios.where((info) {
        final usuario = info.usuario;
        final nombreCompleto = "${usuario.nombre} ${usuario.apellidos}".toLowerCase();
        return nombreCompleto.contains(filtro) || usuario.telefono.toLowerCase().contains(filtro);
      }).toList();
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
                controller: _searchController,
                style: TextStyle(color: colores.colorTexto),
                decoration: InputDecoration(
                  hintText: 'Buscar cliente por nombre o numero de telefono',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: colores.colorTexto, width: 8),
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
          ],
        ),
        const SizedBox(height: 20),
        const HeaderTableClientsHome(), // <--- Nombre corregido
        SizedBox(
          height: 360,
          width: double.infinity,
          child: usuariosCargando
              ? const Center(child: CircularProgressIndicator())
              : usuarios.isEmpty
                  ? Center(child: Text("No hay usuarios registrados", style: TextStyle(color: colores.colorTexto, fontSize: 18)))
                  : ListView.builder(
                      itemCount: usuariosFiltrados.length,
                      itemBuilder: (context, index) {
                        final usuarioInfo = usuariosFiltrados[index];
                        final usuario = usuarioInfo.usuario;
                        final diasRestantes = usuarioInfo.diasRestantes;
                        final ultimaMembresia = usuarioInfo.ultimaMembresia;
                        return RowTableClientsHomeWidget(
                          index: index,
                          idUsuario: usuario.id,
                          name: "${usuario.nombre} ${usuario.apellidos}",
                          phoneNumber: usuario.telefono,
                          lastSubscription: ultimaMembresia,
                          status: usuario.status ?? "activo",
                          dateRange: "$diasRestantes días",
                          sex: usuario.sexo,
                          suscripcionesDisponibles: suscripcionController.suscripciones,
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
                    context,
                    suscripcionController.suscripciones,
                    cargarUsuarios,
                  );
                },
              ),
              const SizedBox(width: 20),
              QuickActionButton(
                text: 'AGREGAR UNA NUEVA SUSCRIPCCION',
                icon: Icons.notes_outlined,
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
                icon: Icons.add,
                accion: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ModalAgregarProducto();
                    },
                  );
                },
              ),
              const SizedBox(width: 20),
              QuickActionButton(
                text: 'REALIZAR UNA VENTA',
                icon: Icons.point_of_sale,
                accion: () {
                  widget.onChangeIndex(4);
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Text(
              "MIS SUSCRIPCCIONES",
              style: TextStyle(
                color: colores.colorTexto,
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
              return Center(child: Text("No hay suscripciones" , style: TextStyle(color: colores.colorTexto, fontSize: 18)));
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
    final AdminColors colores = AdminColors();
    return InkWell(
      onTap: () {
        accion();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: colores.colorAccionButtons,
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