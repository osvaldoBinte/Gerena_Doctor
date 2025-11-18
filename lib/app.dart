
import 'package:flutter/material.dart';
import 'package:gerena/common/routes/router.dart';
import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/appointment/presentation/page/addappointment/add_appointment_controller.dart';
import 'package:gerena/features/auth/presentacion/page/Splash/splash_controller.dart';
import 'package:gerena/features/auth/presentacion/page/login/login_controller.dart';
import 'package:gerena/features/banners/presentation/controller/banner_controller.dart';
import 'package:gerena/features/doctorprocedures/presentation/page/procedures_controller.dart';
import 'package:gerena/features/doctors/presentacion/page/prefil_dortor_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/Category/category_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/addresses/addresses_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/get_medications_by_id_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/shopping/shopping_cart_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/get_medications_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/mobil/product_datail_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/paymentcard/payment_cart_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/wishlist/wishlist_controller.dart';
import 'package:gerena/features/review/presentation/page/review_controller.dart';
import 'package:gerena/features/subscription/presentation/page/subscription_controller.dart';
import 'package:gerena/movil/homePage/PostController/post_controller.dart';
import 'package:gerena/features/doctors/presentacion/page/editperfildoctor/movil/perfil_controller.dart';
import 'package:gerena/features/appointment/presentation/page/calendar/calendar_controller.dart';
import 'package:gerena/features/home/dashboard/dashboard_controller.dart';
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
        Get.put(usecaseConfig.postAppointmentUsecase!,permanent:  true);
        Get.put(usecaseConfig.getDoctorAvailabilityUsecase!,permanent:  true);
        Get.put(usecaseConfig.attachPaymentMethodToCustomerUsecase!,permanent:  true);
        Get.put(usecaseConfig.createPaymentMethodUsecase!,permanent:  true);
        Get.put(usecaseConfig.deletePaymentMethodUsecase!,permanent:  true);
        Get.put(usecaseConfig.getPaymentMethodsUsecase!,permanent:  true);
        Get.put(usecaseConfig.createPaymentMethodUsecase!,permanent:  true);
        Get.put(usecaseConfig.getBannersUsecase!, permanent: true);
        Get.put(usecaseConfig.paymentMethodsDefaulUsecase!, permanent: true);
        Get.put(usecaseConfig.payOrderUsecase!, permanent: true);
        Get.put(usecaseConfig.getAddressesUsecase!, permanent: true);
        Get.put(usecaseConfig.createOrderUsecase!, permanent: true);
        Get.put(usecaseConfig.changeSubscriptionPlanUsecase!, permanent: true);
        Get.put(usecaseConfig.postCancelSubcriptionUsecase!, permanent: true);
        Get.put(usecaseConfig.postReactivateSubscriptionUsecase!, permanent: true);
        Get.put(usecaseConfig.postSubscribeToPlanUsecase!, permanent: true);
        Get.put(usecaseConfig.getAllPlansUsecase!, permanent: true);
        Get.put(usecaseConfig.getMySubscriptionUsecase!, permanent: true);
        Get.put(usecaseConfig.savecardUsecase!, permanent: true);
        Get.put(usecaseConfig.updateDoctorProfileUsecase!, permanent: true);
        Get.put(usecaseConfig.updatefotoDoctorProfileUsecase!, permanent: true);
        Get.put(usecaseConfig.addImagenesUsecase!, permanent: true);
        Get.put(usecaseConfig.createProcedureUsecase!, permanent: true);
        Get.put(usecaseConfig.updateProcedureUsecase!, permanent: true);
        Get.put(usecaseConfig.getProceduresUsecase!, permanent: true);
        Get.put(usecaseConfig.deleteProcedureUsecase!, permanent: true);
        Get.put(usecaseConfig.deleteImgUsecase!, permanent: true);
        Get.put(usecaseConfig.myReviewUsecase!, permanent:  true);
        Get.put(usecaseConfig.postAddressesUsecase!, permanent: true);



        Get.lazyPut(() => LoginController(loginUsecase: Get.find()), fenix: true);
        Get.lazyPut(() => ReviewController(myReviewUsecase: Get.find()), fenix: true);
        Get.lazyPut(() => SplashController(doctorProfileUsecase: Get.find()), fenix: true);
        Get.lazyPut(() => PrefilDortorController(doctorProfileUsecase:  Get.find(), updateDoctorProfileUsecase:  Get.find(), updatefotoDoctorProfileUsecase:  Get.find(), ), fenix: true);
        Get.lazyPut(() => CalendarControllerGetx(getAppointmentsUsecase: Get.find()), fenix: true);
        Get.lazyPut(() => CategoryController(getCategoryUsecase: Get.find()), fenix:  true);
        Get.lazyPut(() => GetMedicationsController(searchingForMedicationsUsecase: Get.find(), getMedicinesOnSaleUsecase:  Get.find()), fenix:  true);
        Get.lazyPut(() => ProductDetailController(getMedicineByIdUsecase: Get.find(),), fenix:  true);
        Get.lazyPut(() =>ShoppingCartController(shoppingCartUsecase: Get.find(), createOrderUsecase:  Get.find(), payOrderUsecase:  Get.find(), ), fenix:  true,);
        Get.lazyPut(() => WishlistController(shoppingCartUsecase:  Get.find(),), fenix:  true,);
        Get.lazyPut(() => AddAppointmentController(postAppointmentUsecase:  Get.find(), getDoctorAvailabilityUsecase:  Get.find()), fenix:  true);
        Get.lazyPut(() => PaymentCartController( getPaymentMethodsUsecase: Get.find(),createPaymentMethodUsecase: Get.find(),attachPaymentMethodToCustomerUsecase: Get.find(), deletePaymentMethodUsecase: Get.find(), savecardUsecase: Get.find(),), fenix: true,);
        Get.lazyPut(() => AddressesController(getAddressesUsecase:  Get.find(), postAddressesUsecase: Get.find(),), fenix: true,);
        Get.lazyPut(() => BannerController(getBannersUsecase: Get.find()), fenix: true,);
        Get.lazyPut(() => SubscriptionController( getAllPlansUsecase: Get.find(), postSubscribeToPlanUsecase: Get.find(), getMySubscriptionUsecase: Get.find(), changeSubscriptionPlanUsecase: Get.find(), postCancelSubcriptionUsecase: Get.find(), ), fenix: true,);
        Get.lazyPut(() => GetMedicationsByIdController(  getMedicineByIdUsecase: Get.find(),), fenix: true,);
        Get.lazyPut(() => ProceduresController(getProceduresUsecase:  Get.find(), createProcedureUsecase:  Get.find(), updateProcedureUsecase: Get.find(), addImagenesUsecase: Get.find(), deleteProcedureUsecase: Get.find(), deleteImgUsecase: Get.find(),), fenix: true,);
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