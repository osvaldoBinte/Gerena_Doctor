import 'package:flutter/material.dart';
import 'package:managegym/clientes/presentation/widgets/row_table_clients_home_widget.dart';
import 'package:managegym/dashboard_clientes/clientes_divididos_por_sexo_container.dart';
import 'package:managegym/dashboard_clientes/mes_top_productos_vendidos_container.dart';
import 'package:managegym/dashboard_clientes/nuevos_miembros_mes_container.dart';
import 'package:managegym/dashboard_clientes/suscripcciones_activas_mes_container.dart';
import 'package:managegym/dashboard_clientes/ventas_por_ano_container.dart';
import 'package:managegym/main_screen/screens/clients_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<String> anos = [
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030',
    '2031',
    '2032',
    '2033',
    '2034',
    '2035',
    '2036',
    '2037',
    '2038',
    '2039',
    '2040',
    '2041',
    '2042',
    '2043',
    '2044',
    '2045',
    '2046',
    '2047',
    '2048',
    '2049',
    '2050',
  ];
  List<String> meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
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
              const SizedBox(
                width: 20,
              ),
              MesTopProductosVendidosContainer(
                anos: anos,
                meses: meses,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SuscripccionesActivasMesContainer(
                          cantidadTotal: 10,
                          cantidadM: 5,
                          cantidadF: 5,
                          anos: anos,
                          meses: meses,
                          colorFondoModal: colors.colorFondoModal,
                          colorTexto: colors.colorTexto,
                        ),
                        NuevosMiembrosMesContainer(
                          cantidadTotal: 10,
                          cantidadM: 5,
                          cantidadF: 5,
                          anos: anos,
                          meses: meses,
                          colorFondoModal: colors.colorFondoModal,
                          colorTexto: colors.colorTexto,
                        ),
                        ClientesDivididosPorSexo(
                          cantidadTotal: 10,
                          cantidadM: 5,
                          cantidadF: 5,
                          colorFondoModal: colors.colorFondoModal,
                          colorTexto: colors.colorTexto,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: colors.colorFondoModal,
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
                      children: [
                        Text("RANGO DE EDADES",
                            style: TextStyle(
                                color: colors.colorTexto,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Expanded(
                          
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("ACTIVOS: 12",
                                        style: TextStyle(
                                            color: colors.colorTexto,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w400)),
                                   Text("INACTIVOS: 12",
                                        style: TextStyle(
                                            color: colors.colorTexto,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w400)),
                                            Row(
                                              children: [
                                                Text("0 - 16",
                                        style: TextStyle(
                                            color: colors.colorTexto,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w400)),
                                              ],
                                            )
                                  ],
                                )),
                                // 
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("ACTIVOS: 12",
                                        style: TextStyle(
                                            color: colors.colorTexto,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w400)),
                                   Text("INACTIVOS: 12",
                                        style: TextStyle(
                                            color: colors.colorTexto,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w400)),
                                            Row(
                                              children: [
                                                Text("17 - 28",
                                        style: TextStyle(
                                            color: colors.colorTexto,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w400)),
                                              ],
                                            )
                                  ],
                                )),
                                //
                                 Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("ACTIVOS: 12",
                                        style: TextStyle(
                                            color: colors.colorTexto,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w400)),
                                   Text("INACTIVOS: 12",
                                        style: TextStyle(
                                            color: colors.colorTexto,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w400)),
                                            Row(
                                              children: [
                                                Text("28 - 38",
                                        style: TextStyle(
                                            color: colors.colorTexto,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w400)),
                                              ],
                                            )
                                  ],
                                )),
                                //
                                 Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("ACTIVOS: 12",
                                        style: TextStyle(
                                            color: colors.colorTexto,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w400)),
                                   Text("INACTIVOS: 12",
                                        style: TextStyle(
                                            color: colors.colorTexto,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w400)),
                                            Row(
                                              children: [
                                                Text("MAYORES DE 39",
                                        style: TextStyle(
                                            color: colors.colorTexto,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w400)),
                                              ],
                                            )
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}
