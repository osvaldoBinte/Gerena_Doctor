
import 'package:flutter/material.dart';
import 'package:gerena/common/routes/router.dart';
import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/appointment/presentation/page/addappointment/add_appointment_controller.dart';
import 'package:gerena/features/appointment/presentation/page/addappointment/appointment_controller.dart';
import 'package:gerena/features/appointment/presentation/page/calendar/availability_controller.dart';
import 'package:gerena/features/auth/presentacion/page/Splash/splash_controller.dart';
import 'package:gerena/features/auth/presentacion/page/login/login_controller.dart';
import 'package:gerena/features/auth/presentacion/page/passwordreset/password_reset_controller.dart';
import 'package:gerena/features/banners/presentation/controller/banner_controller.dart';
import 'package:gerena/features/blog/presentation/page/blogGerena/blog_controller.dart';
import 'package:gerena/features/doctorprocedures/presentation/page/procedures_controller.dart';
import 'package:gerena/features/doctors/presentation/page/doctorProfilePage/doctor_profilebyid_controller.dart';
import 'package:gerena/features/doctors/presentation/page/editperfildoctor/movil/controller_perfil_configuration.dart';
import 'package:gerena/features/doctors/presentation/page/prefil_dortor_controller.dart';
import 'package:gerena/features/followers/presentation/controller/follower_controller.dart';
import 'package:gerena/features/followers/presentation/controller/follower_user_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/Category/category_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/addresses/addresses_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/getmylastpaidorder/get_my_last_paid_order_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/getmylastpaidorder/history/history_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/get_medications_by_id_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/shopping/shopping_cart_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/get_medications_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/mobil/product_datail_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/paymentcard/payment_cart_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/wishlist/wishlist_controller.dart';
import 'package:gerena/features/notification/presentation/page/notification_controller.dart';
import 'package:gerena/features/publications/presentation/page/comment/comment_controller.dart';
import 'package:gerena/features/publications/presentation/page/create/create_publication_controller.dart';
import 'package:gerena/features/publications/presentation/page/myposts/my_post_controller.dart';
import 'package:gerena/features/publications/presentation/page/post_controller.dart';
import 'package:gerena/features/publications/presentation/page/publication_controller.dart';
import 'package:gerena/features/review/presentation/page/review_controller.dart';
import 'package:gerena/features/stories/presentation/page/story_controller.dart';
import 'package:gerena/features/subscription/presentation/page/subscription_controller.dart';
import 'package:gerena/features/user/presentation/page/getusebyid/get_user_by_id_controller.dart';
import 'package:gerena/features/user/presentation/page/search/search_profile_controller.dart';
import 'package:gerena/movil/homePage/PostController/post_controller.dart';
import 'package:gerena/features/doctors/presentation/page/editperfildoctor/movil/perfil_controller.dart';
import 'package:gerena/features/appointment/presentation/page/calendar/calendar_controller.dart';
import 'package:gerena/features/home/dashboard/dashboard_controller.dart';
import 'package:gerena/features/blog/presentation/page/blogGerena/blog_gerena.dart';
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
        Get.put(usecaseConfig.saveTokenFcmUsecase!,permanent: true);
        Get.put(usecaseConfig.requestPasswordCodeUsecase!, permanent: true);
        Get.put(usecaseConfig.confirmPasswordResetUsecase!, permanent:  true);
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
        Get.put(usecaseConfig.cancelAppointmentUsecase!,permanent:  true);
        Get.put(usecaseConfig.appointmentCompletedUsecase!,permanent:  true);
        Get.put(usecaseConfig.getDoctorAvailabilityUsecase!,permanent:  true);
        Get.put(usecaseConfig.attachPaymentMethodToCustomerUsecase!,permanent:  true);
        Get.put(usecaseConfig.createPaymentMethodUsecase!,permanent:  true);
        Get.put(usecaseConfig.deletePaymentMethodUsecase!,permanent:  true);
        Get.put(usecaseConfig.getPaymentMethodsUsecase!,permanent:  true);
        Get.put(usecaseConfig.createPaymentMethodUsecase!,permanent:  true);
        Get.put(usecaseConfig.getBannersUsecase!, permanent: true);
        Get.put(usecaseConfig.paymentMethodsDefaulUsecase!, permanent: true);
        Get.put(usecaseConfig.deletePaymentMethodBackUsecase! ,permanent: true);
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
        Get.put(usecaseConfig.getnotificationUsecase!, permanent: true);
        Get.put(usecaseConfig.putAddressesUsecase!,permanent: true);
        Get.put(usecaseConfig.deleteAddressesUsecase!,permanent: true);
        Get.put(usecaseConfig.addAvailabilityUsecase!, permanent: true);
        Get.put(usecaseConfig.deleteAvailabilityUsecase!, permanent: true);
        Get.put(usecaseConfig.getMyLastPaidOrderUsecase!, permanent: true);
        Get.put(usecaseConfig.getBlogGerenaUsecase!, permanent:  true);
        Get.put(usecaseConfig.getBlogGerenaByIdUsecase!,permanent: true);
        Get.put(usecaseConfig.getBlogSocialUsecase!,permanent: true);
        Get.put(usecaseConfig.getBlogSocialByIdUsecase!,permanent: true);
        Get.put(usecaseConfig.createBlogSocialUsecase!,permanent: true);
        Get.put(usecaseConfig.postAnswerBlogUsecase!,permanent: true);
        Get.put(usecaseConfig.calculateDiscountPointsUsecase!, permanent: true);
        Get.put(usecaseConfig.addLikeToStoryUsecase!, permanent: true);
        Get.put(usecaseConfig.createStroryUsecase! ,permanent:  true);
        Get.put(usecaseConfig.fetchStoriesByIdUsecase!, permanent: true);
        Get.put(usecaseConfig.fetchStoriesUsecase! ,permanent:  true);
        Get.put(usecaseConfig.setStoryAsSeenUsecase!, permanent: true);
        Get.put(usecaseConfig.removeStoryUsecase!,permanent: true);
        Get.put(usecaseConfig.createPublicationUsecase!, permanent: true);
        Get.put(usecaseConfig.deletePublicationUsecase!, permanent: true);
        Get.put(usecaseConfig.getFeedPostsUsecase!, permanent: true);
        Get.put(usecaseConfig.getMyPostsUsecase!, permanent: true);
        Get.put(usecaseConfig.likePublicationUsecase!, permanent: true);
        Get.put(usecaseConfig.updatePublicationUsecase!, permanent: true);
        Get.put(usecaseConfig.followUserUsecase!, permanent: true);
        Get.put(usecaseConfig.unfollowUserUsecase!, permanent: true);
        Get.put(usecaseConfig.getFollowStatusUsecase!, permanent: true);
        Get.put(usecaseConfig.getFollowingByUserUsecase!, permanent: true);
        Get.put(usecaseConfig.getUserFollowersUsecase!, permanent: true);
        Get.put(usecaseConfig.getUserDetailsByIdUsecase!, permanent: true);
        Get.put(usecaseConfig.getPostsUserUsecase!, permanent: true);
        Get.put(usecaseConfig.fetchDoctorByIdUsecase!, permanent: true);
        Get.put(usecaseConfig.getPostDoctorUsecase!,permanent: true);
        Get.put(usecaseConfig.getProceduresByDoctorUsecase!,permanent: true);
        Get.put(usecaseConfig.searchProfileUsecase!,permanent: true);

        Get.put(usecaseConfig.addCommentUsecase!, permanent: true);
        Get.put(usecaseConfig.deleteCommentUsecase!,permanent: true);
        Get.put(usecaseConfig.getPostCommentsUsecase!,permanent: true);

        Get.lazyPut(() => LoginController(loginUsecase: Get.find(), saveTokenFcmUsecase: Get.find()), fenix: true);
        Get.lazyPut(() => HistoryController(getMyOrderUsecase: Get.find()), fenix: true);
        Get.lazyPut(() => GetMyLastPaidOrderController(getMyLastPaidOrderUsecase: Get.find()), fenix: true);
        Get.lazyPut(() => ReviewController(myReviewUsecase: Get.find()), fenix: true);
        Get.lazyPut(() => SplashController(doctorProfileUsecase: Get.find()), fenix: true);
        Get.lazyPut(() => PrefilDortorController(doctorProfileUsecase:  Get.find(), updateDoctorProfileUsecase:  Get.find(), updatefotoDoctorProfileUsecase:  Get.find(), ), fenix: true);
        Get.lazyPut(() => CalendarControllerGetx(getAppointmentsUsecase: Get.find()), fenix: true);
        Get.lazyPut(() => CategoryController(getCategoryUsecase: Get.find(), searchingForMedicationsUsecase:  Get.find()), fenix:  true);
        Get.lazyPut(() => GetMedicationsController(searchingForMedicationsUsecase: Get.find(), getMedicinesOnSaleUsecase:  Get.find()), fenix:  true);
        Get.lazyPut(() => ProductDetailController(getMedicineByIdUsecase: Get.find(),), fenix:  true);
        Get.lazyPut(() =>ShoppingCartController(shoppingCartUsecase: Get.find(), createOrderUsecase:  Get.find(), payOrderUsecase:  Get.find(), calculateDiscountPointsUsecase:  Get.find(),  ), fenix:  true,);
        Get.lazyPut(() => WishlistController(shoppingCartUsecase:  Get.find(),), fenix:  true,);
        Get.lazyPut(() => AddAppointmentController(postAppointmentUsecase:  Get.find(), getDoctorAvailabilityUsecase:  Get.find()), fenix:  true);
        Get.lazyPut(() => AppointmentController(appointmentCompletedUsecase: Get.find(), cancelAppointmentUsecase: Get.find()), fenix:  true);
        Get.lazyPut(() => PaymentCartController( getPaymentMethodsUsecase: Get.find(),createPaymentMethodUsecase: Get.find(),attachPaymentMethodToCustomerUsecase: Get.find(), deletePaymentMethodUsecase: Get.find(), savecardUsecase: Get.find(), deletePaymentMethodBackUsecase:  Get.find(),), fenix: true,);
        Get.lazyPut(() => AddressesController(getAddressesUsecase:  Get.find(), postAddressesUsecase: Get.find(), putAddressesUsecase: Get.find(), deleteAddressesUsecase: Get.find(),), fenix: true,);
        Get.lazyPut(() => BannerController(getBannersUsecase: Get.find()), fenix: true,);
        Get.lazyPut(() => SubscriptionController( getAllPlansUsecase: Get.find(), postSubscribeToPlanUsecase: Get.find(), getMySubscriptionUsecase: Get.find(), changeSubscriptionPlanUsecase: Get.find(), postCancelSubcriptionUsecase: Get.find(), ), fenix: true,);
        Get.lazyPut(() => GetMedicationsByIdController(  getMedicineByIdUsecase: Get.find(),), fenix: true,);
        Get.lazyPut(() => ProceduresController(getProceduresUsecase:  Get.find(), createProcedureUsecase:  Get.find(), updateProcedureUsecase: Get.find(), addImagenesUsecase: Get.find(), deleteProcedureUsecase: Get.find(), deleteImgUsecase: Get.find(),), fenix: true,);
        Get.lazyPut(() => NotificationController(getNotificationUsecase: Get.find()), fenix:  true);
        Get.lazyPut(() => AvailabilityController(addAvailabilityUsecase:  Get.find(), deleteAvailabilityUsecase:  Get.find(), getDoctorAvailabilityUsecase:  Get.find()), fenix:  true);
        Get.lazyPut(() => BlogController(getBlogGerenaUsecase: Get.find(), getBlogGerenaByIdUsecase: Get.find(), getBlogSocialUsecase: Get.find(), getBlogSocialByIdUsecase: Get.find(), createBlogSocialUsecase: Get.find(), postAnswerBlogUsecase: Get.find()), fenix: true,);
        Get.lazyPut(() => StoryController(fetchStoriesUsecase:  Get.find(), addLikeToStoryUsecase:  Get.find(), fetchStoriesByIdUsecase: Get.find(), removeStoryUsecase: Get.find(), createStroryUsecase: Get.find(), setStoryAsSeenUsecase:  Get.find()), fenix:  true);
        Get.lazyPut(() =>CreatePublicationController(createPublicationUsecase: Get.find(),), fenix: true);
        Get.lazyPut(() => PublicationController(getFeedPostsUsecase:Get.find(), likePublicationUsecase: Get.find()) , fenix:  true);
        Get.lazyPut(() => MyPostController(getMyPostsUsecase: Get.find(), likePublicationUsecase:  Get.find(), deletePublicationUsecase: Get.find(),), fenix: true);
        Get.lazyPut(() => FollowerController(getFollowStatusUsecase: Get.find(), getUserFollowersUsecase:  Get.find(), getFollowingByUserUsecase:  Get.find()), fenix: true);
        Get.lazyPut(() => FollowerUserController(followUserUsecase:  Get.find(), unfollowUserUsecase:  Get.find(), getFollowStatusUsecase:  Get.find(), getUserFollowersUsecase:  Get.find(), getFollowingByUserUsecase:  Get.find()), fenix: true);
        Get.lazyPut(() =>GetUserByIdController(getUserDetailsByIdUsecase: Get.find(), getPostsUserUsecase: Get.find()),fenix: true);
        Get.lazyPut(() =>SearchProfileController(searchProfileUsecase:  Get.find()),fenix: true);
        Get.lazyPut(() => DoctorProfilebyidController(getProceduresByDoctorUsecase: Get.find(), getPostDoctorUsecase: Get.find(), fetchDoctorByIdUsecase: Get.find(), getPostsUserUsecase: Get.find()),fenix: true);
        Get.lazyPut(() => CommentController( getPostCommentsUsecase: Get.find(),  addCommentUsecase: Get.find(), deleteCommentUsecase: Get.find(),),fenix: true);
        Get.lazyPut(() => PasswordResetController(confirmPasswordResetUsecase: Get.find(), requestPasswordCodeUsecase: Get.find()),fenix: true);
        Get.put(DashboardController());
        Get.put(ShopNavigationController());
        Get.put(PostController()); 
        Get.put(PerfilController());
        Get.put(ControllerPerfilConfiguration());


      }),

      getPages: AppPages.routes, 
      unknownRoute: AppPages.unknownRoute, 
    );
  }
} 