

import 'package:flutter/material.dart';



class NuevosMiembrosMesContainer extends StatefulWidget {
  final int cantidadTotal;
  final int cantidadM;
  final int cantidadF;
  final List<String> anos;
  final List<String> meses;
  final Color colorFondoModal;
  final Color colorTexto;

  const NuevosMiembrosMesContainer({
    super.key,
    required this.cantidadTotal,
    required this.cantidadM,
    required this.cantidadF,
    required this.anos,
    required this.meses,
    required this.colorFondoModal,
    required this.colorTexto,
  });

  @override
  State<NuevosMiembrosMesContainer> createState() => _NuevosMiembrosMesContainerState();
}

class _NuevosMiembrosMesContainerState extends State<NuevosMiembrosMesContainer> {
  late int indexAnoActual;
  late int indexMesActual;

  @override
  void initState() {
    super.initState();
    indexAnoActual = 0;
    indexMesActual = 0;
  }

  void _handlePrevAno() {
    setState(() {
      if (indexAnoActual > 0) {
        indexAnoActual--;
      } else {
        indexAnoActual = widget.anos.length - 1;
      }
    });
  }

  void _handleNextAno() {
    setState(() {
      if (indexAnoActual < widget.anos.length - 1) {
        indexAnoActual++;
      } else {
        indexAnoActual = 0;
      }
    });
  }

  void _handlePrevMes() {
    setState(() {
      if (indexMesActual > 0) {
        indexMesActual--;
      } else {
        indexMesActual = widget.meses.length - 1;
      }
    });
  }

  void _handleNextMes() {
    setState(() {
      if (indexMesActual < widget.meses.length - 1) {
        indexMesActual++;
      } else {
        indexMesActual = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 350,
      height: double.infinity,
      decoration: BoxDecoration(
        color: widget.colorFondoModal,
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
              "Nuevos miembros este mes",
              style: TextStyle(
                color: widget.colorTexto,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "${widget.cantidadTotal}",
            style: TextStyle(
              color: widget.colorTexto,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "M: ${widget.cantidadM}",
                style: TextStyle(
                  color: widget.colorTexto,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                "F: ${widget.cantidadF}",
                style: TextStyle(
                  color: widget.colorTexto,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: _handlePrevAno,
                icon: Icon(Icons.chevron_left, color: widget.colorTexto),
              ),
              Text(
                widget.anos[indexAnoActual],
                style: TextStyle(
                  color: widget.colorTexto,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: _handleNextAno,
                icon: Icon(Icons.chevron_right, color: widget.colorTexto),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: _handlePrevMes,
                icon: Icon(Icons.chevron_left, color: widget.colorTexto),
              ),
              Text(
                widget.meses[indexMesActual],
                style: TextStyle(
                  color: widget.colorTexto,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: _handleNextMes,
                icon: Icon(Icons.chevron_right, color: widget.colorTexto),
              ),
            ],
          ),
        ],
      ),
    );
  }
}