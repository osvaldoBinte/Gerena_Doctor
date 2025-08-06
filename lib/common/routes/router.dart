
import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/splashpage/splash_page.dart';
import 'package:gerena/movil/home/start_page.dart';
import 'package:gerena/movil/login/login_page_movil.dart';
import 'package:gerena/page/dashboard/dashboard_page.dart';
import 'package:gerena/page/login_page.dart';
import 'package:get/get.dart';
class AppPages {
  static final routes = [
   
    GetPage(
      name: RoutesNames.welcomePage,
      page: () => SplashPage(),
    ),
    GetPage(
      name: RoutesNames.loginPage,
      page: () => LoginPage(),

    ),
    GetPage(
      name: RoutesNames.homePage,
      page: () => StartPage(),
    ),
    GetPage(
      name: RoutesNames.loginPageMovil,
      page: () => LoginPageMovil(),
    ),
    GetPage(
      name: RoutesNames.dashboardSPage,
      page: () => DashboardPage(),
    ),
    GetPage(
      name: '/home',
      page: () => Scaffold(
        body: Center(
          child: Text('Página principal'),
        ),
      ),
    ),
  ];

  static final unknownRoute = GetPage(
    name: '/not-found',
    page: () => Scaffold(
      body: Center(
        child: Text('Ruta no encontrada'),
      ),
    ),
  );
}