import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/auth/presentacion/page/login/login_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io' show Platform;

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: GerenaColors.backgroundlogin,
        body: SafeArea(
          child: isMobile 
            ? _buildMobileLayout(controller, context)
            : _buildDesktopLayout(controller, context),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(LoginController controller, BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: screenSize.height * 0.3,
            child: Center(
              child: Image.asset(
                'assets/gerena-logo.png',
                width: screenSize.width * 0.7,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
          ),
          
          _buildLoginForm(controller, isMobile: true),
          
          const SizedBox(height: 16),
          
          GerenaColors.createLoginButton(
            text: 'Ingresar con Face ID / Huella',
            onPressed: () {},
            icon: Image.asset(
              'assets/icons/fingerprint.png',
              width: 18,
              height: 18,
            ),
            width: double.infinity,
          ),
          
          const SizedBox(height: 5),
       
          
          const SizedBox(height: 20),
          
        //  _buildFooterMobile(),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(LoginController controller, BuildContext context) {
    final isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    
    return Stack(
      children: [
        if (isDesktop)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: (details) {
                windowManager.startDragging();
              },
              onDoubleTap: () async {
                if (await windowManager.isMaximized()) {
                  windowManager.unmaximize();
                } else {
                  windowManager.maximize();
                }
              },
              child: Container(
                height: 40,
                color: Colors.transparent,
              ),
            ),
          ),
        
        Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GerenaColors.createAppLogo(),
                const SizedBox(height: 50),
                
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    children: [
                      _buildLoginForm(controller, isMobile: false),
                      
                      const SizedBox(height: 30),
                      
                      Center(
                        child: GerenaColors.createLoginButton(
                          text: 'Iniciar con código QR',
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
      //  _buildFooterDesktop(),
      ],
    );
  }

  Widget _buildLoginForm(LoginController controller, {required bool isMobile}) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GerenaColors.createLoginLabel('Correo electrónico'),
        const SizedBox(height: 8),
        
        GerenaColors.createLoginTextField(
          controller: controller.emailController,
          focusNode: controller.emailFocusNode,
          hintText: 'username@example.com',
          keyboardType: TextInputType.emailAddress,
          onSubmitted: (_) => controller.onemailSubmitted(),
        ),
        
        const SizedBox(height: 16),
        
        GerenaColors.createLoginLabel('Contraseña'),
        const SizedBox(height: 8),
        
        GerenaColors.createLoginTextField(
          controller: controller.passwordController,
          focusNode: controller.passwordFocusNode,
          hintText: '',
          obscureText: !controller.showPassword.value,
          onSubmitted: (_) => controller.onPasswordSubmitted(),
        ),
        
        Align(
          alignment: Alignment.centerRight,
          child: GerenaColors.createLoginTextButton(
            text: 'Olvidé mi contraseña',
            onPressed: () {},
            fontSize: 14,
          ),
        ),
        
        const SizedBox(height: 24),
        
        Center(
          child: controller.isLoading.value
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : GerenaColors.createLoginButton(
                text: 'Iniciar sesión',
                onPressed: controller.onLoginTap,
                width: isMobile ? double.infinity : 300.0,
              ),
        ),
      ],
    ));
  }

  Widget _buildFooterMobile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GerenaColors.createLoginTextButton(
          text: 'ESP',
          onPressed: () {},
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        GerenaColors.createLoginTextButton(
          text: 'ENG',
          onPressed: () {},
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            'assets/icons/headset_mic.png',
            color: GerenaColors.textLightColor,
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterDesktop() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 30,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'ESP',
                    style: GoogleFonts.rubik(
                      color: GerenaColors.textLightColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'ENG',
                    style: GoogleFonts.rubik(
                      color: GerenaColors.textLightColor.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Contáctanos',
                    style: GoogleFonts.rubik(
                      color: GerenaColors.textLightColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        'Soporte técnico',
                        style: GoogleFonts.rubik(
                          color: GerenaColors.textLightColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        'assets/icons/headset_mic.png',
                        width: 18,
                        height: 18,
                        color: GerenaColors.textLightColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}