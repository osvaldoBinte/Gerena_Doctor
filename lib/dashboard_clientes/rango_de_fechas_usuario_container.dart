import 'package:flutter/material.dart';
import 'package:managegym/dashboard_clientes/clientes_divididos_por_sexo_container.dart';
import 'package:managegym/dashboard_clientes/nuevos_miembros_mes_container.dart';
import 'package:managegym/dashboard_clientes/suscripcciones_activas_mes_container.dart';
import 'package:managegym/shared/admin_colors.dart';

class RangoDeFechasUsuariosContainer extends StatelessWidget {
  const RangoDeFechasUsuariosContainer({
    super.key,
    required this.anos,
    required this.meses,
  });

  final List<String> anos;
  final List<String> meses;

  @override
  Widget build(BuildContext context) {
    // Instancia local de AdminColors
    final AdminColors colors = AdminColors();

    return Expanded(
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
                Text(
                  "RANGO DE EDADES",
                  style: TextStyle(
                    color: colors.colorTexto,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("ACTIVOS: 12",
                                  style: TextStyle(
                                      color: colors.colorTexto,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w400)),
                              Text("INACTIVOS: 12",
                                  style: TextStyle(
                                      color: colors.colorTexto,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                              Row(
                                children: [
                                  Text("0 - 16",
                                      style: TextStyle(
                                          color: colors.colorTexto,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400)),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("ACTIVOS: 12",
                                  style: TextStyle(
                                      color: colors.colorTexto,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                              Text("INACTIVOS: 12",
                                  style: TextStyle(
                                      color: colors.colorTexto,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                              Row(
                                children: [
                                  Text("17 - 28",
                                      style: TextStyle(
                                          color: colors.colorTexto,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400)),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("ACTIVOS: 12",
                                  style: TextStyle(
                                      color: colors.colorTexto,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                              Text("INACTIVOS: 12",
                                  style: TextStyle(
                                      color: colors.colorTexto,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                              Row(
                                children: [
                                  Text("28 - 38",
                                      style: TextStyle(
                                          color: colors.colorTexto,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400)),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("ACTIVOS: 12",
                                  style: TextStyle(
                                      color: colors.colorTexto,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                              Text("INACTIVOS: 12",
                                  style: TextStyle(
                                      color: colors.colorTexto,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                              Row(
                                children: [
                                  Text("39 - 50",
                                      style: TextStyle(
                                          color: colors.colorTexto,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400)),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("ACTIVOS: 12",
                                  style: TextStyle(
                                      color: colors.colorTexto,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                              Text("INACTIVOS: 12",
                                  style: TextStyle(
                                      color: colors.colorTexto,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                              Row(
                                children: [
                                  Text("MAYORES DE 51",
                                      style: TextStyle(
                                          color: colors.colorTexto,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}