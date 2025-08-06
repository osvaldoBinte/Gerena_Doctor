
import 'package:flutter/material.dart';
import 'package:gerena/common/routes/router.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/page/dashboard/calendar/calendar_controller.dart';
import 'package:gerena/page/dashboard/dashboard_controller.dart';
import 'package:gerena/page/store/blogGerena/blog_gerena.dart';
import 'package:gerena/page/store/cartPage/GlobalShopInterface.dart';
import 'package:gerena/page/store/cartPage/productDetail/product_detail_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // AGREGAR ESTA IMPORTACIÓN

//UsecaseConfig usecaseConfig = UsecaseConfig();

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
      Get.put(DashboardController());
       Get.put(ShopNavigationController());
       Get.put(ProductDetailController());
       Get.put(CalendarControllerGetx());
       
      }),

      getPages: AppPages.routes, 
      unknownRoute: AppPages.unknownRoute, 
    );
  }
} 