import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/main_screen/widgets/connection/categoriaController.dart';
import 'package:managegym/shared/admin_colors.dart';

class ModalCategorias extends StatefulWidget {
  const ModalCategorias({super.key});

  @override
  State<ModalCategorias> createState() => _ModalCategoriasState();
}

class _ModalCategoriasState extends State<ModalCategorias> {
  final CategoriaController categoriaController = Get.find<CategoriaController>();
  final TextEditingController _tituloController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AdminColors colores = AdminColors();

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colores.colorFondoModal,
      content: SizedBox(
        width: 800,
        height: 450,
        child: Row(
          children: [
            // Sección para ver categorías existentes
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(right: 18),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: colores.colorTexto.withOpacity(0.2)),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Categorías existentes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colores.colorTexto,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Obx(() {
                        if (categoriaController.cargando.value) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (categoriaController.categorias.isEmpty) {
                          return Center(
                            child: Text(
                              'No hay categorías registradas.',
                              style: TextStyle(color: colores.colorTexto),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: categoriaController.categorias.length,
                          itemBuilder: (context, index) {
                            final cat = categoriaController.categorias[index];
                            return Card(
                              color: colores.colorAccionButtons.withOpacity(0.9),
                              child: ListTile(
                                title: Text(
                                  cat.titulo,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_forever, color: Colors.white),
                                  tooltip: 'Eliminar',
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      barrierColor: Colors.black.withOpacity(0.4),
                                      builder: (_) => Theme(
                                        data: Theme.of(context).copyWith(
                                          dialogBackgroundColor: Colors.grey[200],
                                          colorScheme: Theme.of(context).colorScheme.copyWith(
                                            primary: Colors.orange,
                                            secondary: Colors.orange,
                                          ),
                                        ),
                                        child: AlertDialog(
                                          backgroundColor: Colors.grey[200],
                                          title: Row(
                                            children: [
                                              const Icon(Icons.warning, color: Colors.orange),
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
                                            style: TextStyle(color: Colors.grey[900]),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: Text('Cancelar', style: TextStyle(color: Colors.grey[700])),
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: Colors.orange,
                                              ),
                                              onPressed: () => Navigator.of(context).pop(true),
                                              child: const Text(
                                                'Eliminar',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                    if (confirm == true) {
                                      final success = await categoriaController.eliminarCategoria(cat.id);
                                      if (success) {
                                        Get.snackbar(
                                          'Eliminada',
                                          'Categoría eliminada correctamente',
                                          backgroundColor: Colors.orange,
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
            ),
            // Sección para agregar nueva categoría
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Agregar Categoría',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colores.colorTexto,
                        ),
                      ),
                      const SizedBox(height: 20),
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
                              return 'La categoría debe tener al menos 3 caracteres';
                            }
                            if (categoriaController.titulosCategorias.any((titulo) =>
                                titulo.toLowerCase() == value.toLowerCase())) {
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
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.category, color: Colors.white),
                        label: const Text(
                          'AGREGAR NUEVA CATEGORÍA',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colores.colorAccionButtons,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final success = await categoriaController.agregarCategoria(
                              titulo: _tituloController.text,
                            );
                            if (success) {
                              Get.snackbar(
                                'Éxito',
                                'Categoría agregada correctamente',
                                backgroundColor: Colors.orange,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.TOP,
                                margin: const EdgeInsets.all(20),
                                duration: const Duration(seconds: 2),
                              );
                              _tituloController.clear();
                            } else {
                              Get.snackbar(
                                'Error',
                                'No se pudo agregar la categoría',
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}