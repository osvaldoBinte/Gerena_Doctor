import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/modal_register_client_widget.dart';
import 'package:managegym/shared/widgets/input_apellidos_widget.dart';
import 'package:managegym/shared/widgets/input_nombre_widget.dart';
import 'package:managegym/shared/widgets/input_telefono_widget.dart';

class ModalAgregarAdministrador extends StatelessWidget {
  ModalAgregarAdministrador({super.key});
  final Color colorTextoDark = const Color.fromARGB(255, 255, 255, 255);
  //controladores
  final GlobalKey _form = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(10),
      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
      content: Container(
        width: 1400,
        height: 900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "AGREGAR UN NUEVO ADMINISTRADOR",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _form,
              child: Column(
                children: [
                  Row(
                    children: [
                      InputNombreWidget(
                          colorTextoDark: colorTextoDark,
                          nombreController: nombreController),
                      const SizedBox(width: 20),
                      InputApellidoWidget(
                          colorTextoDark: colorTextoDark,
                          apellidosController: apellidosController)
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      InputTelefonoWidget(
                          colorTextoDark: colorTextoDark,
                          telefonoController: telefonoController),
                      const SizedBox(width: 20),
                      InputCorreoElectronicoWidget(
                          colorTextoDark: colorTextoDark,
                          correoController: correoController)
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
