import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/suscripcciones/connection/agregarSuscripcion/SuscrpcionModel.dart';
import 'package:managegym/suscripcciones/connection/agregarSuscripcion/suscrpcionController.dart';

class ModalEditarSuscripccion extends StatefulWidget {
  final TipoMembresia suscripcion;

  const ModalEditarSuscripccion({super.key, required this.suscripcion});

  @override
  State<ModalEditarSuscripccion> createState() =>
      _ModalEditarSuscripccionState();
}

class _ModalEditarSuscripccionState extends State<ModalEditarSuscripccion> {
  final Color colorTextoDark = const Color.fromARGB(255, 255, 255, 255);
  final Color colorFondoDark = const Color.fromARGB(255, 33, 33, 33);

  final List<DropdownMenuEntry<String>> dropdownMenuEntries = [
    const DropdownMenuEntry<String>(
      value: 'Dia',
      label: 'Dia',
    ),
    const DropdownMenuEntry<String>(
      value: 'Mes',
      label: 'Mes',
    ),
    const DropdownMenuEntry<String>(
      value: 'Ano',
      label: 'Año',
    ),
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripccionController;
  late TextEditingController _cantidadController;
  late TextEditingController _precioController;
  late String tipoFecha;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.suscripcion.titulo);
    _descripccionController =
        TextEditingController(text: widget.suscripcion.descripcion);
    _precioController =
        TextEditingController(text: widget.suscripcion.precio.toString());
    _cantidadController = TextEditingController(
      text: widget.suscripcion.tiempoDuracion < 30
          ? widget.suscripcion.tiempoDuracion.toString()
          : widget.suscripcion.tiempoDuracion % 365 == 0
              ? (widget.suscripcion.tiempoDuracion ~/ 365).toString()
              : (widget.suscripcion.tiempoDuracion ~/ 30).toString(),
    );
    // Detecta el tipo de fecha según la duración
    if (widget.suscripcion.tiempoDuracion % 365 == 0) {
      tipoFecha = "Ano";
    } else if (widget.suscripcion.tiempoDuracion % 30 == 0) {
      tipoFecha = "Mes";
    } else {
      tipoFecha = "Dia";
    }
  }

  void actualizarSuscripccion() async {
    if (_formKey.currentState!.validate()) {
      // Determinar tiempoDuracion según tipoFecha y cantidad
      int cantidad = int.tryParse(_cantidadController.text.trim()) ?? 0;
      int tiempoDuracion = 1;
      switch (tipoFecha) {
        case "Dia":
          tiempoDuracion = cantidad;
          break;
        case "Mes":
          tiempoDuracion = cantidad * 30;
          break;
        case "Ano":
          tiempoDuracion = cantidad * 365;
          break;
      }

      final controller = Get.find<SuscripcionController>();
      bool ok = await controller.actualizarSuscripcion(
        id: widget.suscripcion.id,
        titulo: _nombreController.text.trim(),
        descripcion: _descripccionController.text.trim(),
        precio: double.tryParse(_precioController.text.trim()) ?? 0,
        tiempoDuracion: tiempoDuracion,
      );
      if (ok) {
        Navigator.of(context).pop();
        Get.snackbar('Éxito', 'Suscripción actualizada correctamente',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'No se pudo actualizar la suscripción',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colorFondoDark,
      content: SizedBox(
        height: 585,
        width: 1200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EDITAR SUSCRIPCIÓN',
                  style: TextStyle(
                      color: colorTextoDark,
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
                  SizedBox(
                    width: 800,
                    child: TextFormField(
                      maxLength: 63,
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 800,
                    child: TextFormField(
                      maxLength: 200,
                      maxLines: 2,
                      style: TextStyle(color: colorTextoDark),
                      controller: _descripccionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
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
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        width: 190,
                        child: DropdownMenu<String>(
                          initialSelection: tipoFecha,
                          width: 400,
                          onSelected: (value) {
                            setState(() {
                              tipoFecha = value!;
                            });
                          },
                          dropdownMenuEntries: dropdownMenuEntries,
                          label: const Text('Tipo de fecha',
                              style: TextStyle(color: Colors.white)),
                          textStyle: const TextStyle(color: Colors.white),
                          inputDecorationTheme: const InputDecorationTheme(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          style: TextStyle(color: colorTextoDark),
                          controller: _cantidadController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo requerido';
                            }
                            if (double.tryParse(value) == null) {
                              return 'El valor debe ser un número';
                            }
                            if (double.parse(value) <= 0) {
                              return 'El valor debe ser mayor a 0';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Cantidad',
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
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 410,
                    child: TextFormField(
                      style: TextStyle(color: colorTextoDark),
                      controller: _precioController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo requerido';
                        }
                        if (double.tryParse(value) == null) {
                          return 'El valor debe ser un número';
                        }
                        if (double.parse(value) <= 0) {
                          return 'El valor debe ser mayor a 0';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Precio',
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
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.of(context).pop(),
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
                            const SizedBox(width: 20),
                            InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: 200,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 255, 75, 55),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Center(
                                  child: Text(
                                    'ELIMINAR',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: actualizarSuscripccion,
                        child: Container(
                          width: 300,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 131, 55),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: Text(
                              'ACTUALIZAR',
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
}
