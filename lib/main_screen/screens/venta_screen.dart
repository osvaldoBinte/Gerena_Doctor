import 'package:flutter/material.dart';

class ScreenVenta extends StatefulWidget {
  const ScreenVenta({super.key});

  @override
  State<ScreenVenta> createState() => _ScreenVentaState();
}

class _ScreenVentaState extends State<ScreenVenta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.blue.shade900, // Color para visualizar mejor la columna izquierda
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "REALIZAR VENTA",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Aquí puedes agregar más widgets para esta columna
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.blue.shade700, // Color para visualizar mejor la columna derecha
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "REALIZAR VENTA",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Aquí puedes agregar más widgets para esta columna
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}