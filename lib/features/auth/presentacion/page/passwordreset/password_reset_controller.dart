import 'package:flutter/material.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/auth/domain/usecase/confirm_password_reset_usecase.dart';
import 'package:gerena/features/auth/domain/usecase/request_password_code_usecase.dart';
import 'package:get/get.dart';

class PasswordResetController extends GetxController {
  final ConfirmPasswordResetUsecase confirmPasswordResetUsecase;
  final RequestPasswordCodeUsecase requestPasswordCodeUsecase;

  PasswordResetController({
    required this.confirmPasswordResetUsecase,
    required this.requestPasswordCodeUsecase,
  });

  // Controllers
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Estados
  final RxBool isLoading = false.obs;
  final RxBool isFirstScreen = true.obs;
  final RxBool showPassword = false.obs;
  final RxBool showConfirmPassword = false.obs;

  // Errores usando RxnString (Rx nullable String)
  final RxnString emailError = RxnString(null);
  final RxnString codeError = RxnString(null);
  final RxnString passwordError = RxnString(null);
  final RxnString confirmPasswordError = RxnString(null);

  @override
  void onClose() {
    emailController.dispose();
    codeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void clearErrors() {
    emailError.value = null;
    codeError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;
  }

  bool _validateEmail() {
    clearErrors();
    if (emailController.text.isEmpty) {
      emailError.value = 'El correo es requerido';
      return false;
    }
    if (!GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Ingresa un correo válido';
      return false;
    }
    return true;
  }

  bool _validateResetForm() {
    clearErrors();
    bool isValid = true;

    if (codeController.text.isEmpty) {
      codeError.value = 'El código es requerido';
      isValid = false;
    }

    if (newPasswordController.text.isEmpty) {
      passwordError.value = 'La contraseña es requerida';
      isValid = false;
    } else if (newPasswordController.text.length < 6) {
      passwordError.value = 'La contraseña debe tener al menos 6 caracteres';
      isValid = false;
    }

    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Confirma tu contraseña';
      isValid = false;
    } else if (newPasswordController.text != confirmPasswordController.text) {
      confirmPasswordError.value = 'Las contraseñas no coinciden';
      isValid = false;
    }

    return isValid;
  }

  Future<void> requestCode() async {
    if (!_validateEmail()) return;

    try {
      isLoading.value = true;
      await requestPasswordCodeUsecase.execute(emailController.text.trim());
      
      showSuccessSnackbar('Código enviado. Revisa tu correo electrónico');
      
      isFirstScreen.value = false;
    } catch (e) {
      print(e);
      showErrorSnackbar('No se pudo enviar el código. Verifica tu correo.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmPasswordReset() async {
    if (!_validateResetForm()) return;

    try {
      isLoading.value = true;
      await confirmPasswordResetUsecase.confirmPasswordReset(
        emailController.text.trim(),
        codeController.text.trim(),
        newPasswordController.text,
      );

      showSuccessSnackbar('Contraseña actualizada correctamente');

      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed('/login');
      
    } catch (e) {
      showErrorSnackbar('No se pudo actualizar la contraseña. Verifica el código.');
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    showConfirmPassword.value = !showConfirmPassword.value;
  }

  void backToFirstScreen() {
    isFirstScreen.value = true;
    clearErrors();
    codeController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }
}