import 'package:flutter/material.dart';
import 'package:managegym/suscripcciones/connection/agregarSuscripcion/SuscrpcionModel.dart';
import 'package:managegym/suscripcciones/presentation/widgets/card_suscription_select_widget.dart';

class ModalAdministrarSuscripccion extends StatefulWidget {
  final List<TipoMembresia> suscripcionesDisponibles;
  final String nombreUsuario;
  const ModalAdministrarSuscripccion({
    super.key,
    required this.suscripcionesDisponibles,
    required this.nombreUsuario,
  });

  @override
  State<ModalAdministrarSuscripccion> createState() => _ModalAdministrarSuscripccionState();
}

class _ModalAdministrarSuscripccionState extends State<ModalAdministrarSuscripccion> {
  final Color colorTextoDark = const Color.fromARGB(255, 255, 255, 255);
  final Color colorFondoDark = const Color.fromARGB(255, 33, 33, 33);
  final ScrollController _scrollController = ScrollController();

  List<String> _suscripcionesSeleccionadas = [];

  void seleccionarSuscripcion(String id) {
    setState(() {
      if (_suscripcionesSeleccionadas.contains(id.toString())) {
        _suscripcionesSeleccionadas.remove(id.toString());
      } else {
        _suscripcionesSeleccionadas.add(id.toString());
      }
    });
  }

  void eliminarSuscripcion(String id) {
    setState(() {
      _suscripcionesSeleccionadas.remove(id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colorFondoDark,
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
                      color: colorTextoDark,
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
                      crossAxisCount: 3,
                      childAspectRatio: 1.9,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
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
                const Text(
                  'Total a pagar:',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 100,
                ),
                const Text(
                  'Paga con:',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    style: TextStyle(color: colorTextoDark),
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      icon: Icon(
                        Icons.attach_money,
                        color: Colors.white,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 100,
                ),
                const Text(
                  'Cambio:',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
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
                  onTap: () {
                    // Acción de pagar aquí
                  },
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
        return const Color.fromARGB(255, 33, 33, 33);
      } else {
        return const Color.fromARGB(255, 54, 54, 54);
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
                style: const TextStyle(color: Colors.white),
              )),
          const Expanded(
              flex: 1,
              child: Text(
                '1',
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.white),
              )),
          Expanded(
              flex: 2,
              child: Text(
                '${suscripcion.precio}',
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.white),
              )),
          Expanded(
              flex: 2,
              child: Text(
                '${suscripcion.precio}',
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }

  Widget HeaderTable() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 40, 40, 40),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(
                'Suscripción',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: colorTextoDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              )),
          Expanded(
              flex: 1,
              child: Text(
                'Cantidad',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: colorTextoDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              )),
          Expanded(
              flex: 2,
              child: Text(
                'Precio unitario',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: colorTextoDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              )),
          Expanded(
              flex: 2,
              child: Text(
                'Total',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: colorTextoDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              )),
        ],
      ),
    );
  }
}