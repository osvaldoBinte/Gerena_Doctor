import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';
import 'package:managegym/productos/presentation/widgets/input_codigo_barras_producto.dart';
import 'package:managegym/productos/presentation/widgets/input_nombre_producto.dart';
import 'package:managegym/productos/presentation/widgets/input_precio_producto.dart';
import 'package:managegym/productos/presentation/widgets/input_stock_inicial_producto.dart.dart';
import 'package:managegym/shared/admin_colors.dart';

class ModalAgregarProducto extends StatefulWidget {
  const ModalAgregarProducto({super.key});

  @override
  State<ModalAgregarProducto> createState() => _ModalAgregarProductoState();
}

class _ModalAgregarProductoState extends State<ModalAgregarProducto> {
  final Color colorTextoDark = const Color.fromARGB(255, 255, 255, 255);
  final Color colorFondoDark = const Color.fromARGB(255, 33, 33, 33);
  AdminColors colors = AdminColors();

  //controladores
  final TextEditingController nombreProductoController =
      TextEditingController();
  final TextEditingController codigoBarrasController = TextEditingController();
  final TextEditingController stockInicialController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // logica del dropdown para obtener la categoria
  String? _categoriaController;
  List<String> categorias = [
    'Categoria 1',
    'Categoria 2',
    'Categoria 3',
    'Categoria 4',
    'Categoria 5'
  ];

  //LOGICA PARA OBTENER UNA IMAGEN
  bool isImageSelected = false;
  String? _selectedImagePath;
  String textoBotonImagen = 'AGREGAR IMAGEN';
  Future<void> selectImage() async {
    // #docregion SingleOpen
    XTypeGroup typeGroup = XTypeGroup(
      label: 'images',
      extensions: <String>['jpg', 'png'],
    );
    final XFile? file =
        await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
    // #enddocregion SingleOpen
    if (file == null) {
      // Operation was canceled by the user.
      return;
    }
    final String fileName = file.name;
    final String filePath = file.path;

    if (context.mounted) {
      setState(() {
        // Aquí puedes usar fileName y filePath como desees
        print('Nombre del archivo: $fileName');
        print('Ruta del archivo: $filePath');
        _selectedImagePath = filePath; // Guardar la ruta de la imagen
        textoBotonImagen = 'CAMBIAR IMAGEN';
        isImageSelected = true;
      });
    }
  }

  void agregarProductos() {
    if (_formKey.currentState!.validate()) {
      print('Nombre: ${nombreProductoController.text}');
      print('Codigo de barras: ${codigoBarrasController.text}');
      print('Stock inicial: ${stockInicialController.text}');
      print('Precio: ${precioController.text}');
      print('Categoria: $_categoriaController');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colors.colorFondoModal,
      content: Container(
        width: 1300,
        height: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // FORMULARIO EN UNA COLUMNA
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  'AGREGAR PRODUCTO',
                  style: TextStyle(
                    color: colors.colorTexto,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputNombreProductoWidget(
                          colorTextoDark: colorTextoDark,
                          nombreProductoController: nombreProductoController),
                      const SizedBox(height: 20),
                      InputCodigoDeBarrasProductoWidget(
                          colorTextoDark: colorTextoDark,
                          codigoBarrasController: codigoBarrasController),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          InputPrecioProductoWidget(
                              colorTextoDark: colorTextoDark,
                              precioController: precioController),
                          const SizedBox(width: 20),
                          InputStockInicialProductoWidget(
                              colorTextoDark: colorTextoDark,
                              stockInicialController: stockInicialController),
                          SizedBox(width: 20),
                          SizedBox(
                            width: 200,
                            child: DropdownMenu<String>(
                              initialSelection: "",
                              width: 400,
                              onSelected: (value) {
                                setState(() {
                                  _categoriaController = value;
                                });
                              },
                              dropdownMenuEntries: categorias
                                  .map((categoria) => DropdownMenuEntry<String>(
                                        value: categoria,
                                        label: categoria,
                                      ))
                                  .toList(),
                              label:  Text('Categoria',
                                  style: TextStyle(color: colores.colorTexto)),
                              textStyle:  TextStyle(color: colores.colorTexto),
                              inputDecorationTheme:  InputDecorationTheme(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: colores.colorTexto),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: colores.colorTexto),
                                ),
                              ),
                            ),
                          ),
                          //boton para agregar imagen
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: selectImage,
                            child: Container(
                              width: 200,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 131, 55),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  textoBotonImagen,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Agrega más campos según sea necesario
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: 200,
              height: 200,
              child: isImageSelected
                  ? Image.file(
                      // Usar File de dart:io para mostrar la imagen seleccionada
                      File(_selectedImagePath!),
                      fit: BoxFit.cover,
                    )
                  : IconButton(
                      icon: Icon(Icons.add_a_photo, color: colores.colorTexto),
                      onPressed: selectImage,
                    ),
            ),
            // BOTONES ABAJO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: agregarProductos,
                  child: Container(
                    width: 350,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 131, 55),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Text(
                        'GUARDAR NUEVO PRODUCTO',
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
            ),
          ],
        ),
      ),
    );
  }
}
