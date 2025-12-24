import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/features/doctors/domain/usecase/doctor_profile_usecase.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends GetxController {
  final RxBool isLoading = true.obs;
  
  final DoctorProfileUsecase doctorProfileUsecase;
  
  SplashController({required this.doctorProfileUsecase});
  
  @override
  void onInit() async {
    super.onInit();
    await checkUserSession();
  }
  
  Future<void> checkUserSession() async {
    try {
      await doctorProfileUsecase.execute();
      
      // Solicitar permisos de notificación
      if (GetPlatform.isMobile) {
        await _requestNotificationPermission();
        Get.offAllNamed(RoutesNames.homePage, arguments: 0);
      } else {
        Get.toNamed(RoutesNames.dashboardSPage);
      }

    } catch (e) {
      Get.offAllNamed(RoutesNames.loginPage);
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.status;
    
    if (status.isDenied || status.isPermanentlyDenied) {
      final result = await Permission.notification.request();
      
      if (result.isGranted) {
        print('Permiso de notificaciones concedido');
      } else if (result.isDenied) {
        print('Permiso de notificaciones denegado');
      } else if (result.isPermanentlyDenied) {
        print('Permiso de notificaciones denegado permanentemente');
        // Opcionalmente puedes abrir la configuración de la app
        // await openAppSettings();
      }
    } else if (status.isGranted) {
      print('Permiso de notificaciones ya concedido');
    }
  }
}