import 'package:gerena/common/errors/subscripcion_inactiva_exception.dart';
import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/features/doctors/domain/usecase/doctor_profile_usecase.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:permission_handler/permission_handler.dart';
class SplashController extends GetxController {
  final RxBool isLoading = true.obs;

  final DoctorProfileUsecase doctorProfileUsecase;

  SplashController({required this.doctorProfileUsecase});

  @override
  void onInit() async {
    super.onInit();
    if (GetPlatform.isMobile) {
    await _requestNotificationPermission();

    await _requestCameraPermission();
    await _requestMicrophonePermission();
    }
    await checkUserSession();
  }

Future<void> checkUserSession() async {
  try {
    await doctorProfileUsecase.execute();

    if (GetPlatform.isMobile) {
      Get.offAllNamed(RoutesNames.homePage, arguments: 0);
    } else {
      Get.toNamed(RoutesNames.dashboardSPage);
    }
  } on SubscripcionInactivaException catch (_) {
      Get.offAllNamed(RoutesNames.membresia, arguments: {'isRequired': true});

  } catch (e) {
    // Cualquier otro error (token inválido, sin conexión, etc.) → login
    Get.offAllNamed(RoutesNames.loginPage);
  } finally {
    isLoading.value = false;
  }
}

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();

    if (status.isGranted) {
      print('✅ Permiso de micrófono concedido');
    } else if (status.isDenied) {
      print('❌ Permiso de micrófono denegado');
    } else if (status.isPermanentlyDenied) {
      print('🚫 Permiso de micrófono permanentemente denegado');
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      print('✅ Permiso de cámara concedido');
    } else if (status.isDenied) {
      print('❌ Permiso de cámara denegado');
    } else if (status.isPermanentlyDenied) {
      print('🚫 Permiso de cámara permanentemente denegado');
      // await openAppSettings();
    }
  }
 Future<void> _requestNotificationPermission() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('Estado de permisos: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permisos de notificaciones concedidos');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Permisos provisionales concedidos');
    } else {
      print('Permisos de notificaciones denegados');
    }
  }
}
