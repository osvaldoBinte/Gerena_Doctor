import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/modal_administrar_suscripccion.dart';
import 'package:managegym/clientes/presentation/widgets/modal_editar_cliente_widget.dart';
import 'package:managegym/main_screen/connection/registrarUsuario/registrarUsuarioModel.dart';
import 'package:managegym/shared/admin_colors.dart';
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
  final List<TipoMembresia> suscripcionesDisponibles;

  // Agregar el usuario si lo tienes, o los campos necesarios para construirlo
  // final Usuario cliente;

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
    required this.suscripcionesDisponibles,
    // required this.cliente,
  });

  @override
  State<RowTableClientsHomeWidget> createState() =>
      _RowTableClientsHomeWidgetState();
}

AdminColors colores = AdminColors();

class _RowTableClientsHomeWidgetState extends State<RowTableClientsHomeWidget> {
  Color isPair(int index) {
    if (index % 2 == 0) {
      return colores.colorRowPar;
    } else {
      return colores.colorRowNoPar;
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

  void _showModalEditarCliente(BuildContext context) {
    // Construye el modelo Usuario con los datos que tengas en la fila
    final usuario = Usuario(
      id: widget.index, // O el ID real de tu usuario
      nombre: widget.name,
      apellidos: '', // Si tienes apellidos, pásalos aquí
      correo: '',    // Si tienes correo, pásalo aquí
      telefono: widget.phoneNumber,
      fechaNacimiento: null, // Si tienes la fecha, pásala aquí
      sexo: widget.sex,
      status: widget.status,
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ModalEditarCliente(cliente: usuario);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: isPair(widget.index)),
      child: Row(
        children: [
          // Primera parte: InkWell para las 6 primeras columnas agrupadas
          Expanded(
            flex: 12,
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
              child: Row(
                children: [
                  // Columna 1: Nombre
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 40,
                      color: _isRowHovered
                          ? colores.colorHoverRow
                          : isPair(widget.index),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.name,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: colores.colorTexto),
                      ),
                    ),
                  ),
                  // Columna 2: Número de teléfono
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 40,
                      color: _isRowHovered
                          ? colores.colorHoverRow
                          : isPair(widget.index),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.phoneNumber,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: colores.colorTexto),
                      ),
                    ),
                  ),
                  // Columna 3: Última suscripción
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 40,
                      color: _isRowHovered
                          ? colores.colorHoverRow
                          : isPair(widget.index),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.lastSubscription,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: colores.colorTexto),
                      ),
                    ),
                  ),
                  // Columna 4: Estado
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 40,
                      color: _isRowHovered
                          ? colores.colorHoverRow
                          : isPair(widget.index),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.status,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: colores.colorTexto),
                      ),
                    ),
                  ),
                  // Columna 5: Rango de fechas
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 40,
                      color: _isRowHovered
                          ? colores.colorHoverRow
                          : isPair(widget.index),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.dateRange,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: colores.colorTexto),
                      ),
                    ),
                  ),
                  // Columna 6: Sexo
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 40,
                      color: _isRowHovered
                          ? colores.colorHoverRow
                          : isPair(widget.index),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.sex,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: colores.colorTexto),
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
              child: Container(
                height: 40,
                alignment: Alignment.center,
                color: _isButtonHovered
                    ? colores.colorHoverRow
                    : isPair(widget.index),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Administrar suscripción',
                      style: TextStyle(
                          color: colores.colorTexto,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20),
                    Icon(
                      Icons.edit,
                      color: colores.colorTexto,
                      size: 23,
                    )
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