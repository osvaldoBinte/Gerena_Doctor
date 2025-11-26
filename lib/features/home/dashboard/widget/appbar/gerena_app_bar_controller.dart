import 'package:gerena/features/notification/presentation/page/notificasiones/notification_modal.dart';
import 'package:gerena/features/doctors/presentation/page/editperfildoctor/desktop/Profile_doctor.dart'; 
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart'; 
import 'package:gerena/features/home/dashboard/dashboard_controller.dart';
import 'package:get/get.dart'; 
import 'package:window_manager/window_manager.dart'; 
import 'package:flutter/material.dart'; 
import 'package:gerena/features/home/dashboard/dashboard_page.dart'; 

class GerenaAppBarController extends GetxController with WindowListener {
  
  @override
  void onInit() {
    super.onInit();
    windowManager.addListener(this);
  }
  
  @override
  void onClose() {
    windowManager.removeListener(this);
    super.onClose();
  }
  
  void closeWindow() {
    windowManager.close();
  }
  
  bool _isInDashboardPage() {
    final currentRoute = Get.currentRoute;
    final currentWidget = Get.context?.widget;
    
    return currentRoute == '/DashboardPage' || 
           (currentWidget != null && currentWidget.runtimeType.toString().contains('DashboardPage'));
  }
  
  void _smartNavigateToDashboard({String? view}) {
    bool isInDashboard = _isInDashboardPage();
    
    print('¿Estamos en DashboardPage? $isInDashboard');
    
    if (isInDashboard) {
      if (!Get.isRegistered<DashboardController>()) {
        Get.put(DashboardController());
      }
      
      final dashboardController = Get.find<DashboardController>();
      
      switch (view) {
        case 'main':
          dashboardController.showMainView();
          break;
        case 'doctor_profile':
          dashboardController.showDoctorProfile();
          break;
        case 'user_profile':
          dashboardController.showUserProfile();
          break;
        default:
          dashboardController.showMainView();
      }
    } else {
      Map<String, dynamic>? arguments;
      
      if (view != null) {
        switch (view) {
          case 'main':
            arguments = {'showMainView': true};
            break;
          case 'doctor_profile':
            arguments = {'showDoctorProfile': true};
            break;
          case 'user_profile':
            arguments = {'showUserProfile': true};
            break;
        }
      }
      
      Get.offAll(
        () => const DashboardPage(),
        arguments: arguments,
      );
    }
  }
  
  void navigateToDashboard() {
    print('Navegando al Dashboard - Vista Principal');
    _smartNavigateToDashboard(view: 'main');
  }
  
  void navigateportafolio() {
    print('Navegando al Portafolio');
    _smartNavigateToDashboard(view: 'doctor_profile');
  }
  
  void navigateToProfile() {
    print('Navegando al Perfil de Usuario');
    _smartNavigateToDashboard(view: 'user_profile');
  }
  
  void navigateToStore() {
    print('Navegando a la Tienda');
    Get.offAll(() => GlobalShopInterface());
  }
  
  void showNotifications() {
    print('Mostrando modal de notificaciones');
    if (Get.context != null) {
      NotificationHelper.showNotificationModal(Get.context!);
    }
  }
}