import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:get/get.dart';
import 'package:gerena/common/settings/routes_names.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Colores del theme
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateToLogin();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  _navigateToLogin() async {
    // Simular tiempo de carga del splash con animación
    await Future.delayed(Duration(seconds: 3));
    
    // Detectar si es móvil o escritorio
    bool isMobile = _isMobileDevice();
    
    if (isMobile) {
      // Navegar al login móvil
      Get.offNamed(RoutesNames.loginPageMovil);
    } else {
      // Navegar al login de escritorio
      Get.offNamed(RoutesNames.loginPage);
    }
  }

  bool _isMobileDevice() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600; // Considera móvil si el lado más corto es menor a 600px
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: GerenaColors.backgroundlogin,
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GerenaColors.createAppLogo(size: 250,padding: EdgeInsets.only(bottom: 20)),
           
            ],
          ),
        ),
      ),
    ),
  );
}
}