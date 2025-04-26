import 'package:flutter/material.dart';
import 'package:managegym/shared/admin_colors.dart';

class ModalCategorias extends StatefulWidget {
  const ModalCategorias({super.key});

  @override
  State<ModalCategorias> createState() => _ModalCategoriasState();
}

class _ModalCategoriasState extends State<ModalCategorias> {
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
        width: 400,
        height: 220,
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
              // Título único
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
                icon: Icon(Icons.category, color: Colors.white),
                label: Text(
                  'AGREGAR NUEVA CATEGORÍA',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(double.infinity, 48),
                ),
                onPressed: () {
                  // Solo validación local, no guardado ni conexión
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Formulario válido, pero sin guardar datos.'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}