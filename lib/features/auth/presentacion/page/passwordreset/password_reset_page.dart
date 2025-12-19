import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/auth/presentacion/page/passwordreset/password_reset_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class PasswordResetPage extends GetView<PasswordResetController> {
  const PasswordResetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GerenaColors.modalBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: GerenaColors.backgroundColorFondo,
          elevation: 4,
          shadowColor: GerenaColors.shadowColor,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: GerenaColors.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [GerenaColors.lightShadow],
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Obx(
                    () => controller.isFirstScreen.value
                        ? _buildFirstScreen()
                        : _buildSecondScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstScreen() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'RECUPERAR CONTRASEÑA',
            style: GoogleFonts.rubik(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: GerenaColors.textTertiary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Ingresa tu correo electrónico para recibir un código de recuperación',
            style: GoogleFonts.rubik(
              fontSize: 14,
              color: GerenaColors.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: GerenaColors.textSecondaryColor.withOpacity(0.3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'o',
                  style: GoogleFonts.rubik(
                    color: GerenaColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: GerenaColors.textSecondaryColor.withOpacity(0.3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          GerenaColors.createTextField(
            label: 'Dirección Email',
            controller: controller.emailController,
            hintText: 'username@example.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => controller.requestCode(),
            errorText: controller.emailError,
          ),
          const SizedBox(height: 24),

          Obx(() => SizedBox(
                width: 200,
                child: GerenaColors.widgetButton(
                  text: 'Enviar código',
                  onPressed: controller.requestCode,
                  isLoading: controller.isLoading.value,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                ),
              )),
          const SizedBox(height: 16),

          TextButton(
            onPressed: () {
              Get.offAllNamed(RoutesNames.loginPage);
            },
            child: Text(
              'Iniciar sesión con mi cuenta',
              style: GoogleFonts.rubik(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: GerenaColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondScreen() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
     Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const SizedBox(width: 24),
    Expanded(
      child: Text(
        'RESTABLECER CONTRASEÑA',
        style: GoogleFonts.rubik(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: GerenaColors.textTertiary,
        ),
        textAlign: TextAlign.center,
      
      ),
    ),
    IconButton(
      onPressed: controller.backToFirstScreen,
      icon: Icon(Icons.close, color: GerenaColors.textTertiary),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    ),
  ],
),
const SizedBox(height: 12),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8.0),
  child: Text(
    'Código enviado a ${controller.emailController.text}',
    style: GoogleFonts.rubik(
      fontSize: 14,
      color: GerenaColors.textSecondaryColor,
    ),
    textAlign: TextAlign.center,
    overflow: TextOverflow.ellipsis,
    maxLines: 2,
  ),
),
const SizedBox(height: 24),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GerenaColors.createTextField(
                          label: 'Código de verificación',
                          controller: controller.codeController,
                          hintText: 'Ingresa el código',
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(Get.context!).nextFocus(),
                          errorText: controller.codeError,
                        ),
                        const SizedBox(height: 16),

                        Obx(() => GerenaColors.buildPasswordField(
                              label: 'Nueva contraseña',
                              controller: controller.newPasswordController,
                              obscureText: !controller.showPassword.value,
                              onToggleVisibility: controller.togglePasswordVisibility,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(Get.context!).nextFocus(),
                              errorText: controller.passwordError,
                            )),
                        const SizedBox(height: 16),

                        Obx(() => GerenaColors.buildPasswordField(
                              label: 'Confirmar contraseña',
                              controller: controller.confirmPasswordController,
                              obscureText: !controller.showConfirmPassword.value,
                              onToggleVisibility: controller.toggleConfirmPasswordVisibility,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) {
                                FocusScope.of(Get.context!).unfocus();
                              },
                              errorText: controller.confirmPasswordError,
                            )),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Obx(
                  () => controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: 200,
                          child: GerenaColors.widgetButton(
                            text: 'Cambiar contraseña',
                            onPressed: controller.confirmPasswordReset,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}