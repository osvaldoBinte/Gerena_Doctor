import 'package:flutter/material.dart';
import 'package:managegym/main_screen/screens/clients_screen.dart';
import 'package:managegym/shared/widgets/input_apellidos_widget.dart';
import 'package:managegym/shared/widgets/input_fecha_nacimiento_widget.dart';
import 'package:managegym/shared/widgets/input_nombre_widget.dart';
import 'package:managegym/shared/widgets/input_sexo_widget.dart';
import 'package:managegym/shared/widgets/input_telefono_widget.dart';
import 'package:managegym/suscripcciones/presentation/widgets/card_suscription_select_widget.dart';

class ModalRegisterClientWidget extends StatefulWidget {
  const ModalRegisterClientWidget({super.key});

  @override
  State<ModalRegisterClientWidget> createState() =>
      _ModalRegisterClientWidgetState();
}

class _ModalRegisterClientWidgetState extends State<ModalRegisterClientWidget> {
  final Color colorTextoDark = const Color.fromARGB(255, 255, 255, 255);
  final Color colorFondoDark = const Color.fromARGB(255, 33, 33, 33);
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //controllers para los textformfield
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _diaController = TextEditingController();
  String? _mesController;
  String? _anoController;
  String? _sexoController;
  List<String> _suscripcionesSeleccionadas = [];

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidosController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _diaController.dispose();
    super.dispose();
  }

  void seleccionarSuscripcion(String id) {
    setState(() {
      _suscripcionesSeleccionadas.add(id);
      print('_suscripcionesSeleccionadas: $_suscripcionesSeleccionadas');
    });
  }

  void eliminarSuscripcion(String id) {
    setState(() {
      _suscripcionesSeleccionadas.remove(id);
      print('_suscripcionesSeleccionadas: $_suscripcionesSeleccionadas');
    });
    print('Eliminar suscripcion: $id');
    print('_suscripcionesSeleccionadas: $_suscripcionesSeleccionadas');
  }

  void agregarNuevoCliente() {
    //agregar nuevo cliente
    if (_formKey.currentState!.validate()) {
      print('Nombre: ${_nombreController.text}');
      print('Apellidos: ${_apellidosController.text}');
      print('Telefono: ${_telefonoController.text}');
      print('Correo: ${_correoController.text}');
      print('Sexo: $_sexoController');
      print('Dia: ${_diaController.text}');
      print('Mes: $_mesController');
      print('Ano: $_anoController');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colorFondoDark,
      content: SizedBox(
        height: 900,
        width: 1400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registrar un nuevo cliente Cliente',
              style: TextStyle(
                  color: Colors.white,
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
                                    colorTextoDark: colorTextoDark,
                                    nombreController: _nombreController),
                                const SizedBox(width: 20),
                                InputApellidoWidget(
                                    colorTextoDark: colorTextoDark,
                                    apellidosController: _apellidosController),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                InputTelefonoWidget(
                                    colorTextoDark: colorTextoDark,
                                    telefonoController: _telefonoController),
                                const SizedBox(width: 20),
                                InputCorreoElectronicoWidget(
                                    colorTextoDark: colorTextoDark,
                                    correoController: _correoController),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Fecha de nacimiento',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                InputFechaNacimientoWidget(
                                  colorTextoDark: colorTextoDark,
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
                            const Text(
                              'Total a pagar:',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 20,
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
                              height: 20,
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
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Selecciona la suscripccion que quieres agregar al cliente',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //AQUI VA EL GRID DE LAS SUSCRIPCCIONES
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
                          itemCount: 30,
                          itemBuilder: (context, index) {
                            return CardSuscriptionSelectWidget(
                              index: index,
                              selectSuscription: seleccionarSuscripcion,
                            );
                          },
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Orden',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 40, 40, 40),
                    ),
                    child: const Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text(
                              'Suscripcion',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              'Cantidad',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              'Precio unitario',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              'Total',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              '',
                              style: TextStyle(
                                  color: Colors.white,
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
                            return RowSuscripccionSeleccionada(
                              index: index,
                              eliminarSuscripcion: eliminarSuscripcion,
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
                        onTap: () {},
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 75, 55),
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
                          agregarNuevoCliente();
                        },
                        child: Container(
                          width: 300,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 131, 55),
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
  const InputCorreoElectronicoWidget({
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
        style: TextStyle(color: colorTextoDark),
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
        decoration: const InputDecoration(
          labelText: 'Correo electronico',
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class RowSuscripccionSeleccionada extends StatefulWidget {
  final int index;
  final void Function(String id) eliminarSuscripcion;
  const RowSuscripccionSeleccionada(
      {super.key, required this.eliminarSuscripcion, required this.index});

  @override
  State<RowSuscripccionSeleccionada> createState() =>
      _RowSuscripccionSeleccionadaState();
}

class _RowSuscripccionSeleccionadaState
    extends State<RowSuscripccionSeleccionada> {
  bool isHovering = false;
  bool isFocused = false;
  FocusNode _rowEliminarFocusNode = FocusNode();

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
        color: isPair(widget.index)
            ? const Color.fromARGB(255, 40, 40, 40)
            : const Color.fromARGB(255, 23, 23, 23),
      ),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
              flex: 3,
              child: Text(
                'Suscripcion',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )),
          const Expanded(
              flex: 1,
              child: Text(
                'Cantidad',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )),
          const Expanded(
              flex: 1,
              child: Text(
                'Precio unitario',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )),
          const Expanded(
              flex: 2,
              child: Text(
                'Total',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )),
          Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  widget.eliminarSuscripcion(widget.index.toString());
                  print('Eliminar suscripcion: ${widget.index}');
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
                      color: isHovering || isFocused
                          ? Colors.red
                          : isFocused
                              ? Colors.red
                              : Colors.white,
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
