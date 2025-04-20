import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:managegym/suscripcciones/connection/agregarSuscripcion/suscrpcionController.dart';

class ModalAgregarSuscripccion extends StatefulWidget {
  const ModalAgregarSuscripccion({super.key});

  @override
  State<ModalAgregarSuscripccion> createState() =>
      _ModalAgregarSuscripccionState();
}

class _ModalAgregarSuscripccionState extends State<ModalAgregarSuscripccion> {
  final Color colorTextoDark = const Color.fromARGB(255, 255, 255, 255);
  final Color colorFondoDark = const Color.fromARGB(255, 33, 33, 33);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _personalizadoController =
      TextEditingController();

  // Opciones predefinidas
  final List<Map<String, dynamic>> opcionesDuracion = [
    {'label': '1 Mes', 'dias': 30},
    {'label': '3 Meses', 'dias': 90},
    {'label': '6 Meses', 'dias': 180},
    {'label': '1 Año', 'dias': 365},
    {'label': 'Personalizado', 'dias': null},
  ];

  String? _duracionSeleccionada;

  @override
  void initState() {
    super.initState();
    _duracionSeleccionada = opcionesDuracion[0]['label'];
  }

  Future<void> registrarSuscripcion(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final titulo = _nombreController.text.trim();
      final descripcion = _descripcionController.text.trim();
      final precio = double.tryParse(_precioController.text.trim()) ?? 0;

      int tiempoDuracion = 0;
      if (_duracionSeleccionada != 'Personalizado') {
        tiempoDuracion = opcionesDuracion
            .firstWhere((op) => op['label'] == _duracionSeleccionada)['dias'];
      } else {
        tiempoDuracion =
            int.tryParse(_personalizadoController.text.trim()) ?? 0;
      }

      // Usa el controlador con GetX
      final SuscripcionController suscripcionController = Get.find();

      try {
        await suscripcionController.agregarSuscripcion(
          titulo: titulo,
          descripcion: descripcion,
          precio: precio,
          tiempoDuracion: tiempoDuracion,
        );

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle,
                      color: const Color.fromARGB(255, 206, 110, 21), size: 60),
                  const SizedBox(height: 16),
                  const Text(
                    "Guardado",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(context)
          ..pop()
          ..pop(); // Cierra el dialog de éxito y el modal principal
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colorFondoDark,
      content: SizedBox(
        height: 550,
        width: 700,
        child: Column(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AGREGAR UNA NUEVA SUSCRIPCIÓN',
                    style: TextStyle(
                      color: colorTextoDark,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _nombreController,
                    maxLength: 63,
                    style: TextStyle(color: colorTextoDark),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Campo requerido';
                      if (value.length < 3)
                        return 'El nombre debe tener al menos 3 caracteres';
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Nombre de la Suscripción',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descripcionController,
                    maxLength: 200,
                    maxLines: 2,
                    style: TextStyle(color: colorTextoDark),
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _precioController,
                    style: TextStyle(color: colorTextoDark),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Campo requerido';
                      if (double.tryParse(value) == null)
                        return 'El valor debe ser un número';
                      if (double.parse(value) <= 0)
                        return 'El valor debe ser mayor a 0';
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Precio',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        width: 250,
                        child: DropdownButtonFormField<String>(
                          value: _duracionSeleccionada,
                          decoration: const InputDecoration(
                            labelText: 'Duración',
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20), // Más grande
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          dropdownColor: colorFondoDark,
                          style: TextStyle(
                            color: colorTextoDark,
                            fontSize: 17, // Aumenta el tamaño aquí
                            fontWeight: FontWeight.w500,
                          ),
                          items: opcionesDuracion
                              .map((op) => DropdownMenuItem<String>(
                                    value: op['label'],
                                    child: Text(
                                      op['label'],
                                      style: TextStyle(
                                        color: colorTextoDark,
                                        fontSize:
                                            17, // Aumenta el tamaño aquí también
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _duracionSeleccionada = value!;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Campo requerido' : null,
                        ),
                      ),
                      const SizedBox(width: 30),
                      if (_duracionSeleccionada == 'Personalizado')
                        SizedBox(
                          width: 180,
                          child: TextFormField(
                            controller: _personalizadoController,
                            style: TextStyle(color: colorTextoDark),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (_duracionSeleccionada != 'Personalizado')
                                return null;
                              if (value == null || value.isEmpty)
                                return 'Requerido';
                              if (int.tryParse(value) == null)
                                return 'Debe ser un número';
                              if (int.parse(value) <= 0)
                                return 'Debe ser mayor a 0';
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Días',
                              labelStyle:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 160,
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
                const SizedBox(width: 40),
                InkWell(
                  onTap: () => registrarSuscripcion(context),
                  child: Container(
                    width: 220,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 131, 55),
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
            ),
          ],
        ),
      ),
    );
  }
}
