
import 'package:flutter/material.dart';
import 'package:gerena/common/routes/router.dart';
import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/auth/presentacion/page/Splash/splash_controller.dart';
import 'package:gerena/features/auth/presentacion/page/login/login_controller.dart';
import 'package:gerena/features/doctors/presentacion/page/editperfildoctor/prefil_dortor_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/Category/category_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/cartPage/shopping_cart_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/get_medications_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/mobil/product_datail_controller.dart';
import 'package:gerena/movil/homePage/PostController/post_controller.dart';
import 'package:gerena/movil/perfil/perfil_controller.dart';
import 'package:gerena/features/appointment/presentation/page/calendar/calendar_controller.dart';
import 'package:gerena/page/dashboard/dashboard_controller.dart';
import 'package:gerena/page/store/blogGerena/blog_gerena.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
import 'package:gerena/usecase_config.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

UsecaseConfig usecaseConfig = UsecaseConfig();

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: const Locale('es', 'ES'),
      supportedLocales: [
        const Locale('es', 'ES'),
      ], localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: GerenaColors.themeData, 
      initialBinding: BindingsBuilder(() {
        Get.put(AuthService(), permanent: true);
        Get.put(usecaseConfig.loginUsecase!, permanent: true);
        Get.put(usecaseConfig.doctorProfileUsecase!, permanent: true);
        Get.put(usecaseConfig.getAppointmentsUsecase!, permanent: true);      
        Get.put(usecaseConfig.getMedicineByIdUsecase!, permanent: true);
        Get.put(usecaseConfig.getMyOrderUsecase!, permanent:  true);
        Get.put(usecaseConfig.searchingForMedicationsUsecase!,permanent: true);
        Get.put(usecaseConfig.getOrderByIdUsecase!, permanent: true);
        Get.put(usecaseConfig.getCategoryUsecase!,permanent: true);
        Get.put(usecaseConfig.getMedicinesOnSaleUsecase!, permanent:  true);
        Get.put(usecaseConfig.shoppingCartUsecase!,permanent:  true);



        Get.lazyPut(() => LoginController(loginUsecase: Get.find()), fenix: true);
        Get.lazyPut(() => SplashController(doctorProfileUsecase: Get.find()), fenix: true);
        Get.lazyPut(() => PrefilDortorController(doctorProfileUsecase:  Get.find()), fenix: true);
        Get.lazyPut(() => CalendarControllerGetx(getAppointmentsUsecase: Get.find()), fenix: true);
        Get.lazyPut(() => CategoryController(getCategoryUsecase: Get.find()), fenix:  true);
        Get.lazyPut(() => GetMedicationsController(searchingForMedicationsUsecase: Get.find(), getMedicinesOnSaleUsecase:  Get.find()), fenix:  true);
        Get.lazyPut(() => ProductDetailController(getMedicineByIdUsecase: Get.find(),), fenix:  true);
        Get.lazyPut(() =>ShoppingCartController(shoppingCartUsecase: Get.find(),), fenix:  true,);
        Get.put(DashboardController());
        Get.put(ShopNavigationController());
        Get.put(PostController()); 
        Get.put(PerfilController());


      }),

      getPages: AppPages.routes, 
      unknownRoute: AppPages.unknownRoute, 
    );
  }
} 