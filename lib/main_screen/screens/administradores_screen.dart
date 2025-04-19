import 'package:flutter/material.dart';
import 'package:managegym/administradores/widgets/modal_agregar_administrador.dart';
import 'package:managegym/administradores/widgets/modal_editar_administrador.dart';
import 'package:managegym/main_screen/screens/home_screen.dart';

class AdministradoresScreen extends StatelessWidget {
  const AdministradoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            const Text(
              "MIS ADMINISTRADORES",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 20),
            QuickActionButton(
              text: 'AGREGAR UN NUEVO ADMINISTRADOR',
              icon: Icons.add,
              accion: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ModalAgregarAdministrador();
                    });
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(20, (index) {
                  return SizedBox(
                    width: 450,
                    height: 300, // Altura fija
                    child: Card(
                      color: const Color.fromARGB(255, 40, 40, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Nombre del administrador",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Telefono: 123456789",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Correo",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "edad: 123456789",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Rol: ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton.filled(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ModalEditarAdministrador();
                                        });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 255, 131, 55),
                                    ),
                                  ),
                                  icon: const Icon(Icons.edit),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
