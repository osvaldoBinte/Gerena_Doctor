import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/subscription/presentation/page/menbresia/menbreria_movil.dart';
import 'package:gerena/features/home/dashboard/dashboard_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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


bool _isMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < 768; 
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
      try {
        final context = Get.context;
        if (context != null && _isMobile(context)) {
          Get.to(() => const MembresiaPage());
          print('Navegación exitosa a MembresiaPage (móvil)');
        } else {
          if (!Get.isRegistered<DashboardController>()) {
            Get.put(DashboardController());
          }
          
          final dashboardController = Get.find<DashboardController>();
          dashboardController.showMembresia();
          print('Navegación exitosa a membresía (escritorio)');
        }
      } catch (e) {
        print('Error en navegación a membresía: $e');
        try {
          if (!Get.isRegistered<DashboardController>()) {
            Get.put(DashboardController());
          }
          final dashboardController = Get.find<DashboardController>();
          dashboardController.showMembresia();
          print('Fallback exitoso a DashboardController');
        } catch (fallbackError) {
          print('Error en fallback: $fallbackError');
        }
      }
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
        if (!Get.isRegistered<DashboardController>()) {
          Get.put(DashboardController());
        }

        final dashboardController = Get.find<DashboardController>();
        dashboardController.showUSugerencia();

        print('Navegación exitosa a sugerencias');
      } catch (e) {
        print('Error en navegación a sugerencias: $e');
      }
      break;
      
    case 'Preguntas frecuentes':
      try {
        if (!Get.isRegistered<DashboardController>()) {
          Get.put(DashboardController());
        }

        final dashboardController = Get.find<DashboardController>();
        dashboardController.showPreguntasFrecuentes();

        print('Navegación exitosa a preguntas frecuentes');
      } catch (e) {
        print('Error en navegación a preguntas frecuentes: $e');
      }
      break;
      case 'Cerrar sesión':
                                Get.toNamed(RoutesNames.loginPage);

      break;
      
    default:
      print('Opción no reconocida: $menuTitle');
  }
}

// Alternativa más avanzada para detectar el tipo de dispositivo
class DeviceUtils {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 768 && width < 1024;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }
  
  static bool isMobileOrTablet(BuildContext context) {
    return MediaQuery.of(context).size.width < 1024;
  }
}

// Versión alternativa de la función usando DeviceUtils
void _handleMenuNavigationAdvanced(String menuTitle) {
  switch (menuTitle) {
    case 'Membresía':
      try {
        final context = Get.context;
        if (context != null && DeviceUtils.isMobileOrTablet(context)) {
          // Móvil o tablet - usar MembresiaPage
          Get.to(() => const MembresiaPage());
          print('Navegación a MembresiaPage (móvil/tablet)');
        } else {
          // Escritorio - usar DashboardController
          if (!Get.isRegistered<DashboardController>()) {
            Get.put(DashboardController());
          }
          
          final dashboardController = Get.find<DashboardController>();
          dashboardController.showMembresia();
          print('Navegación a DashboardController (escritorio)');
        }
      } catch (e) {
        print('Error en navegación: $e');
      }
      break;
    // ... resto de casos
  }
}