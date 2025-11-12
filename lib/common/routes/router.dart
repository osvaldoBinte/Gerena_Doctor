
import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/features/auth/presentacion/page/Splash/splash_page.dart';
import 'package:gerena/features/auth/presentacion/page/login/login_page.dart';
import 'package:gerena/features/marketplace/presentation/page/shopping/cart_page.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/mobil/get_medications_page.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/mobil/product_detail_page.dart';
import 'package:gerena/features/marketplace/presentation/page/paymentcard/payment_cards_screen.dart';
import 'package:gerena/movil/home/start_page.dart';
import 'package:gerena/page/dashboard/dashboard_page.dart';
import 'package:get/get.dart';
class AppPages {
  static final routes = [
   
    GetPage(
      name: RoutesNames.welcomePage,
      page: () => SplashPage(),
    ),
    GetPage(name: RoutesNames.categoryById, page: ()=>GetMedicationsPage()),
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
      page: () => LoginPage(),
    ),
    GetPage(
      name: RoutesNames.dashboardSPage,
      page: () => DashboardPage(),
    ),
    GetPage(
      name: RoutesNames.shoppdingcart,
      page: () => CartPageContent(),
    ),
    GetPage(
      name: RoutesNames.paymentCardsPage,
      page: () => PaymentCardsScreen(),
    ),
    GetPage(name: RoutesNames.productDetail, page: () =>ProductDetailPage()),
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