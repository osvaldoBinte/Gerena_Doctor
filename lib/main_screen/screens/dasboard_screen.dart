import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:managegym/dashboard_clientes/clientes_divididos_por_sexo_container.dart';
import 'package:managegym/dashboard_clientes/mes_top_productos_vendidos_container.dart';
import 'package:managegym/dashboard_clientes/nuevos_miembros_mes_container.dart';
import 'package:managegym/dashboard_clientes/rango_de_fechas_usuario_container.dart';
import 'package:managegym/dashboard_clientes/suscripcciones_activas_mes_container.dart';
import 'package:managegym/dashboard_clientes/ventas_por_ano_container.dart';
import 'package:managegym/shared/admin_colors.dart';

// Instancia global para este archivo
final AdminColors colores = AdminColors();

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<String> anos = [
    '2023','2024','2025','2026','2027','2028','2029','2030','2031','2032','2033','2034','2035','2036','2037','2038','2039','2040','2041','2042','2043','2044','2045','2046','2047','2048','2049','2050',
  ];
  List<String> meses = [
    'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'
  ];

  int indexAnoActual = 0;
  int indexMesActual = 0;

  int getIndexAnoActual() {
    DateTime now = DateTime.now();
    String ano = now.year.toString();
    int indexAnoActual = anos.indexOf(ano);
    return indexAnoActual;
  }

  int getIndexMesActual() {
    DateTime now = DateTime.now();
    String mes = meses[now.month - 1];
    int indexMesActual = meses.indexOf(mes);
    return indexMesActual;
  }

  void onChangeAno(int index) {
    setState(() {
      indexAnoActual = index;
    });
  }

  void onChangeMes(int index) {
    setState(() {
      indexMesActual = index;
    });
  }

  bool showProductos = true;
  bool showSuscripciones = true;

  @override
  void initState() {
    super.initState();
    indexAnoActual = getIndexAnoActual();
    indexMesActual = getIndexMesActual();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              VentasPorAnoContainer(
                anos: anos,
                mese: meses,
              ),
              const SizedBox(width: 20),
              MesTopProductosVendidosContainer(
                anos: anos,
                meses: meses,
              ),
              const SizedBox(width: 20),
              RangoDeFechasUsuariosContainer(anos: anos, meses: meses)
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Ventas",
                style: TextStyle(
                  color: colores.colorTexto,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: () {
                  setState(() {
                    showProductos = !showProductos;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: showProductos
                        ? colores.colorAccionButtons
                        : colores.colorFondoModal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Productos",
                    style: TextStyle(
                        color: colores.colorTexto, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: () {
                  setState(() {
                    showSuscripciones = !showSuscripciones;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: showSuscripciones
                        ? colores.colorAccionButtons
                        : colores.colorFondoModal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Suscripciones",
                    style: TextStyle(
                        color: colores.colorTexto, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: 18,
                height: 18,
                color: Colors.blue,
                margin: const EdgeInsets.only(right: 6),
              ),
              Text(
                "Suscripciones",
                style: TextStyle(
                  color: colores.colorTexto,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: 18,
                height: 18,
                color: Colors.amber,
                margin: const EdgeInsets.only(right: 6),
              ),
              Text(
                "Productos",
                style: TextStyle(
                  color: colores.colorTexto,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: SizedBox(
                height: 600,
                child: LineChartExample(
                  showProductos: showProductos,
                  showSuscripciones: showSuscripciones,
                ),
              )),
            ],
          )
        ],
      ),
    );
  }
}

class LineChartExample extends StatelessWidget {
  final bool showProductos;
  final bool showSuscripciones;

  LineChartExample({
    this.showProductos = true,
    this.showSuscripciones = true,
    Key? key,
  }) : super(key: key);

  final List<Map<String, dynamic>> data = [
    {'mes': 'Enero', 'producto': 900, 'suscripcion': 9876},
    {'mes': 'Febrero', 'producto': 800, 'suscripcion': 7000},
    {'mes': 'Marzo', 'producto': 500, 'suscripcion': 8971},
    {'mes': 'Abril', 'producto': 400, 'suscripcion': 4000},
    {'mes': 'Mayo', 'producto': 100, 'suscripcion': 4302},
    {'mes': 'Junio', 'producto': 789, 'suscripcion': 2224},
    {'mes': 'Julio', 'producto': 400, 'suscripcion': 4305},
    {'mes': 'Agosto', 'producto': 450, 'suscripcion': 2006},
    {'mes': 'Septiembre', 'producto': 580, 'suscripcion': 3407},
    {'mes': 'Octubre', 'producto': 520, 'suscripcion': 2408},
    {'mes': 'Noviembre', 'producto': 921, 'suscripcion': 6009},
    {'mes': 'Diciembre', 'producto': 600, 'suscripcion': 7505},
  ];

  @override
  Widget build(BuildContext context) {
    List<LineChartBarData> lines = [];
    List<FlSpot> productoSpots = [];
    List<FlSpot> suscripcionSpots = [];

    for (int i = 0; i < data.length; i++) {
      productoSpots.add(FlSpot(i.toDouble(), data[i]['producto'].toDouble()));
      suscripcionSpots
          .add(FlSpot(i.toDouble(), data[i]['suscripcion'].toDouble()));
    }
    if (showProductos) {
      lines.add(
        LineChartBarData(
          spots: productoSpots,
          isCurved: false,
          color: Colors.amber,
          barWidth: 4,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
              radius: 10,
              color: Colors.amber,
            ),
          ),
        ),
      );
    }
    if (showSuscripciones) {
      lines.add(
        LineChartBarData(
          spots: suscripcionSpots,
          isCurved: false,
          color: Colors.blue,
          barWidth: 4,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
              radius: 10,
              color: Colors.blue,
            ),
          ),
        ),
      );
    }

    return LineChart(
      LineChartData(
        lineBarsData: lines,
        backgroundColor: colores.colorFondoModal,
        minX: -0.1,
        maxX: data.length - 0.7,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (value == index.toDouble() && index >= 0 && index < data.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 4.0,
                    child: Text(
                      data[index]['mes'],
                      style: TextStyle(
                        color: colores.colorTexto,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              interval: 1,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 4.0,
                  child: Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: colores.colorTexto,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}