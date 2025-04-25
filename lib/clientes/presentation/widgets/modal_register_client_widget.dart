import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';
import 'package:managegym/main_screen/connection/registrarUsuario/registrarUsuarioController.dart';
import 'package:managegym/main_screen/screens/clients_screen.dart';
import 'package:managegym/shared/admin_colors.dart';
import 'package:managegym/shared/widgets/input_apellidos_widget.dart';
import 'package:managegym/shared/widgets/input_fecha_nacimiento_widget.dart';
import 'package:managegym/shared/widgets/input_nombre_widget.dart';
import 'package:managegym/shared/widgets/input_sexo_widget.dart';
import 'package:managegym/shared/widgets/input_telefono_widget.dart';
import 'package:managegym/suscripcciones/connection/agregarSuscripcion/SuscrpcionModel.dart';
import 'package:managegym/suscripcciones/presentation/widgets/card_suscription_select_widget.dart';

class ModalRegisterClientWidget extends StatefulWidget {
  final List<TipoMembresia> suscripcionesDisponibles;
  final VoidCallback? onRegistroExitoso;
  const ModalRegisterClientWidget({
    super.key,
    required this.suscripcionesDisponibles,
    this.onRegistroExitoso,
  });

  @override
  State<ModalRegisterClientWidget> createState() =>
      _ModalRegisterClientWidgetState();
}

