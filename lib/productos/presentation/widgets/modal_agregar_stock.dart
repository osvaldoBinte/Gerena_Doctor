import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';

class ModalAgregarStock extends StatelessWidget {
  ModalAgregarStock({super.key});

  final Color colorTextoDark = const Color.fromARGB(255, 255, 255, 255);
  final Color colorFondoDark = const Color.fromARGB(255, 33, 33, 33);

  // Controllers
  final TextEditingController precioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colores.colorFondoModal,
      content: Container(
        width: 400,
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Column(
                children: [
                       Text(
              'AGREGAR STOCK',
              style: TextStyle(
                color: colores.colorTexto,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'AQUI VA EL NOMBRE DEL PRODUCTO XDXDXDXD',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colores.colorTexto,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              style: TextStyle(color: colores.colorTexto),
              controller: precioController,
              validator: (value) {
                //validar que sea un numero
                if (value == null || value.isEmpty) {
                  return 'Campo requerido';
                }
                if (double.tryParse(value) == null) {
                  return 'Campo debe ser un número';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration:  InputDecoration(
                labelText: 'Cantidad a agregar',
                labelStyle: TextStyle(color: colores.colorTexto),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colores.colorTexto),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colores.colorTexto),
                ),
              ),
            ),
            const SizedBox(height: 20),
                ],
              ),
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 350,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 131, 55),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Text(
                        'AGREGAR STOCK',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
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
              ],
            )
          ],
        ),
      ),
    );
  }
}

