import 'package:flutter/material.dart';


class ClientesDivididosPorSexo extends StatelessWidget {
  final int cantidadTotal;
  final int cantidadM;
  final int cantidadF;
  final Color colorFondoModal;
  final Color colorTexto;

  const ClientesDivididosPorSexo({
    super.key,
    required this.cantidadTotal,
    required this.cantidadM,
    required this.cantidadF,
    required this.colorFondoModal,
    required this.colorTexto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 320,
      height: double.infinity,
      decoration: BoxDecoration(
        color: colorFondoModal,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 64,
            child: Text(
              "Clientes Divididos por Sexo este mes",
              style: TextStyle(
                color: colorTexto,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            "ACTIVOS",
            style: TextStyle(
              color: colorTexto,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "M: $cantidadM",
                style: TextStyle(
                  color: colorTexto,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                "F: $cantidadF",
                style: TextStyle(
                  color: colorTexto,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "INACTIVOS",
            style: TextStyle(
              color: colorTexto,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "M: $cantidadM",
                style: TextStyle(
                  color: colorTexto,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                "F: $cantidadF",
                style: TextStyle(
                  color: colorTexto,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
