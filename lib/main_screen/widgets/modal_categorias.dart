import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';
import 'package:managegym/main_screen/screens/clients_screen.dart';
import 'package:managegym/main_screen/screens/home_screen.dart';

class ModalCategorias extends StatefulWidget {
  const ModalCategorias({super.key});

  @override
  State<ModalCategorias> createState() => _ModalCategoriasState();
}

class _ModalCategoriasState extends State<ModalCategorias> {
  List<String> categorias = [
    'Entrenamiento Personalizado',
    'Entrenamiento en Grupo',
    'Entrenamiento Funcional',
    'Entrenamiento de Fuerza',
    'Entrenamiento de Resistencia',
    'Entrenamiento de Flexibilidad',
    'Entrenamiento de Equilibrio',
    'Entrenamiento de Velocidad',
    'Entrenamiento de Agilidad',
  ];

  // Controlador para el campo de texto
  final TextEditingController _categoriaController = TextEditingController();
  // Clave global para el Form
  final _formKey = GlobalKey<FormState>(); // <-- AÑADE ESTA LÍNEA

  @override
  void dispose() {
    _categoriaController.dispose(); // <-- AÑADE ESTO PARA EVITAR FUGAS DE MEMORIA
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colors.colorFondoModal,
      content: Container(
        // Se quitó el Padding que envolvía este Container
        width: 1000,
        height: 700,
        child: Row(
          children: [
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
                      color: colors.colorTexto,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                      child: ListView.builder(
                          itemCount: categorias.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: colors.colorAccionButtons,
                              child: ListTile(
                                title: Text(categorias[index],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    )),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      categorias.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            );
                          }))
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.only(left: 20),
                width: 500,
                height: double.infinity,
                child: Form( // <-- ENVUELVE CON FORM
                  key: _formKey, // <-- ASIGNA LA CLAVE
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Agregar Categoria',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colors.colorTexto,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          style: TextStyle(color: colores.colorTexto),
                          controller: _categoriaController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo requerido';
                            }
                            if (value.length < 3) {
                              return 'La categoria debe tener al menos 3 caracteres';
                            }
                            // Validación para evitar duplicados (opcional pero recomendado)
                            if (categorias.any((cat) => cat.toLowerCase() == value.toLowerCase())) {
                              return 'La categoría ya existe';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Escribe la nueva categoria',
                            labelStyle: TextStyle(color: colores.colorTexto, fontSize: 18),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colores.colorTexto),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colores.colorTexto),
                            ),
                            errorBorder: UnderlineInputBorder( // Estilo para el error
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: UnderlineInputBorder( // Estilo para el error con foco
                              borderSide: BorderSide(color: Colors.red, width: 2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      QuickActionButton(
                        text: 'AGREGAR NUEVA CATEGORIA',
                        icon: Icons.category,
                        accion: () {
                          // Valida el formulario antes de agregar
                          if (_formKey.currentState!.validate()) { // <-- USA LA CLAVE PARA VALIDAR
                            setState(() {
                              categorias.add(_categoriaController.text);
                              _categoriaController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
