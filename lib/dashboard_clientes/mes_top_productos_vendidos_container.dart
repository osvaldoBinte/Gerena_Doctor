import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';

class MesTopProductosVendidosContainer extends StatefulWidget {
  final List<String> anos;
  final List<String> meses;

  const MesTopProductosVendidosContainer({
    super.key,
    required this.anos,
    required this.meses,
  });

  @override
  State<MesTopProductosVendidosContainer> createState() => _MesTopProductosVendidosContainerState();
}

class _MesTopProductosVendidosContainerState extends State<MesTopProductosVendidosContainer> {
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

  Row productRow({
    required int index,
    required String nombreProducto,
    required String precioProducto,
    required String cantidadVendida,
    String? imagenPath,
  }) {
    return Row(
      children: [
        Stack(
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: imagenPath != null && imagenPath.isNotEmpty
                  ? Image.asset(
                      imagenPath,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.white54,
                          size: 40,
                        ),
                      ),
                    ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: Text(
                "#${index + 1}",
                style: TextStyle(
                  color: colores.colorAccionButtons,
                  fontSize: 45,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombreProducto,
              style: TextStyle(color: colores.colorTexto, fontSize: 16),
            ),
            Text(
              "precio: $precioProducto",
              style: TextStyle(color: colores.colorTexto, fontSize: 16),
            ),
            Text(
              "Cantidad: $cantidadVendida",
              style: TextStyle(color: colores.colorTexto, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
          Text("Top 4 productos mas vendidos",
              style: TextStyle(
                  color: colores.colorTexto,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: _handlePrevAno,
                  icon: Icon(
                    Icons.chevron_left,
                    color: colores.colorTexto,
                  )),
              Text(
                "${widget.anos[indexAnoActual]}",
                style: TextStyle(
                    color: colores.colorTexto,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: _handleNextAno,
                  icon: Icon(
                    Icons.chevron_right,
                    color: colores.colorTexto,
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: _handlePrevMes,
                  icon: Icon(
                    Icons.chevron_left,
                    color: colores.colorTexto,
                  )),
              Text(
                "${widget.meses[indexMesActual]}",
                style: TextStyle(
                    color: colores.colorTexto,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: _handleNextMes,
                  icon: Icon(
                    Icons.chevron_right,
                    color: colores.colorTexto,
                  )),
            ],
          ),
          const SizedBox(height: 20),
          // Lista de productos vendidos
          Expanded(
            child: ListView.separated(
              itemCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return productRow(
                  index: index,
                  nombreProducto: "Producto ${index + 1}",
                  precioProducto: "100",
                  cantidadVendida: "10",
                  imagenPath: "assets/images/producto.jpeg",
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 19),
            ),
          ),
        ],
      ),
    );
  }
}