class _ModalRegisterClientWidgetState extends State<ModalRegisterClientWidget> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers para los textformfield
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _diaController = TextEditingController();
  String? _mesController;
  String? _anoController;
  String? _sexoController;

  List<String> _suscripcionesSeleccionadas = [];
  TipoMembresia? _suscripcionSeleccionada;

  // GetX controller
  final usuarioController = Get.put(UsuarioController());

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidosController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _diaController.dispose();
    super.dispose();
  }

  void seleccionarSuscripcion(String id, TipoMembresia suscripcion) {
    setState(() {
      if (_suscripcionesSeleccionadas.contains(id.toString())) {
        _suscripcionesSeleccionadas.remove(id.toString());
        _suscripcionSeleccionada = null;
      } else {
        _suscripcionesSeleccionadas.clear();
        _suscripcionesSeleccionadas.add(id.toString());
        _suscripcionSeleccionada = suscripcion;
      }
    });
  }

  void eliminarSuscripcion(String id) {
    setState(() {
      _suscripcionesSeleccionadas.remove(id.toString());
      if (_suscripcionSeleccionada?.id.toString() == id.toString()) {
        _suscripcionSeleccionada = null;
      }
    });
  }

  Future<void> agregarNuevoCliente() async {
    if (_formKey.currentState!.validate()) {
      if (_suscripcionSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecciona una membresía')),
        );
        return;
      }
      try {
        // Procesar la fecha de nacimiento
        DateTime? fechaNacimiento;
        if (_diaController.text.isNotEmpty &&
            _mesController != null &&
            _anoController != null) {
          final mesNum = _mesAInt(_mesController!);
          if (mesNum != null) {
            fechaNacimiento = DateTime(
              int.parse(_anoController!),
              mesNum,
              int.parse(_diaController.text),
            );
          }
        }

        // Mapear sexo a solo un caracter
        final sexoDb = (_sexoController?.toLowerCase().startsWith("f") ?? false)
            ? "F"
            : "M";

        String qr = "qr_generado_${DateTime.now().millisecondsSinceEpoch}";
        String plantillaHuella =
            "huella_demo_${DateTime.now().millisecondsSinceEpoch}";

        final fechaInicio = DateTime.now();
        final fechaFin = fechaInicio
            .add(Duration(days: _suscripcionSeleccionada!.tiempoDuracion));
        final fechaProximoPago = fechaFin;

        final idUsuario = await usuarioController.crearUsuarioCompleto(
          nombre: _nombreController.text,
          apellidos: _apellidosController.text,
          correo: _correoController.text,
          telefono: _telefonoController.text,
          fechaNacimiento: fechaNacimiento,
          sexo: sexoDb,
          qr: qr,
          plantillaHuella: plantillaHuella,
          idTipoMembresia: _suscripcionSeleccionada!.id,
          precioMembresia: _suscripcionSeleccionada!.precio,
          duracionMembresia: _suscripcionSeleccionada!.tiempoDuracion,
          fechaInicioMembresia: fechaInicio,
          fechaFinMembresia: fechaFin,
          montoPago: _suscripcionSeleccionada!.precio,
          metodoPago: "Efectivo",
          numeroReferencia: "25", // SIEMPRE manda "25"
          fechaProximoPago: fechaProximoPago,
        );

        if (idUsuario != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Cliente registrado con éxito!')),
          );
          widget.onRegistroExitoso?.call(); // Llama para refrescar la lista
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al registrar cliente')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  int? _mesAInt(String mes) {
    const meses = [
      "Enero",
      "Febrero",
      "Marzo",
      "Abril",
      "Mayo",
      "Junio",
      "Julio",
      "Agosto",
      "Septiembre",
      "Octubre",
      "Noviembre",
      "Diciembre"
    ];
    final index = meses.indexWhere((m) => m.toLowerCase() == mes.toLowerCase());
    if (index >= 0) return index + 1;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colores.colorFondoModal,
      content: SizedBox(
        height: 900,
        width: 1400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'Registrar un nuevo cliente',
              style: TextStyle(
                  color: colores.colorTexto,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Columna izquierda (80%)
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InputNombreWidget(
                                    nombreController: _nombreController),
                                const SizedBox(width: 20),
                                InputApellidoWidget(
                                    colorTextoDark: colores.colorTexto,
                                    apellidosController: _apellidosController),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                InputTelefonoWidget(
                                    telefonoController: _telefonoController),
                                const SizedBox(width: 20),
                                InputCorreoElectronicoWidget(
                                    colorTextoDark: colores.colorTexto,
                                    correoController: _correoController),
                              ],
                            ),
                            const SizedBox(height: 20),
                             Text(
                              'Fecha de nacimiento',
                              style: TextStyle(
                                  color: colores.colorTexto,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                InputFechaNacimientoWidget(
                                  colorTextoDark: colores.colorTexto,
                                  diaController: _diaController,
                                  mesController: _mesController,
                                  anoController: _anoController,
                                  onMesSelected: (value) {
                                    setState(() {
                                      _mesController = value;
                                    });
                                  },
                                  onAnoSelected: (value) {
                                    setState(() {
                                      _anoController = value;
                                    });
                                  },
                                ),
                                const SizedBox(width: 88),
                                InputSexoWidget(
                                  sexoController: _sexoController,
                                  onSelected: (value) {
                                    setState(() {
                                      _sexoController = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total a pagar:',
                              style: TextStyle(
                                  color: colores.colorTexto,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 20,
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
                                style: TextStyle(color: colores.colorTexto),
                                decoration: InputDecoration(
                                  labelStyle:
                                      TextStyle(color: colores.colorTexto),
                                  icon: Icon(
                                    Icons.attach_money,
                                    color: colores.colorTexto,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: colores.colorTexto),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Cambio:',
                              style: TextStyle(
                                  color: colores.colorTexto,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text(
                        'Selecciona la suscripción que quieres agregar al cliente',
                        style: TextStyle(
                            color: colores.colorTexto,
                            fontSize: 21,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // AQUI VA EL GRID DE LAS SUSCRIPCCIONES
                  SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Scrollbar(
                        thumbVisibility: true,
                        controller: _scrollController,
                        child: GridView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 2.6,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: widget.suscripcionesDisponibles.length,
                          itemBuilder: (context, index) {
                            final suscripcion =
                                widget.suscripcionesDisponibles[index];
                            return CardSuscriptionSelectWidget(
                              suscripcion: suscripcion,
                              isSelected: _suscripcionesSeleccionadas
                                  .contains(suscripcion.id.toString()),
                              selectSuscription: (id) =>
                                  seleccionarSuscripcion(id, suscripcion),
                            );
                          },
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Orden',
                        style: TextStyle(
                            color: colores.colorTexto,
                            fontSize: 21,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration:  BoxDecoration(
                      color: colors.colorCabezeraTabla,
                    ),
                    child:  Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text(
                              'Suscripcion',
                              style: TextStyle(
                                  color: colores.colorTexto,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              'Cantidad',
                              style: TextStyle(
                                  color: colores.colorTexto,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              'Precio unitario',
                              style: TextStyle(
                                  color: colores.colorTexto,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              'Total',
                              style: TextStyle(
                                  color: colores.colorTexto,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              '',
                              style: TextStyle(
                                  color: colores.colorTexto,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ),
                  //AQUI VAN LAS ROWS DE LAS SUSCRIPCCIONES SELECCIONADAS
                  SizedBox(
                      width: double.infinity,
                      height: 110,
                      child: ListView.builder(
                          itemCount: _suscripcionesSeleccionadas.length,
                          itemBuilder: (context, index) {
                            final idSuscripcion =
                                _suscripcionesSeleccionadas[index];
                            final suscripcion = widget.suscripcionesDisponibles
                                .firstWhere(
                                    (s) => s.id.toString() == idSuscripcion);
                            return RowSuscripccionSeleccionada(
                              index: index,
                              eliminarSuscripcion: eliminarSuscripcion,
                              suscripcion: suscripcion,
                            );
                          })),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 22,
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
                        onTap: agregarNuevoCliente,
                        child: Container(
                          width: 300,
                          height: 50,
                          decoration: BoxDecoration(
                            color: colores.colorAccionButtons,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: Text(
                              'REGISTRAR Y PAGAR',
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
            )
          ],
        ),
      ),
    );
  }
}

class InputCorreoElectronicoWidget extends StatelessWidget {
  AdminColors colores = AdminColors();

  InputCorreoElectronicoWidget({
    super.key,
    required this.colorTextoDark,
    required TextEditingController correoController,
  }) : _correoController = correoController;

  final Color colorTextoDark;
  final TextEditingController _correoController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormField(
        style: TextStyle(color: colores.colorTexto),
        controller: _correoController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo requerido';
          }
          if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
              .hasMatch(value)) {
            return 'Correo electronico no valido';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Correo electronico',
          labelStyle: TextStyle(color: colores.colorTexto),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colores.colorTexto),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colores.colorTexto),
          ),
        ),
      ),
    );
  }
}

class RowSuscripccionSeleccionada extends StatefulWidget {
  final int index;
  final void Function(String id) eliminarSuscripcion;
  final TipoMembresia suscripcion;
  const RowSuscripccionSeleccionada({
    super.key,
    required this.eliminarSuscripcion,
    required this.index,
    required this.suscripcion,
  });

  @override
  State<RowSuscripccionSeleccionada> createState() =>
      _RowSuscripccionSeleccionadaState();
}

class _RowSuscripccionSeleccionadaState
    extends State<RowSuscripccionSeleccionada> {
  bool isHovering = false;
  bool isFocused = false;
  final FocusNode _rowEliminarFocusNode = FocusNode();
  AdminColors colores = AdminColors();
  @override
  void dispose() {
    _rowEliminarFocusNode.dispose();
    super.dispose();
  }

  bool isPair(int index) {
    return index % 2 == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30,
      decoration: BoxDecoration(
        color:
            isPair(widget.index) ? colores.colorRowPar : colores.colorRowNoPar,
      ),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 3,
              child: Text(
                widget.suscripcion.titulo,
                style: TextStyle(
                  color: colores.colorTexto,
                  fontSize: 15,
                ),
              )),
          Expanded(
              flex: 1,
              child: Text(
                '1',
                style: TextStyle(
                  color: colores.colorTexto,
                  fontSize: 15,
                ),
              )),
          Expanded(
              flex: 1,
              child: Text(
                "\$${widget.suscripcion.precio}",
                style: TextStyle(
                  color: colores.colorTexto,
                  fontSize: 15,
                ),
              )),
          Expanded(
              flex: 2,
              child: Text(
                "\$${widget.suscripcion.precio}",
                style: TextStyle(
                  color: colores.colorTexto,
                  fontSize: 15,
                ),
              )),
          Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  widget.eliminarSuscripcion(widget.suscripcion.id.toString());
                },
                onHover: (value) {
                  setState(() {
                    isHovering = value;
                  });
                },
                onFocusChange: (value) {
                  setState(() {
                    isFocused = value;
                  });
                },
                focusNode: _rowEliminarFocusNode,
                child: Text(
                  "ELIMINAR",
                  style: TextStyle(
                      color:
                          isHovering || isFocused ? Colors.red : colores.colorTexto,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              )),
        ],
      ),
    );
  }
}
