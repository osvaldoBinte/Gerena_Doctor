import 'package:flutter/material.dart';
import 'package:managegym/main_screen/widgets/row_producto_seleccionado.dart';
import 'package:managegym/main_screen/widgets/title_bar_producto_seleccionado.dart';
import 'package:managegym/ventas/widgets/row_cliente_venta.dart';
import 'package:managegym/ventas/widgets/row_producto_venta.dart';

class ScreenVenta extends StatefulWidget {
  const ScreenVenta({super.key});

  @override
  State<ScreenVenta> createState() => _ScreenVentaState();
}

class _ScreenVentaState extends State<ScreenVenta> {
  final Color colorTextoDark = const Color.fromARGB(255, 255, 255, 255);
  final Color colorFondoDark = const Color.fromARGB(255, 33, 33, 33);
  final Color colorFondoModalDark = const Color.fromARGB(2, 217, 217, 217);

  //controladores de buscadores
  final TextEditingController _buscadorProductoController =
      TextEditingController();
  final TextEditingController _buscadorClientController =
      TextEditingController();

  //controladores
  final TextEditingController _pagoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            //primera columna
            Expanded(
              child: ContenedorIzquierdo(),
            ),
            //segunda columna
            Expanded(
              child: Container(
                color: colorFondoDark,
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Expanded(
                      // <-- Esto da el alto disponible
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorFondoModalDark,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "PRODUCTOS SELECCIONADOS",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            const TitleBarProductos(),
                            Container(
                              width: double.infinity,
                              height: 800,
                              child: ListView.builder(
                                  itemBuilder: (context, index) {
                                return RowProductoSeleccionado(
                                  index: index.toString(),
                                  nombre: "Nombre del producto",
                                  precio: "1000",
                                  cantidad: "1",
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container ContenedorIzquierdo() {
    return Container(
      color: colorFondoDark,
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ContainerRealizarVenta(),
          const SizedBox(height: 20),
          //********BUSCAR PRODIUCTOS******************************************************************
          SizedBox(
            width: 800,
            height: 50,
            child: TextField(
              onChanged: (value) {
                //aqui haces la busqueda de los productos
              },
              controller: _buscadorProductoController,
              style: const TextStyle(
                  color: Colors.white), // Cambia el color del texto a blanco
              decoration: InputDecoration(
                hintText: 'Buscar producto por nombre o codigo de barra',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 255, 255, 255), width: 8),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 50,
            color: const Color.fromARGB(255, 40, 40, 40),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Nombre",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Precio",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Stock",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
              width: double.infinity,
              height: 200,
              child: ListView.builder(
                itemCount: 12,
                itemBuilder: (context, index) {
                  return RowProductoVenta(
                    nombre: "Nombre del producto",
                    precio: "1000",
                    stock: "10",
                    colorTexto: colorTextoDark,
                    index: index,
                    onTap: (i) {
                      print('Tocaste el producto $i');
                    },
                  );
                },
              )),
          const SizedBox(height: 20),
          //*******BUSCAR PRODUCTOS*************************************************************
          //*******BUSCAR USUARIO PARA SELECCIONARLO **********************************************
          SizedBox(
            width: 800,
            height: 50,
            child: TextField(
              onChanged: (value) {
                //aqui haces la busqueda de los productos
              },
              controller: _buscadorClientController,
              style: const TextStyle(
                  color: Colors.white), // Cambia el color del texto a blanco
              decoration: InputDecoration(
                hintText: 'Buscar cliente por numero de telefono',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 255, 255, 255), width: 8),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 50,
            color: const Color.fromARGB(255, 40, 40, 40),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Nombre",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Numero de telefono",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
              width: double.infinity,
              height: 150,
              child: ListView.builder(
                itemCount: 12,
                itemBuilder: (context, index) {
                  return RowClienteVenta(
                    nombre: "Juan Pérez",
                    telefono: "2291234567",
                    colorTexto: colorTextoDark,
                    index: index,
                    onTap: (i) {
                      print('Tocaste el usuario $i');
                    },
                  );
                },
              )),
          //*******BUSCAR USUARIO PARA SELECCIONARLO *******************************************************
        ],
      ),
    );
  }

  Container ContainerRealizarVenta() {
    return Container(
      decoration: BoxDecoration(
        color: colorFondoModalDark,
        borderRadius: BorderRadius.circular(24), // Puedes ajustar el valor
      ),
      width: double.infinity,
      height: 390,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Form(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "REALIZAR VENTA",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text("Total a pagar: 1000",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text(
                    "Paga con: ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      style: TextStyle(color: colorTextoDark),
                      controller: _pagoController,
                      validator: (value) {
                        //validar que sea un numero
                        if (value == null || value.isEmpty) {
                          return 'Campo requerido';
                        }
                        if (double.tryParse(value) == null) {
                          return 'El precio debe ser un número';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Pesos',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 20),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "Cambio: 1000",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
          //BOTONES
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {},
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
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
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
    );
  }
}
