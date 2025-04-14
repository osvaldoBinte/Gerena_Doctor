import 'package:flutter/material.dart';
import 'package:managegym/suscripcciones/presentation/widgets/card_suscription_select_widget.dart';

class ModalRegisterClientWidget extends StatefulWidget {
  const ModalRegisterClientWidget({super.key});

  @override
  State<ModalRegisterClientWidget> createState() =>
      _ModalRegisterClientWidgetState();
}

class _ModalRegisterClientWidgetState extends State<ModalRegisterClientWidget> {
  List<String> meses = <String>[
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

  List<String> ano = <String>[
    ''
        '1930',
    '1931',
    '1932',
    '1933',
    '1934',
    '1935',
    '1936',
    '1937',
    '1938',
    '1939',
    '1940',
    '1941',
    '1942',
    '1943',
    '1944',
    '1945',
    '1946',
    '1947',
    '1948',
    '1949',
    '1950',
    '1951',
    '1952',
    '1953',
    '1954',
    '1955',
    '1956',
    '1957',
    '1958',
    '1959',
    '1960',
    '1961',
    '1962',
    '1963',
    '1964',
    '1965',
    '1966',
    '1967',
    '1968',
    '1969',
    '1970',
    '1971',
    '1972',
    '1973',
    '1974',
    '1975',
    '1976',
    '1977',
    '1978',
    '1979',
    '1980',
    '1981',
    '1982',
    '1983',
    '1984',
    '1985',
    '1986',
    '1987',
    '1988',
    '1989',
    '1990',
    '1991',
    '1992',
    '1993',
    '1994',
    '1995',
    '1996',
    '1997',
    '1998',
    '1999',
    '2000',
    '2001',
    '2002',
    '2003',
    '2004',
    '2005',
    '2006',
    '2007',
    '2008',
    '2009',
    '2010',
    '2011',
    '2012',
    '2013',
    '2014',
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030',
    '2031',
    '2032',
    '2033',
    '2034',
    '2035',
    '2036',
    '2037',
    '2038',
    '2039',
    '2040',
    '2041',
    '2042',
    '2043',
    '2044',
    '2045',
    '2046',
    '2047',
    '2048',
    '2049',
    '2050',
  ];
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
      print('Dia: ${_diaController.text}');
      print('Mes: $_mesController');
      print('Ano: $_anoController');
    }

    //asignar la suscripccion al usuario
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colorFondoDark,
      content: SizedBox(
        height: 1160,
        width: 1195,
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
                      BotonNombre(),
                      const SizedBox(width: 20),
                      BotonApellidos(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      BotonNumeroDeTelefono(),
                      const SizedBox(width: 20),
                      BotonCorreoElectronico(),
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
                      SizedBox(
                        width: 120,
                        child: BotonDia(),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 190,
                        child: BotonMes(),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 190,
                        child: BotonAno(),
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
                      height: 150,
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

  DropdownMenu<String> BotonAno() {
    return DropdownMenu<String>(
      initialSelection: ano[0],
      width: 400,
      onSelected: (value) {
        setState(() {
          _anoController = value;
        });
      },
      dropdownMenuEntries: ano
          .map((ano) => DropdownMenuEntry<String>(
                value: ano,
                label: ano,
              ))
          .toList(),
      label: const Text('Año', style: TextStyle(color: Colors.white)),
      textStyle: const TextStyle(color: Colors.white),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  DropdownMenu<String> BotonMes() {
    return DropdownMenu<String>(
      initialSelection: meses[0],
      width: 400,
      onSelected: (value) {
        setState(() {
          _mesController = value;
        });
      },
      dropdownMenuEntries: meses
          .map((mes) => DropdownMenuEntry<String>(
                value: mes,
                label: mes,
              ))
          .toList(),
      label: const Text('Mes', style: TextStyle(color: Colors.white)),
      textStyle: const TextStyle(color: Colors.white),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  TextFormField BotonDia() {
    return TextFormField(
      style: TextStyle(color: colorTextoDark),
      controller: _diaController,
      keyboardType: TextInputType.number,
      maxLength: 2,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo requerido';
        }
        if (int.tryParse(value) == null) {
          return 'Solo se permiten numeros';
        }
        if (int.parse(value) < 1 || int.parse(value) > 31) {
          return 'Dia no valido';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Dia',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  SizedBox BotonCorreoElectronico() {
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

  SizedBox BotonApellidos() {
    return SizedBox(
      width: 400,
      child: TextFormField(
        style: TextStyle(color: colorTextoDark),
        controller: _apellidosController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo requerido';
          }
          if (value.length < 3) {
            return 'El apellido debe tener al menos 3 caracteres';
          }
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Apellidos',
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

  SizedBox BotonNombre() {
    return SizedBox(
      width: 400,
      child: TextFormField(
        style: TextStyle(color: colorTextoDark),
        controller: _nombreController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo requerido';
          }
          if (value.length < 3) {
            return 'El nombre debe tener al menos 3 caracteres';
          }
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Nombre',
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

  SizedBox BotonNumeroDeTelefono() {
    return SizedBox(
      width: 400,
      child: TextFormField(
        style: TextStyle(color: colorTextoDark),
        controller: _telefonoController,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo requerido';
          }
          if (value.length < 10) {
            return 'El telefono debe tener al menos 10 digitos';
          }
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Numero de telefono',
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
