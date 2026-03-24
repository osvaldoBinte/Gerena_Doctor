import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/features/appointment/presentation/page/calendar/calendar_widget.dart';
import 'package:gerena/features/auth/presentacion/page/Splash/splash_page.dart';
import 'package:gerena/features/auth/presentacion/page/login/login_page.dart';
import 'package:gerena/features/auth/presentacion/page/passwordreset/password_reset_page.dart';
import 'package:gerena/features/doctors/presentation/page/patientVie/patient_view_page.dart';
import 'package:gerena/features/followers/presentation/page/followers_following_page.dart';
import 'package:gerena/features/followers/presentation/page/user_followers_following_page.dart';
import 'package:gerena/features/home/dashboard/widget/preguntasFrecuentes/preguntas_frecuentes.dart';
import 'package:gerena/features/marketplace/presentation/page/getmylastpaidorder/history/historial_de_pedidos_content.dart';
import 'package:gerena/features/marketplace/presentation/page/shopping/cart_page.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/mobil/get_medications_page.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/mobil/product_detail_page.dart';
import 'package:gerena/features/marketplace/presentation/page/paymentcard/payment_cards_screen.dart';
import 'package:gerena/features/publications/presentation/page/getPostReaction/get_post_reaction_page.dart';
import 'package:gerena/features/publications/presentation/page/postbyid/post_byId_page.dart';
import 'package:gerena/features/subscription/presentation/page/menbresia/menbreria_movil.dart';
import 'package:gerena/movil/home/start_page.dart';
import 'package:gerena/features/home/dashboard/dashboard_page.dart';
import 'package:get/get.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: RoutesNames.welcomePage,
      page: () => SplashPage(),
    ),
    GetPage(name: RoutesNames.categoryById, page: () => GetMedicationsPage()),
    GetPage(
      name: RoutesNames.loginPage,
      page: () => LoginPage(),
    ),
    GetPage(name: RoutesNames.preguntasFrecuentes, page: () => PreguntasFrecuentes()),
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
    GetPage(
      name: RoutesNames.patientView,
      page: () => PatientViewPage(),
    ),
     GetPage(
      name: RoutesNames.postReactionsPage,
      page: () => PostReactionsPage(),
    ),
    GetPage(name: RoutesNames.postdetail, page: ()=>PostByIdPage()),
    GetPage(name: RoutesNames.productDetail, page: () => ProductDetailPage()),
    GetPage(name: RoutesNames.calendar, page: () => CalendarWidget()),
    GetPage(name: RoutesNames.paymentCardsScreen, page: () => PaymentCardsScreen()),
GetPage(
  name: RoutesNames.membresia,
  page: () => MembresiaPage(
    isRequired: Get.arguments?['isRequired'] ?? false,
  ),
),
    GetPage(
        name: RoutesNames.historia, page: () => HistorialDePedidosContent()),
    GetPage(name: RoutesNames.passwordreset, page: () => PasswordResetPage()),
    GetPage(
      name: RoutesNames.followersFollowing,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        final initialTab = args?['initialTab'] as int? ?? 0;

        return FollowersFollowingPage(initialTab: initialTab);
      },
    ),
    GetPage(
      name: RoutesNames.followersFollowingGeneric,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final userId = args['userId'] as int;
        final userName = args['userName'] as String;
        final initialTab = args['initialTab'] as int? ?? 0;

        return FollowersFollowingGenericPage(
          userId: userId,
          userName: userName,
          initialTab: initialTab,
        );
      },
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
