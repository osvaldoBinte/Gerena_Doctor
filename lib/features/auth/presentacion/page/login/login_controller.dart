import 'package:flutter/material.dart';
import 'package:gerena/common/errors/convert_message.dart';
import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/common/services/notification_service.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/widgets/custom_alert_type.dart';
import 'package:gerena/features/auth/domain/usecase/login_usecase.dart';
import 'package:gerena/features/notification/domain/usecase/save_token_fcm_usecase.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final FocusNode emailFocusNode;
  late final FocusNode passwordFocusNode;

  final RxBool isLoading = false.obs;
  final RxBool showPassword = false.obs;

  final AuthService _authService = Get.find<AuthService>();
  final LoginUsecase loginUsecase;
  final SaveTokenFcmUsecase saveTokenFcmUsecase;

  LoginController({
    required this.loginUsecase,
    required this.saveTokenFcmUsecase,
  });

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  void _initializeControllers() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  void onemailSubmitted() {
    passwordFocusNode.requestFocus();
  }

  void onPasswordSubmitted() {
    passwordFocusNode.unfocus();
    onLoginTap();
  }

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  void onLoginTap() async {
    if (!_validateFields()) return;

    try {
      isLoading.value = true;

      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final loginResponse = await loginUsecase.execute(
        email: email,
        password: password,
      );

      await _authService.saveLoginResponse(loginResponse);

      // NUEVO: Guardar token FCM después del login exitoso
      await _saveDeviceToken();

      _clearFields();
      await _resetControllersForNewSession();
      
      if (GetPlatform.isMobile) {
        Get.offAllNamed(RoutesNames.homePage, arguments: 0);
      } else {
        Get.toNamed(RoutesNames.dashboardSPage);
      }
    } catch (e) {
      _showErrorAlert(
        'ACCESO INCORRECTO',
        cleanExceptionMessage(e),
      );
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // NUEVO: Método para guardar el token FCM
  Future<void> _saveDeviceToken() async {
    try {
      // Solo guardar token en dispositivos móviles
      if (!GetPlatform.isMobile) {
        print('ℹ️ Dispositivo no móvil - omitiendo guardado de token FCM');
        return;
      }

      // Obtener el token FCM
      final fcmToken = await NotificationService().getToken();

      if (fcmToken == null) {
        print('⚠️ No se pudo obtener el token FCM');
        return;
      }

      // Detectar el tipo de dispositivo
      String deviceType = _getDeviceType();

      print('📤 Guardando token FCM en el servidor...');
      print('   - Token: ${fcmToken}...');
      print('   - Dispositivo: $deviceType');

      // Guardar el token en el backend
      await saveTokenFcmUsecase.execute(fcmToken, deviceType);

      print('✅ Token FCM guardado exitosamente');
    } catch (e) {
      // No bloqueamos el login si falla el guardado del token
      print('❌ Error al guardar token FCM: $e');
      // Opcional: podrías enviar esto a un servicio de logging
    }
  }

  // NUEVO: Detectar el tipo de dispositivo
  String _getDeviceType() {
    if (GetPlatform.isAndroid) {
      return 'Android';
    } else if (GetPlatform.isIOS) {
      return 'iOS';
    } else if (GetPlatform.isMacOS) {
      return 'macOS';
    } else if (GetPlatform.isWindows) {
      return 'Windows';
    } else if (GetPlatform.isLinux) {
      return 'Linux';
    } else if (GetPlatform.isWeb) {
      return 'Web';
    }
    return 'Unknown';
  }

  Future<void> _resetControllersForNewSession() async {
    print('🔄 Reseteando controllers para nueva sesión...');

    try {
      final controllersToDelete = [];

      for (final controllerType in controllersToDelete) {
        if (Get.isRegistered(tag: controllerType.toString())) {
          Get.delete(tag: controllerType.toString());
          print('🗑️ ${controllerType.toString()} eliminado');
        }
      }

      await Future.delayed(const Duration(milliseconds: 100));

      print('✅ Controllers reseteados para nueva sesión');
    } catch (e) {
      print('❌ Error reseteando controllers: $e');
    }
  }

  void _showErrorAlert(String title, String message,
      {VoidCallback? onDismiss}) {
    if (Get.context != null) {
      showCustomAlert(
        context: Get.context!,
        title: title,
        message: message,
        confirmText: 'Aceptar',
        type: CustomAlertType.error,
        onConfirm: onDismiss,
      );
    }
  }

  bool _validateFields() {
    if (emailController.text.isEmpty) {
      _showErrorAlert(
        'Advertencia',
        'Por favor, ingresa tu usuario',
      );
      return false;
    }

    if (passwordController.text.isEmpty) {
      _showErrorAlert(
        'Advertencia',
        'Por favor, ingresa tu contraseña',
      );
      return false;
    }

    return true;
  }

  void _clearFields() {
    if (emailController.hasListeners) {
      emailController.clear();
    }
    if (passwordController.hasListeners) {
      passwordController.clear();
    }
  }

  void onRegisterTap() {}

  @override
  void onClose() {
    if (!emailController.hasListeners) {
      emailController.dispose();
    }
    if (!passwordController.hasListeners) {
      passwordController.dispose();
    }

    emailFocusNode.dispose();
    passwordFocusNode.dispose();

    super.onClose();
  }
}