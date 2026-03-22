import 'package:flutter/material.dart';
import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/subscription/presentation/page/menbresia/menbreria_movil.dart';
import 'package:gerena/features/home/dashboard/dashboard_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

        final dashboardController = Get.find<DashboardController>();
 AuthService authService = Get.find<AuthService>();

Widget buildProfileMenuItem(String title, {String? icon}) {
  return MouseRegion(
    cursor: SystemMouseCursors.click, 
    child: GestureDetector(
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
            const SizedBox(width: 10),
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
    ),
  );
}


void _handleMenuNavigation(String menuTitle) {
  switch (menuTitle) {
   case 'Historial de pedidos':
    if (GetPlatform.isMobile) {
      Get.offAllNamed(RoutesNames.historia);
    } else {
      Get.find<ShopNavigationController>().navigateToHistorialDePedidos();
      Get.to(() => GlobalShopInterface());
    }
    break;
      
    case 'Membresía':
     GetPlatform.isMobile
        ? Get.toNamed(RoutesNames.membresia)
        : Get.find<DashboardController>().showMembresia();
     
      break;
      
    case 'Facturación':
      Get.find<ShopNavigationController>().navigateFacturacion();
      Get.to(() => GlobalShopInterface());
      print('Navegando a Facturación');
      break;
      
    case 'Cédula profesional':
      print('Navegando a Cédula profesional');
      break;
      
    case 'Contáctanos':
      print('Navegando a Contáctanos');
      break;
      
    case 'Sugerencias':
      try {
        dashboardController.showUSugerencia();

        print('Navegación exitosa a sugerencias');
      } catch (e) {
        print('Error en navegación a sugerencias: $e');
      }
      break;
      
    case 'Preguntas frecuentes':
    GetPlatform.isMobile
        ? Get.toNamed(RoutesNames.preguntasFrecuentes)
        : Get.find<DashboardController>().showPreguntasFrecuentes();
      
      break;
      case 'Cerrar sesión':
      authService.logout();
                                Get.toNamed(RoutesNames.loginPage);

      break;
      
    default:
      print('Opción no reconocida: $menuTitle');
  }
}
