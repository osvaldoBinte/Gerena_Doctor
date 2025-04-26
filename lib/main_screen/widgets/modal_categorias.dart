import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/main_screen/screens/home_screen.dart';
import 'package:managegym/main_screen/widgets/connection/categoriaController.dart';
import 'package:managegym/shared/admin_colors.dart';

class ModalCategorias extends StatefulWidget {
  const ModalCategorias({super.key});

  @override
  State<ModalCategorias> createState() => _ModalCategoriasState();
}

class _ModalCategoriasState extends State<ModalCategorias> {
  final CategoriaController categoriaController =
      Get.find<CategoriaController>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _tiempoDuracionController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final AdminColors colores = AdminColors();

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _tiempoDuracionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colores.colorFondoModal,
      content: Container(
        width: 1000,
        height: 700,
        child: Row(
          children: [
            // Lista de categorías
            Container(
              width: 500,
              height: double.infinity,
              child: Column(
                children: [
                  Text(
                    'Categorias',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colores.colorTexto,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Obx(() {
                      if (categoriaController.cargando.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (categoriaController.categorias.isEmpty) {
                        return Center(
                            child: Text(
                          'No hay categorías registradas',
                          style: TextStyle(color: colores.colorTexto),
                        ));
                      }
                      return ListView.builder(
                        itemCount: categoriaController.categorias.length,
                        itemBuilder: (context, index) {
                          final cat = categoriaController.categorias[index];
                          return Card(
                            color: colores.colorAccionButtons,
                            child: ListTile(
                              title: Text(
                                cat.titulo,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                '${cat.descripcion}\n\$${cat.precio} | ${cat.tiempoDuracion} horas',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.white,
                                ),
                                tooltip: 'Eliminar',
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    barrierColor: Colors.black
                                        .withOpacity(0.4), // Fondo gris oscuro
                                    builder: (_) => Theme(
                                      data: Theme.of(context).copyWith(
                                        dialogBackgroundColor: Colors
                                            .grey[200], // Fondo gris claro
                                        colorScheme: Theme.of(context)
                                            .colorScheme
                                            .copyWith(
                                              primary: Colors.orange,
                                              secondary: Colors.orange,
                                            ),
                                      ),
                                      child: AlertDialog(
                                        backgroundColor: Colors
                                            .grey[200], // Fondo gris claro
                                        title: Row(
                                          children: [
                                            Icon(Icons.warning,
                                                color: Colors.orange),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'Eliminar categoría',
                                              style: TextStyle(
                                                color: Colors.orange,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        content: Text(
                                          '¿Estás seguro de que deseas eliminar esta categoría?',
                                          style: TextStyle(
                                              color: Colors.grey[900]),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: Text('Cancelar',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey[700]))),
                                          TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: Colors.orange,
                                              ),
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text('Eliminar',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        ],
                                      ),
                                    ),
                                  );
                                  if (confirm == true) {
                                    final success = await categoriaController
                                        .eliminarCategoria(cat.id);
                                    if (success) {
                                      Get.snackbar(
                                        'Eliminada',
                                        'Categoría eliminada correctamente',
                                        backgroundColor: Colors
                                            .orange, // Usa el mismo naranja que tu modal
                                        colorText: Colors.white,
                                        snackPosition: SnackPosition.TOP,
                                        margin: const EdgeInsets.all(20),
                                        duration: const Duration(seconds: 2),
                                      );
                                    } else {
                                      Get.snackbar(
                                        'Error',
                                        'No se pudo eliminar la categoría',
                                        backgroundColor: Colors.red[700],
                                        colorText: Colors.white,
                                        snackPosition: SnackPosition.TOP,
                                        margin: const EdgeInsets.all(20),
                                        duration: const Duration(seconds: 2),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
            // Formulario para agregar categoría
            Container(
              padding: const EdgeInsets.only(left: 20),
              width: 500,
              height: double.infinity,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Agregar Categoria',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colores.colorTexto,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Título
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        style: TextStyle(color: colores.colorTexto),
                        controller: _tituloController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo requerido';
                          }
                          if (value.length < 3) {
                            return 'La categoria debe tener al menos 3 caracteres';
                          }
                          if (categoriaController.categorias.any((cat) =>
                              cat.titulo.toLowerCase() ==
                              value.toLowerCase())) {
                            return 'La categoría ya existe';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Título de la categoría',
                          labelStyle: TextStyle(
                              color: colores.colorTexto, fontSize: 18),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colores.colorTexto),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colores.colorTexto),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Descripción
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        style: TextStyle(color: colores.colorTexto),
                        controller: _descripcionController,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Descripción',
                          labelStyle: TextStyle(
                              color: colores.colorTexto, fontSize: 18),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colores.colorTexto),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colores.colorTexto),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Precio
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        style: TextStyle(color: colores.colorTexto),
                        controller: _precioController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Campo requerido';
                          final price = double.tryParse(value);
                          if (price == null || price < 0)
                            return 'Precio inválido';
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Precio',
                          labelStyle: TextStyle(
                              color: colores.colorTexto, fontSize: 18),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colores.colorTexto),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colores.colorTexto),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Duración en horas
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        style: TextStyle(color: colores.colorTexto),
                        controller: _tiempoDuracionController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Campo requerido';
                          final hours = int.tryParse(value);
                          if (hours == null || hours < 1)
                            return 'Debe ser un número entero positivo';
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Duración (horas)',
                          labelStyle: TextStyle(
                              color: colores.colorTexto, fontSize: 18),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colores.colorTexto),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colores.colorTexto),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    QuickActionButton(
                      text: 'AGREGAR NUEVA CATEGORIA',
                      icon: Icons.category,
                      accion: () async {
                        if (_formKey.currentState!.validate()) {
                          final success =
                              await categoriaController.agregarCategoria(
                            titulo: _tituloController.text,
                            descripcion: _descripcionController.text,
                            precio: double.parse(_precioController.text),
                            tiempoDuracion:
                                int.parse(_tiempoDuracionController.text),
                          );
                          if (success) {
                            Get.snackbar(
                              'Éxito',
                              'Categoría agregada correctamente',
                              backgroundColor: Colors.orange, // Fondo naranja
                              colorText: Colors.white, // Texto blanco
                              snackPosition: SnackPosition.TOP,
                              margin: const EdgeInsets.all(20),
                              duration: const Duration(seconds: 2),
                            );
                            _tituloController.clear();
                            _descripcionController.clear();
                            _precioController.clear();
                            _tiempoDuracionController.clear();
                          } else {
                            Get.snackbar(
                              'Error',
                              'No se pudo agregar la categoría',
                              backgroundColor:
                                  Colors.red[700], // Fondo rojo para errores
                              colorText: Colors.white,
                              snackPosition: SnackPosition.TOP,
                              margin: const EdgeInsets.all(20),
                              duration: const Duration(seconds: 2),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
