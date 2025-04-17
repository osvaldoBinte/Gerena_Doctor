import 'package:flutter/material.dart';

class ModalAgregarSuscripccion extends StatelessWidget {
  ModalAgregarSuscripccion({
    super.key,
  });
  final Color colorTextoDark = const Color.fromARGB(255, 255, 255, 255);
  final Color colorFondoDark = const Color.fromARGB(255, 33, 33, 33);

  List<DropdownMenuEntry<String>> dropdownMenuEntries = [
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

  //logica para manejar los inputs
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //controlladorres
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripccionController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  String tipoFecha = 'Dia';

  //registrar la suscripccion
  void registrarSuscripccion() {
    if (_formKey.currentState!.validate()) {
      print('Nombre: ${_nombreController.text}');
      print('Descripccion: ${_descripccionController.text}');
      print('Tipo de fecha: ${tipoFecha } ');
      print('Cantidad: ${_cantidadController}');
      print('Precio: ${_precioController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colorFondoDark,
      content: Container(
        height: 585,
        width: 1458,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AGREGAR UNA NUEVA SUSCRIPCCION',
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
                    width: 600,
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
                        labelText: 'Descripccion',
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
                          initialSelection: dropdownMenuEntries[0].value,
                          width: 400,
                          onSelected: (value) {
                            //actualizar el tipo de fecha
                            tipoFecha = value!;
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
                            //evaluar si es un numero
                            if (double.tryParse(value) == null) {
                              return 'El valor debe ser un numero';
                            }
                            //evaluar si es un numero mayor a 0
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
                        //evaluar si es un numero
                        if (double.tryParse(value) == null) {
                          return 'El valor debe ser un numero';
                        }
                        //evaluar si es un numero mayor a 0
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
                          registrarSuscripccion();
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
}
