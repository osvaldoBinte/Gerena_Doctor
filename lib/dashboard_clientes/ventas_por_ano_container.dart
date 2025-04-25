import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';

class VentasPorAnoContainer extends StatefulWidget {
  final List<String> anos;
  final List<String> mese;

  const VentasPorAnoContainer({
    super.key,
    required this.anos,
    required this.mese,
  });

  @override
  State<VentasPorAnoContainer> createState() => _VentasPorAnoContainerState();
}

class _VentasPorAnoContainerState extends State<VentasPorAnoContainer> {
  late int indexAnoActual;

  @override
  void initState() {
    super.initState();
    indexAnoActual = 0;
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

  Widget _rowVentaMesPorAno({
    required String mes,
    required String venta,
    required int index,
    required Color colorTexto,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorTexto,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            mes,
            style: TextStyle(
                color: colorTexto, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            venta,
            style: TextStyle(
                color: colorTexto, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorTexto = colores.colorTexto;
    return Container(
      padding: const EdgeInsets.all(10),
      width: 370,
      height: 520,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colores.colorFondoModal,
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
        children: [
          Text(
            "Ventapor año",
            style: TextStyle(
                color: colorTexto, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: _handlePrevAno,
                  icon: Icon(
                    Icons.chevron_left,
                    color: colorTexto,
                  )),
              Text(
                "${widget.anos[indexAnoActual]}",
                style: TextStyle(
                    color: colorTexto,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: _handleNextAno,
                  icon: Icon(
                    Icons.chevron_right,
                    color: colorTexto,
                  )),
            ],
          ),
          // Lista de meses y ventas
          ListView.builder(
            itemCount: widget.mese.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _rowVentaMesPorAno(
                mes: widget.mese[index],
                venta: "350",
                index: index,
                colorTexto: colorTexto,
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}