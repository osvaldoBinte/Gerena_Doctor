import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/page/dashboard/dashboard_controller.dart';
import 'package:gerena/page/store/cartPage/GlobalShopInterface.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildProfileMenuItem(String title, {String? icon}) {
  return GestureDetector(
    onTap: () {
      _handleMenuNavigation(title);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.rubik(
              fontSize: 14,
              color: GerenaColors.textTertiaryColor,
            ),
          ),
          SizedBox(width: 10),
          if (icon != null) ...[
            Image.asset(
              icon,
              width: 20,
              height: 20,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image_not_supported,
                  size: 20,
                  color: GerenaColors.textSecondaryColor,
                );
              },
            ),
            const SizedBox(width: 10),
          ],
        ],
      ),
    ),
  );
}
 void _handleMenuNavigation(String menuTitle) {
  switch (menuTitle) {
    case 'Historial de pedidos':
      Get.find<ShopNavigationController>().navigateToHistorialDePedidos();
      Get.to(() => GlobalShopInterface());
      break;
    case 'Membresía':
              try {
              if (!Get.isRegistered<DashboardController>()) {
                Get.put(DashboardController());
              }
              
              final dashboardController = Get.find<DashboardController>();
              dashboardController.showMembresia();
            
              
              print('Navegación exitosa a membresía');
            } catch (e) {
              print('Error en navegación a membresía: $e');
            }
      break;
    case 'Facturación':
      Get.find<ShopNavigationController>().navigateFacturacion();
      Get.to(() => GlobalShopInterface());      print('Navegando a Facturación');
      break;
    case 'Cédula profesional':
      print('Navegando a Cédula profesional');
      break;
    case 'Contáctanos':
      print('Navegando a Contáctanos');
      break;
    case 'Sugerencias':
     try {
              if (!Get.isRegistered<DashboardController>()) {
                Get.put(DashboardController());
              }
              
              final dashboardController = Get.find<DashboardController>();
              dashboardController.showUSugerencia();
            
              
              print('Navegación exitosa a membresía');
            } catch (e) {
              print('Error en navegación a membresía: $e');
            }
      print('Navegando a Sugerencias');
      break;
    case 'Preguntas frecuentes':
     try {
              if (!Get.isRegistered<DashboardController>()) {
                Get.put(DashboardController());
              }
              
              final dashboardController = Get.find<DashboardController>();
              dashboardController.showPreguntasFrecuentes();
              
              
              print('Navegación exitosa a membresía');
            } catch (e) {
              print('Error en navegación a membresía: $e');
            }
      print('Navegando a Preguntas frecuentes');
      break;
    default:
      print('Opción no reconocida: $menuTitle');
  }
} 