import 'package:flutter/material.dart';
import 'package:managegym/main_screen/screens/home_screen.dart';
import 'package:managegym/productos/presentation/widgets/filter_button.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //botones de accion rapidas
            SizedBox(
              child: Row(
                children: [
                  QuickActionButton(
                    text: 'AGREGAR UN NUEVO PRODUCTO',
                    icon: Icons.person_add,
                    accion: () {},
                  ),
                  const SizedBox(width: 20),
                  QuickActionButton(
                    text: 'REALIZAR UNA VENTA',
                    icon: Icons.person_add,
                    accion: () {},
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 800,
              height: 50,
              child: TextField(
                style: const TextStyle(
                    color: Colors.white), // Cambia el color del texto a blanco
                decoration: InputDecoration(
                  hintText: 'Buscar Producto por nombre o codigo de barras',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 255, 255, 255), width: 8),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        //botones para filtrar
        Row(
          children: [
            FilterButton(
              text: 'Ordenar por nombre',
              onChanged: (isAscending) {
                // Lógica para ordenar por nombre
              },
            ),
            const SizedBox(width: 10),
            FilterButton(
              text: 'Ordenar por precio',
              onChanged: (isAscending) {
                // Lógica para ordenar por precio
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 50,
          color: const Color(0xFF181818),
          child: const Row(
            children: [
              // Espacio para la imagen
              const Expanded(
                flex: 2,
                child: SizedBox(),
              ),
              // Nombre
              const Expanded(
                flex: 3,
                child: Text(
                  'Nombre',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              // Categoría
              const Expanded(
                flex: 3,
                child: Text(
                  'Categoría',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              // Precio unitario
              const Expanded(
                flex: 2,
                child: Text(
                  'Precio unitario',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              // Cantidad disponible
              const Expanded(
                flex: 2,
                child: Text(
                  'Cantidad disponible',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              // Código de barras
              const Expanded(
                flex: 3,
                child: Text(
                  'Código de barras',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              // Disponible
              const Expanded(
                flex: 1,
                child: Text(
                  'Disponible',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
