import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';
import 'package:managegym/main_screen/connection/registrarUsuario/registrarUsuarioController.dart';
import 'package:managegym/suscripcciones/connection/agregarSuscripcion/SuscrpcionModel.dart';
import 'package:managegym/suscripcciones/presentation/widgets/card_suscription_select_widget.dart';
import 'package:managegym/shared/admin_colors.dart';

class ModalAdministrarSuscripccion extends StatefulWidget {
  final List<TipoMembresia> suscripcionesDisponibles;
  final String nombreUsuario;
  final int idUsuario;

  const ModalAdministrarSuscripccion({
    super.key,
    required this.suscripcionesDisponibles,
    required this.nombreUsuario,
    required this.idUsuario,
  });

  @override
  State<ModalAdministrarSuscripccion> createState() =>
      _ModalAdministrarSuscripccionState();
}

class _ModalAdministrarSuscripccionState
    extends State<ModalAdministrarSuscripccion> {
  final Color colorTextoDark = const Color.fromARGB(255, 255, 255, 255);
  final Color colorFondoDark = const Color.fromARGB(255, 33, 33, 33);
  final ScrollController _scrollController = ScrollController();
  final UsuarioController usuarioController = Get.find<UsuarioController>();

  final TextEditingController _pagaConController = TextEditingController();
  double _cambio = 0.0;

  List<String> _suscripcionesSeleccionadas = [];
  double _totalAPagar = 0.0;

  @override
  void dispose() {
    _scrollController.dispose();
    _pagaConController.dispose();
    super.dispose();
  }

  void seleccionarSuscripcion(String id) {
    setState(() {
      if (_suscripcionesSeleccionadas.contains(id.toString())) {
        _suscripcionesSeleccionadas.remove(id.toString());
      } else {
        _suscripcionesSeleccionadas.add(id.toString());
      }
      calcularTotalAPagar();
    });
  }

  void eliminarSuscripcion(String id) {
    setState(() {
      _suscripcionesSeleccionadas.remove(id.toString());
      calcularTotalAPagar();
    });
  }

  void calcularTotalAPagar() {
    double total = 0.0;
    for (final id in _suscripcionesSeleccionadas) {
      try {
        final suscripcion = widget.suscripcionesDisponibles
            .firstWhere((s) => s.id.toString() == id);
        total += suscripcion.precio is double
            ? suscripcion.precio
            : double.tryParse(suscripcion.precio.toString()) ?? 0.0;
      } catch (_) {
        // Si no la encuentra, simplemente ignora
      }
    }
    setState(() {
      _totalAPagar = total;
      calcularCambio();
    });
  }

  void calcularCambio() {
    final pagaCon = double.tryParse(_pagaConController.text) ?? 0.0;
    setState(() {
      _cambio = pagaCon - _totalAPagar;
    });
  }

  Future<void> _procesarPago(BuildContext context) async {
    if (_suscripcionesSeleccionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona al menos una suscripción.")),
      );
      return;
    }
    final pagaCon = double.tryParse(_pagaConController.text) ?? 0.0;
    if (pagaCon < _totalAPagar) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El monto pagado es insuficiente.")),
      );
      return;
    }

    // Puedes pedir método de pago con un Dropdown en una implementación más completa.
    const metodoPago = "Efectivo";

    for (final idSus in _suscripcionesSeleccionadas) {
      final suscripcion = widget.suscripcionesDisponibles.firstWhere(
        (s) => s.id.toString() == idSus,
      );

      // 1. Crear venta de membresía
      final idVenta = await usuarioController.crearVentaMembresia(
        idTipoMembresia: suscripcion.id,
        idUsuario: widget.idUsuario,
        precio: suscripcion.precio.toDouble(),
        duracion: suscripcion.duracion,
      );

      // 2. Crear membresía encadenada (¡modificado!)
      if (idVenta != null) {
        final idMembresia = await usuarioController.crearMembresiaUsuarioEncadenada(
          idUsuario: widget.idUsuario,
          idVentaMembresia: idVenta,
          duracionDias: suscripcion.duracion,
        );

        // 3. Crear historial de pago
        if (idMembresia != null) {
          await usuarioController.crearHistorialPago(
            idMembresiaUsuario: idMembresia,
            montoPago: suscripcion.precio.toDouble(),
            metodoPago: metodoPago,
            // Puedes agregar número de referencia, fechaProximoPago, etc.
          );
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("¡Suscripción renovada/registrada con éxito!")),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colores.colorFondoModal,
      content: SizedBox(
        height: 850,
        width: 1458,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Administrar Suscripcción del usuario: ${widget.nombreUsuario}',
                  style: TextStyle(
                      color: colores.colorTexto,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
                width: double.infinity,
                height: 320,
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: GridView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.9,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: widget.suscripcionesDisponibles.length,
                    itemBuilder: (context, index) {
                      final suscripcion = widget.suscripcionesDisponibles[index];
                      return CardSuscriptionSelectWidget(
                        suscripcion: suscripcion,
                        isSelected: _suscripcionesSeleccionadas.contains(suscripcion.id.toString()),
                        selectSuscription: seleccionarSuscripcion,
                      );
                    },
                  ),
                )),
            const SizedBox(height: 20),
            HeaderTable(),
            SizedBox(
              width: double.infinity,
              height: 200,
              child: ListView.builder(
                  itemCount: _suscripcionesSeleccionadas.length,
                  itemBuilder: (context, index) {
                    final idSuscripcion = _suscripcionesSeleccionadas[index];
                    final suscripcion = widget.suscripcionesDisponibles.firstWhere((s) => s.id.toString() == idSuscripcion);
                    return RowTable(suscripcion, index);
                  }),
            ),
            const SizedBox(
              height: 22,
            ),
            Row(
              children: [
                 Text(
                  'Total a pagar: \$${_totalAPagar.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: colores.colorTexto,
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 100,
                ),
                 Text(
                  'Paga con:',
                  style: TextStyle(
                      color: colores.colorTexto,
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    controller: _pagaConController,
                    style: TextStyle(color: colores.colorTexto),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration:  InputDecoration(
                      labelStyle: TextStyle(color: colores.colorTexto),
                      icon: Icon(
                        Icons.attach_money,
                        color: colores.colorTexto,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colores.colorTexto),
                      ),
                    ),
                    onChanged: (value) => calcularCambio(),
                  ),
                ),
                const SizedBox(
                  width: 100,
                ),
                 Text(
                  'Cambio: \$${_cambio.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: colores.colorTexto,
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
           const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 75, 55),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Text(
                        'CANCELAR',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _procesarPago(context),
                  child: Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 131, 55),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Text(
                        'PAGAR',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget RowTable(TipoMembresia suscripcion, int index) {
    Color isPair(int index) {
      if (index % 2 == 0) {
        return colores.colorRowPar;
      } else {
        return colores.colorRowNoPar;
      }
    }

    return Container(
      height: 38,
      color: isPair(index),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(
                suscripcion.titulo,
                textAlign: TextAlign.start,
                style:  TextStyle(color: colores.colorTexto),
              )),
           Expanded(
              flex: 1,
              child: Text(
                '1',
                textAlign: TextAlign.start,
                style: TextStyle(color: colores.colorTexto),
              )),
          Expanded(
              flex: 2,
              child: Text(
                '${suscripcion.precio}',
                textAlign: TextAlign.start,
                style:  TextStyle(color: colores.colorTexto),
              )),
          Expanded(
              flex: 2,
              child: Text(
                '${suscripcion.precio}',
                textAlign: TextAlign.start,
                style:  TextStyle(color: colores.colorTexto),
              )),
        ],
      ),
    );
  }

  Widget HeaderTable() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration:  BoxDecoration(
        color: colores.colorCabezeraTabla,
      ),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(
                'Suscripción',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: colores.colorTexto,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              )),
          Expanded(
              flex: 1,
              child: Text(
                'Cantidad',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: colores.colorTexto,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              )),
          Expanded(
              flex: 2,
              child: Text(
                'Precio unitario',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: colores.colorTexto,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              )),
          Expanded(
              flex: 2,
              child: Text(
                'Total',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: colores.colorTexto,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              )),
        ],
      ),
    );
  }
}

final AdminColors colores = AdminColors();