import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/modal_register_client_widget.dart';
import 'package:managegym/shared/widgets/input_apellidos_widget.dart';
import 'package:managegym/shared/widgets/input_fecha_nacimiento_widget.dart';
import 'package:managegym/shared/widgets/input_nombre_widget.dart';
import 'package:managegym/shared/widgets/input_sexo_widget.dart';
import 'package:managegym/shared/widgets/input_telefono_widget.dart';

class ModalEditarCliente extends StatefulWidget {
  const ModalEditarCliente({super.key});

  @override
  State<ModalEditarCliente> createState() => _ModalEditarClienteState();
}

class _ModalEditarClienteState extends State<ModalEditarCliente> {
  final Color colorTextoDark = const Color.fromARGB(255, 255, 255, 255);
  final Color colorFondoDark = const Color.fromARGB(255, 33, 33, 33);
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

  void editarCliente() {
    if (_formKey.currentState!.validate()) {
      print('Nombre: ${_nombreController.text}');
      print('Apellidos: ${_apellidosController.text}');
      print('Telefono: ${_telefonoController.text}');
      print('Correo: ${_correoController.text}');
      print('Dia: ${_diaController.text}');
      print('Mes: $_mesController');
      print('Año: $_anoController');
      print('Sexo: $_sexoController');
    }
  }

  @override
  Widget build(BuildContext context) {
    _nombreController.text = 'mario alfredo';

    return AlertDialog(
      backgroundColor: colorFondoDark,
      content: SizedBox(
        height: 935,
        width: 1458,
        child: Column(
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INFORMACION DEL CLIENTE',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
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
                  InputSexoWidget(
                      sexoController: _sexoController,
                      onSelected: (value) {
                        setState(() {
                          _sexoController = value;
                        });
                      }),
                  const SizedBox(height: 20),
                  const Text(
                    'Fecha de nacimiento',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
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
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Historial de suscripcciones',
                        style: TextStyle(
                            color: colorTextoDark,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Fecha de inscripccion: 12/12/2023',
                        style: TextStyle(
                          color: colorTextoDark,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HeaderTable(),
                  Container(
                    width: double.infinity,
                    height: 300,
                    child: ListView.builder(itemBuilder: (context, index) {}),
                  ),
                  const SizedBox(height: 60),
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
                          editarCliente();
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
                              'GUARDAR',
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
          ],
        ),
      ),
    );
  }

  Container HeaderTable() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 40, 40, 40),
      ),
      child: Row(
        children: [
          Expanded(
              child: Text(
            'Suscrpccion',
            textAlign: TextAlign.start,
            style: TextStyle(
                color: colorTextoDark,
                fontWeight: FontWeight.bold,
                fontSize: 17),
          )),
          Expanded(
              child: Text(
            'Fecha de ininicio de la suscrpccion',
            textAlign: TextAlign.start,
            style: TextStyle(
                color: colorTextoDark,
                fontWeight: FontWeight.bold,
                fontSize: 17),
          )),
          Expanded(
              child: Text(
            'Fecha de fin de la suscrpccion',
            textAlign: TextAlign.start,
            style: TextStyle(
                color: colorTextoDark,
                fontWeight: FontWeight.bold,
                fontSize: 17),
          )),
          Expanded(
              child: Text(
            'Estatus',
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
