import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';
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

  void eliminarSuscripcion() async {
    try {
      final controller = Get.find<SuscripcionController>();
      
      // Primero verificamos si se puede eliminar
      final verificacion = await controller.puedeEliminarSuscripcion(widget.suscripcion.id);
      if (!verificacion['puede']) {
        Get.snackbar(
          'No se puede eliminar', 
          verificacion['mensaje'],
          backgroundColor: Colors.orange, 
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        return;
      }
      
      // Si se puede eliminar, mostramos diálogo de confirmación
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: colorFondoDark,
          title: const Text("Eliminar suscripción",
              style: TextStyle(color: Colors.white)),
          content: const Text("¿Estás seguro de eliminar esta suscripción?",
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text("Cancelar", 
                  style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text("Eliminar", 
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      
      if (confirm == true) {
        bool ok = await controller.eliminarSuscripcion(id: widget.suscripcion.id);
        if (ok) {
          Navigator.of(context).pop();
          Get.snackbar('Eliminada', 'Suscripción eliminada correctamente',
              backgroundColor: Colors.red, colorText: Colors.white);
        } else {
          Get.snackbar('Error', 'No se pudo eliminar la suscripción',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
    } catch (e) {
      print("Error en eliminarSuscripcion: $e");
      Get.snackbar('Error', 'Error interno: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colores.colorFondoModal,
      content: SizedBox(
        height: 585,
        width: 1000,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 10,
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'EDITAR SUSCRIPCIÓN',
                                    style: TextStyle(
                                        color: colores.colorTexto,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 800,
                                child: TextFormField(
                                  maxLength: 63,
                                  style: TextStyle(color: colores.colorTexto),
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
                                  decoration:  InputDecoration(
                                    labelText: 'Nombre',
                                    labelStyle: TextStyle(
                                        color: colores.colorTexto, fontSize: 20),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: colores.colorTexto),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: colores.colorTexto),
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
                                  style: TextStyle(color: colores.colorTexto),
                                  controller: _descripccionController,
                                  decoration:  InputDecoration(
                                    labelText: 'Descripción',
                                    labelStyle: TextStyle(
                                        color: colores.colorTexto, fontSize: 20),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: colores.colorTexto),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: colores.colorTexto),
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
                                      label:  Text('Tipo de fecha',
                                          style:
                                              TextStyle(color: colores.colorTexto)),
                                      textStyle:
                                           TextStyle(color: colores.colorTexto),
                                      inputDecorationTheme:
                                           InputDecorationTheme(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colores.colorTexto),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colores.colorTexto),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: 200,
                                    child: TextFormField(
                                      style: TextStyle(color: colores.colorTexto),
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
                                      decoration:  InputDecoration(
                                        labelText: 'Cantidad',
                                        labelStyle: TextStyle(
                                            color: colores.colorTexto, fontSize: 18),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colores.colorTexto),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: colores.colorTexto),
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
                                  style: TextStyle(color: colores.colorTexto),
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
                                  decoration:  InputDecoration(
                                    labelText: 'Precio',
                                    labelStyle: TextStyle(
                                        color: colores.colorTexto, fontSize: 18),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: colores.colorTexto),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: colores.colorTexto),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 60),
                            ],
                          ),
                        ),
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton.filled(
                          onPressed: () {
                            print("Botón eliminar presionado");
                            eliminarSuscripcion();
                          },
                          icon: const Icon(Icons.delete_forever_outlined),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 255, 75, 55),
                          ),
                        )
                      ],
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }
}