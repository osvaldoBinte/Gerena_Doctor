import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/modal_administrar_suscripccion.dart';
import 'package:managegym/clientes/presentation/widgets/modal_editar_cliente_widget.dart';
import 'package:managegym/suscripcciones/connection/agregarSuscripcion/SuscrpcionModel.dart';

class RowTableClientsHomeWidget extends StatefulWidget {
  final int index;
  final String name;
  final String phoneNumber;
  final String lastSubscription;
  final String status;
  final String dateRange;
  final String sex;
  final Function(int index)? onRowTap;
  final Function(int index)? onManageTap;

  final List<TipoMembresia> suscripcionesDisponibles; // <-- AGREGA ESTA LÍNEA

  const RowTableClientsHomeWidget({
    super.key,
    required this.index,
    required this.name,
    required this.phoneNumber,
    required this.lastSubscription,
    required this.status,
    required this.dateRange,
    required this.sex,
    this.onRowTap,
    this.onManageTap,
    required this.suscripcionesDisponibles, // <-- Y EN EL CONSTRUCTOR
  });

  @override
  State<RowTableClientsHomeWidget> createState() =>
      _RowTableClientsHomeWidgetState();
}

void _showModalEditarCliente(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const ModalEditarCliente();
    },
  );
}


class _RowTableClientsHomeWidgetState extends State<RowTableClientsHomeWidget> {
  Color isPair(int index) {
    if (index % 2 == 0) {
      return const Color.fromARGB(255, 33, 33, 33);
    } else {
      return const Color.fromARGB(255, 54, 54, 54);
    }
  }

  @override
  void dispose() {
    _mainFocusNode.dispose();
    _buttonFocusNode.dispose();
    super.dispose();
  }

  bool _isRowHovered = false;
  bool _isButtonHovered = false;
  final FocusNode _mainFocusNode = FocusNode();
  final FocusNode _buttonFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: isPair(widget.index)),
      child: Row(
        children: [
          // Primera parte: InkWell para las 6 primeras columnas agrupadas
          Expanded(
            flex:
                12, // Suma de los flex de las 6 primeras columnas (3+1+3+1+3+1)
            child: InkWell(
              onTap: () {
                if (widget.onRowTap != null) {
                  widget.onRowTap!(widget.index);
                }
                _showModalEditarCliente(context);

                print("Clicked on row ${widget.index}");
              },
              onHover: (isHovering) {
                setState(() {
                  _isRowHovered = isHovering;
                });
              },
              onFocusChange: (hasFocus) {
                setState(() {
                  _isRowHovered = hasFocus;
                });
              },
              focusNode: _mainFocusNode,
              hoverColor: const Color.fromARGB(40, 255, 255, 255),
              splashColor: const Color.fromARGB(50, 255, 255, 255),
              highlightColor: const Color.fromARGB(30, 255, 255, 255),
              child: Row(
                children: [
                  // Columna 1: Nombre
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 40,
                      color: _isRowHovered
                          ? Color.fromARGB(
                              255,
                              isPair(widget.index).red + 10,
                              isPair(widget.index).green + 10,
                              isPair(widget.index).blue + 10)
                          : isPair(widget.index),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.name,
                        textAlign: TextAlign.start,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  // Columna 2: Número de teléfono
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 40,
                      color: _isRowHovered
                          ? Color.fromARGB(
                              255,
                              isPair(widget.index).red + 10,
                              isPair(widget.index).green + 10,
                              isPair(widget.index).blue + 10)
                          : isPair(widget.index),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.phoneNumber,
                        textAlign: TextAlign.start,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  // Columna 3: Última suscripción
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 40,
                      color: _isRowHovered
                          ? Color.fromARGB(
                              255,
                              isPair(widget.index).red + 10,
                              isPair(widget.index).green + 10,
                              isPair(widget.index).blue + 10)
                          : isPair(widget.index),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.lastSubscription,
                        textAlign: TextAlign.start,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  // Columna 4: Estado
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 40,
                      color: _isRowHovered
                          ? Color.fromARGB(
                              255,
                              isPair(widget.index).red + 10,
                              isPair(widget.index).green + 10,
                              isPair(widget.index).blue + 10)
                          : isPair(widget.index),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.status,
                        textAlign: TextAlign.start,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  // Columna 5: Rango de fechas
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 40,
                      color: _isRowHovered
                          ? Color.fromARGB(
                              255,
                              isPair(widget.index).red + 10,
                              isPair(widget.index).green + 10,
                              isPair(widget.index).blue + 10)
                          : isPair(widget.index),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.dateRange,
                        textAlign: TextAlign.start,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  // Columna 6: Sexo
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 40,
                      color: _isRowHovered
                          ? Color.fromARGB(
                              255,
                              isPair(widget.index).red + 10,
                              isPair(widget.index).green + 10,
                              isPair(widget.index).blue + 10)
                          : isPair(widget.index),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.sex,
                        textAlign: TextAlign.start,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Segunda parte: InkWell para el botón de administrar suscripción
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                if (widget.onManageTap != null) {
                  widget.onManageTap!(widget.index);
                }
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ModalAdministrarSuscripccion(
                      suscripcionesDisponibles: widget.suscripcionesDisponibles,
                      nombreUsuario: widget.name,
                    );
                  },
                );
                print("Manage subscription for ${widget.index}");
              },
              onHover: (isHovering) {
                setState(() {
                  _isButtonHovered = isHovering;
                });
              },
              onFocusChange: (hasFocus) {
                setState(() {
                  _isButtonHovered = hasFocus;
                });
              },
              focusNode: _buttonFocusNode,
              focusColor: const Color.fromARGB(255, 0, 0, 0),
              hoverColor: const Color.fromARGB(255, 0, 0, 0),
              splashColor: const Color.fromARGB(255, 60, 60, 60),
              child: Container(
                height: 40,
                alignment: Alignment.center,
                color: _isButtonHovered
                    ? const Color.fromARGB(255, 0, 0, 0)
                    : isPair(widget.index),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Administrar suscripción',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20),
                    Icon(Icons.edit, color: Colors.white, size: 23,)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
