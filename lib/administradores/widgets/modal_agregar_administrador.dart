import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/modal_register_client_widget.dart';
import 'package:managegym/shared/admin_colors.dart';
import 'package:managegym/shared/widgets/input_apellidos_widget.dart';
import 'package:managegym/shared/widgets/input_fecha_nacimiento_widget.dart';
import 'package:managegym/shared/widgets/input_nombre_widget.dart';
import 'package:managegym/shared/widgets/input_sexo_widget.dart';
import 'package:managegym/shared/widgets/input_telefono_widget.dart';

class ModalAgregarAdministrador extends StatefulWidget {
  ModalAgregarAdministrador({super.key});

  @override
  State<ModalAgregarAdministrador> createState() =>
      _ModalAgregarAdministradorState();
}

class _ModalAgregarAdministradorState extends State<ModalAgregarAdministrador> {
  AdminColors colores = AdminColors();
  //controladores
  final GlobalKey _form = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();

  final TextEditingController apellidosController = TextEditingController();

  final TextEditingController telefonoController = TextEditingController();

  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //datos de fecha
  final TextEditingController _diaController = TextEditingController();
  String? _mesController;
  String? _anoController;
  String? _sexoController;
  //roles
  final List<String> roles = [
    'Administrador',
    'Entrenador',
    'Recepcionista',
  ];
  String? _rolSeleccionado;


  void agregarAdministrador() {
    if ((_form.currentState as FormState).validate()) {
      // Aquí puedes agregar la lógica para registrar al administrador
      // utilizando los valores de los controladores.
      String nombre = nombreController.text;
      String apellidos = apellidosController.text;
      String telefono = telefonoController.text;
      String correo = correoController.text;
      String password = passwordController.text;
      String dia = _diaController.text;
      String mes = _mesController!;
      String ano = _anoController!;
      String sexo = _sexoController!;

      // Lógica para registrar al administrador
    }
  }

  @override
  void initState() {
    super.initState();
    _rolSeleccionado = roles[0];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(20),
      backgroundColor: colores.colorFondoModal,
      content: Container(
        width: 1000,
        height: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    "AGREGAR UN NUEVO ADMINISTRADOR",
                    style: TextStyle(
                      color: colores.colorTexto,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      InputNombreWidget(
                          nombreController: nombreController),
                      const SizedBox(width: 20),
                      InputApellidoWidget(
                          colorTextoDark: colores.colorTexto,
                          apellidosController: apellidosController)
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      InputTelefonoWidget(
                          telefonoController: telefonoController),
                      const SizedBox(width: 20),
                      InputCorreoElectronicoWidget(
                          colorTextoDark: colores.colorTexto,
                          correoController: correoController)
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      style: TextStyle(color: colores.colorTexto),
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: TextStyle(color: colores.colorTexto),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colores.colorTexto),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colores.colorTexto),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo requerido';
                        }
                        if (value.length < 6) {
                          return 'Mínimo 6 caracteres';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Fecha de nacimiento",
                    style: TextStyle(
                      color: colores.colorTexto,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        width: 190,
                        child: DropdownMenu<String>(
                          initialSelection: _rolSeleccionado,
                          width: 400,
                          onSelected: (value) {
                            setState(() {
                               _rolSeleccionado = value;
                            });
                          },
                          dropdownMenuEntries: roles
                              .map((rol) => DropdownMenuEntry<String>(
                                    value: rol,
                                    label: rol,
                                  ))
                              .toList(),
                          label:  Text('Selecciona un rol',
                              style: TextStyle(color: colores.colorTexto)),
                          textStyle:  TextStyle(color: colores.colorTexto),
                          inputDecorationTheme:  InputDecorationTheme(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colores.colorTexto),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colores.colorTexto),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    agregarAdministrador();
                  },
                  child: Container(
                    width: 320,
                    height: 50,
                    decoration: BoxDecoration(
                      color: colores.colorAccionButtons,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Text(
                        'REGISTRAR ADMINISTRADOR',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 75, 55),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child:  Center(
                      child: Text(
                        'CANCELAR',
                        style: TextStyle(
                            color: colores.colorTexto,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
