import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/clientes/presentation/widgets/header_table_clients_home_widget.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';
import 'package:managegym/shared/admin_colors.dart';
import 'package:managegym/suscripcciones/connection/agregarSuscripcion/suscrpcionController.dart';
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

List<String> meses = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
];

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  String actualmonth = meses[DateTime.now().month - 1];
  final SuscripcionController suscripcionController = Get.put(SuscripcionController());

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
        const HeaderTableClientsHome(),
        SizedBox(
          height: MediaQuery.of(context).size.height - 300,
          width: double.infinity,
          child: usuariosCargando
              ? const Center(child: CircularProgressIndicator())
              : usuariosFiltrados.isEmpty
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
                          onSuscripcionActualizada: cargarUsuarios,
                        );
                      },
                    ),
        ),
      ],
    );
  }
}