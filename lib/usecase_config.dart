import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gerena/features/appointment/data/datasources/appointment_data_sources_imp.dart';
import 'package:gerena/features/appointment/data/repositories/appointment_repository_imp.dart';
import 'package:gerena/features/appointment/domain/usecase/add_availability_usecase.dart';
import 'package:gerena/features/appointment/domain/usecase/appointment_completed_usecase.dart';
import 'package:gerena/features/appointment/domain/usecase/cancel_appointment_usecase.dart';
import 'package:gerena/features/appointment/domain/usecase/delete_availability_usecase.dart';
import 'package:gerena/features/appointment/domain/usecase/get_appointments_usecase.dart';
import 'package:gerena/features/appointment/domain/usecase/post_appointment_usecase.dart';
import 'package:gerena/features/auth/data/datasources/auth_data_sources_imp.dart';
import 'package:gerena/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:gerena/features/auth/domain/usecase/confirm_password_reset_usecase.dart';
import 'package:gerena/features/auth/domain/usecase/login_usecase.dart';
import 'package:gerena/features/auth/domain/usecase/request_password_code_usecase.dart';
import 'package:gerena/features/notification/domain/usecase/save_token_fcm_usecase.dart';
import 'package:gerena/features/banners/data/datasources/banners_data_sources_imp.dart';
import 'package:gerena/features/banners/data/repositories/banners_repository_imp.dart';
import 'package:gerena/features/banners/domain/usecase/get_banners_usecase.dart';
import 'package:gerena/features/blog/data/datasources/blog_data_sources_imp.dart';
import 'package:gerena/features/blog/data/repositories/blog_repository_imp.dart';
import 'package:gerena/features/blog/domain/usecase/create_blog_social_usecase.dart';
import 'package:gerena/features/blog/domain/usecase/get_blog_gerena_by_id_usecase.dart';
import 'package:gerena/features/blog/domain/usecase/get_blog_gerena_usecase.dart';
import 'package:gerena/features/blog/domain/usecase/get_blog_social_by_id_usecase.dart';
import 'package:gerena/features/blog/domain/usecase/get_blog_social_usecase.dart';
import 'package:gerena/features/blog/domain/usecase/post_answer_blog_usecase.dart';
import 'package:gerena/features/doctorprocedures/data/datasources/procedures_data_sources_imp.dart';
import 'package:gerena/features/doctorprocedures/data/repositories/procedure_repository_imp.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/add_imagenes_usecase.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/create_procedure_usecase.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/delete_img_usecase.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/delete_procedure_usecase.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/get_procedures_by_doctor_usecase.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/get_procedures_usecase.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/update_procedure_usecase.dart';
import 'package:gerena/features/doctors/data/datasources/doctos_data_sources_imp.dart';
import 'package:gerena/features/doctors/data/repositories/doctor_repository_imp.dart';
import 'package:gerena/features/doctors/domain/usecase/doctor_profile_usecase.dart';
import 'package:gerena/features/doctors/domain/usecase/fetch_doctor_by_id_usecase.dart';
import 'package:gerena/features/doctors/domain/usecase/get_doctor_availability_usecase.dart';
import 'package:gerena/features/doctors/domain/usecase/update_doctor_profile_usecase.dart';
import 'package:gerena/features/doctors/domain/usecase/updatefoto_doctor_profile_usecase.dart';
import 'package:gerena/features/followers/data/datasources/follower_data_sources_imp.dart';
import 'package:gerena/features/followers/data/repositories/follower_repository_imp.dart';
import 'package:gerena/features/followers/domain/usecase/follow_user_usecase.dart';
import 'package:gerena/features/followers/domain/usecase/get_follow_status_usecase.dart';
import 'package:gerena/features/followers/domain/usecase/get_follows_usecase.dart';
import 'package:gerena/features/followers/domain/usecase/unfollow_user_usecase.dart';
import 'package:gerena/features/marketplace/data/datasources/addresses_data_sources_imp.dart';
import 'package:gerena/features/marketplace/data/datasources/marketplace_data_sources_imp.dart';
import 'package:gerena/features/marketplace/data/datasources/payment_data_sources_imp.dart';
import 'package:gerena/features/marketplace/data/repositories/addresses_repository_imp.dart';
import 'package:gerena/features/marketplace/data/repositories/marketplace_repository_imp.dart';
import 'package:gerena/features/marketplace/data/repositories/payment_repository_imp.dart';
import 'package:gerena/features/marketplace/domain/usecase/addresses/delete_addresses_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/addresses/get_addresses_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/addresses/post_addresses_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/addresses/put_addresses_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/calculate_discount_points_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/create_order_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_category_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_medicine_by_id_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_medicines_on_sale_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_my_last_paid_order_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_my_order_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_order_by_id_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/pay_order_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/attach_payment_method_to_customer_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/delete_payment_method_back_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/payment_methods_defaul_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/create_payment_method_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/delete_payment_method_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/get_payment_methods_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/savecard_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/searching_for_medications_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/shopping_cart_usecase.dart';
import 'package:gerena/features/notification/data/datasources/notification_data_sources_imp.dart';
import 'package:gerena/features/notification/data/repositories/notification_repository_imp.dart';
import 'package:gerena/features/notification/domain/usecase/get_notification_usecase.dart';
import 'package:gerena/features/publications/data/datasources/publication_date_sources_imp.dart';
import 'package:gerena/features/publications/data/repositories/publication_repository_imp.dart';
import 'package:gerena/features/publications/domain/usecase/add_comment_usecase.dart';
import 'package:gerena/features/publications/domain/usecase/create_publication_usecase.dart';
import 'package:gerena/features/publications/domain/usecase/delete_comment_usecase.dart';
import 'package:gerena/features/publications/domain/usecase/delete_publication_usecase.dart';
import 'package:gerena/features/publications/domain/usecase/get_feed_posts_usecase.dart';
import 'package:gerena/features/publications/domain/usecase/get_my_posts_usecase.dart';
import 'package:gerena/features/publications/domain/usecase/get_post_comments_usecase.dart';
import 'package:gerena/features/publications/domain/usecase/get_post_doctor_usecase.dart';
import 'package:gerena/features/publications/domain/usecase/get_posts_user_usecase.dart';
import 'package:gerena/features/publications/domain/usecase/like_publication_usecase.dart';
import 'package:gerena/features/publications/domain/usecase/update_publication_usecase.dart';
import 'package:gerena/features/review/data/datasources/review_data_sources_imp.dart';
import 'package:gerena/features/review/data/repositories/review_repository_imp.dart';
import 'package:gerena/features/review/domain/usecase/my_review_usecase.dart';
import 'package:gerena/features/stories/data/datasources/stories_data_sources_imp.dart';
import 'package:gerena/features/stories/data/repository/stories_repository_imp.dart';
import 'package:gerena/features/stories/domain/usecase/add_like_to_story_usecase.dart';
import 'package:gerena/features/stories/domain/usecase/create_strory_usecase.dart';
import 'package:gerena/features/stories/domain/usecase/fetch_stories_by_id_usecase.dart';
import 'package:gerena/features/stories/domain/usecase/fetch_stories_usecase.dart';
import 'package:gerena/features/stories/domain/usecase/remove_story_usecase.dart';
import 'package:gerena/features/stories/domain/usecase/set_story_as_seen_usecase.dart';
import 'package:gerena/features/subscription/data/datasources/subscription_data_sources_imp.dart';
import 'package:gerena/features/subscription/data/repositories/subscription_repository_imp.dart';
import 'package:gerena/features/subscription/domain/usecase/change_subscription_plan_usecase.dart';
import 'package:gerena/features/subscription/domain/usecase/get_all_plans_usecase.dart';
import 'package:gerena/features/subscription/domain/usecase/get_my_subscription_usecase.dart';
import 'package:gerena/features/subscription/domain/usecase/post_cancel_subcription_usecase.dart';
import 'package:gerena/features/subscription/domain/usecase/post_reactivate_subscription_usecase.dart';
import 'package:gerena/features/subscription/domain/usecase/post_subscribe_to_plan_usecase.dart';
import 'package:gerena/features/user/data/datasources/user_datasource_imp.dart';
import 'package:gerena/features/user/data/repositories/user_repository_imp.dart';
import 'package:gerena/features/user/domain/usecase/get_user_details_by_id_usecase.dart';
import 'package:gerena/features/user/domain/usecase/search_profile_usecase.dart';

class UsecaseConfig {
   AuthRepositoryImp? authRepositoryImp;
   MarketplaceRepositoryImp? marketplaceRepositoryImp;
   PaymentRepositoryImpl? paymentRepositoryImp;
   BannersRepositoryImp? bannersRepositoryImp;
   AddressesRepositoryImp? addressesRepositoryImp;
   SubscriptionRepositoryImp? subscriptionRepositoryImp;
   ProcedureRepositoryImp? procedureRepositoryImp;
   ReviewRepositoryImp? reviewRepositoryImp;
   NotificationRepositoryImp? notificationRepositoryImp;
   BlogRepositoryImp? blogRepositoryImp;
   StoriesRepositoryImp? storiesRepositoryImp;
  PublicationRepositoryImp? publicationRepositoryImp;
  FollowerRepositoryImp? followerRepositoryImp;
  UserRepositoryImp?userRepositoryImp;



  UserDatasourceImp?userDatasourceImp;
   AuthDataSourcesImp? authDataSources;
   MarketplaceDataSourcesImp?marketplaceDataSourcesImp;
   PaymentDataSourcesImp? paymentDataSourcesImp;
   BannersDataSourcesImp? bannersDataSourcesImp;
   AddressesDataSourcesImp? addressesDataSourcesImp;
   SubscriptionDataSourcesImp? subscriptionDataSourcesImp;
   ProceduresDataSourcesImp? proceduresDataSourcesImp;
   ReviewDataSourcesImp? reviewDataSourcesImp;
   NotificationDataSourcesImp? notificationDataSourcesImp;
   BlogDataSourcesImp? blogDataSourcesImp;
   StoriesDataSourcesImp? storiesDataSourcesImp;
     PublicationDateSourcesImp? publicationDateSourcesImp;
  FollowerDataSourcesImp? followerDataSourcesImp;



   LoginUsecase? loginUsecase;
   SaveTokenFcmUsecase? saveTokenFcmUsecase;
   RequestPasswordCodeUsecase?requestPasswordCodeUsecase;
   ConfirmPasswordResetUsecase?confirmPasswordResetUsecase;

   DoctorRepositoryImp? doctorRepositoryImp;
   DoctosDataSourcesImp? doctosDataSources;
   DoctorProfileUsecase? doctorProfileUsecase;
   GetDoctorAvailabilityUsecase? getDoctorAvailabilityUsecase;
   UpdateDoctorProfileUsecase? updateDoctorProfileUsecase;
   UpdatefotoDoctorProfileUsecase? updatefotoDoctorProfileUsecase;

   AppointmentRepositoryImp? appointmentRepositoryImp;
   AppointmentDataSourcesImp? appointmentDataSourcesImp;
   GetAppointmentsUsecase? getAppointmentsUsecase;
   CancelAppointmentUsecase?cancelAppointmentUsecase;
   AppointmentCompletedUsecase? appointmentCompletedUsecase;
   DeleteAvailabilityUsecase? deleteAvailabilityUsecase;
   AddAvailabilityUsecase? addAvailabilityUsecase;


   GetMyOrderUsecase? getMyOrderUsecase;
   GetOrderByIdUsecase?getOrderByIdUsecase;
   GetMyLastPaidOrderUsecase? getMyLastPaidOrderUsecase;
   GetMedicineByIdUsecase?getMedicineByIdUsecase;
   SearchingForMedicationsUsecase? searchingForMedicationsUsecase;
   GetCategoryUsecase? getCategoryUsecase;
   GetMedicinesOnSaleUsecase? getMedicinesOnSaleUsecase;
   ShoppingCartUsecase? shoppingCartUsecase;
   PostAppointmentUsecase? postAppointmentUsecase;
   CreateOrderUsecase? createOrderUsecase;
   PayOrderUsecase? payOrderUsecase;
   CalculateDiscountPointsUsecase? calculateDiscountPointsUsecase;

   GetAddressesUsecase ? getAddressesUsecase;
   PostAddressesUsecase? postAddressesUsecase;
   PutAddressesUsecase? putAddressesUsecase;
   DeleteAddressesUsecase? deleteAddressesUsecase;


   AttachPaymentMethodToCustomerUsecase? attachPaymentMethodToCustomerUsecase;
   CreatePaymentMethodUsecase? createPaymentMethodUsecase;
   DeletePaymentMethodUsecase? deletePaymentMethodUsecase;
   GetPaymentMethodsUsecase? getPaymentMethodsUsecase;
   PaymentMethodsDefaulUsecase? paymentMethodsDefaulUsecase;
   SavecardUsecase? savecardUsecase;
   DeletePaymentMethodBackUsecase? deletePaymentMethodBackUsecase;

   GetBannersUsecase? getBannersUsecase;


   ChangeSubscriptionPlanUsecase? changeSubscriptionPlanUsecase;
   PostCancelSubcriptionUsecase? postCancelSubcriptionUsecase;
   PostReactivateSubscriptionUsecase? postReactivateSubscriptionUsecase;
   PostSubscribeToPlanUsecase? postSubscribeToPlanUsecase;
   GetAllPlansUsecase? getAllPlansUsecase;
   GetMySubscriptionUsecase? getMySubscriptionUsecase;


   AddImagenesUsecase? addImagenesUsecase;
   CreateProcedureUsecase? createProcedureUsecase;
   GetProceduresUsecase? getProceduresUsecase;
   GetProceduresByDoctorUsecase? getProceduresByDoctorUsecase;
   UpdateProcedureUsecase? updateProcedureUsecase;
   DeleteImgUsecase? deleteImgUsecase;
   DeleteProcedureUsecase? deleteProcedureUsecase;
   GetPostDoctorUsecase? getPostDoctorUsecase;
   GetPostsUserUsecase? getPostsUserUsecase;
   FetchDoctorByIdUsecase? fetchDoctorByIdUsecase;


   MyReviewUsecase?myReviewUsecase;

   GetNotificationUsecase? getnotificationUsecase;

   GetBlogGerenaUsecase? getBlogGerenaUsecase;
   GetBlogGerenaByIdUsecase? getBlogGerenaByIdUsecase;
   GetBlogSocialUsecase?getBlogSocialUsecase;
   GetBlogSocialByIdUsecase?getBlogSocialByIdUsecase;
   CreateBlogSocialUsecase?createBlogSocialUsecase;
   PostAnswerBlogUsecase?postAnswerBlogUsecase;


  GetPostCommentsUsecase? getPostCommentsUsecase;
  AddCommentUsecase ? addCommentUsecase;
  DeleteCommentUsecase?deleteCommentUsecase;

  CreatePublicationUsecase? createPublicationUsecase;
  DeletePublicationUsecase? deletePublicationUsecase;
  GetFeedPostsUsecase? getFeedPostsUsecase;
  GetMyPostsUsecase? getMyPostsUsecase;
  LikePublicationUsecase? likePublicationUsecase;
  UpdatePublicationUsecase? updatePublicationUsecase;

   AddLikeToStoryUsecase? addLikeToStoryUsecase;
   CreateStroryUsecase? createStroryUsecase;
   FetchStoriesByIdUsecase? fetchStoriesByIdUsecase;
   FetchStoriesUsecase? fetchStoriesUsecase;
   RemoveStoryUsecase? removeStoryUsecase;
   SetStoryAsSeenUsecase? setStoryAsSeenUsecase;
   


   FollowUserUsecase? followUserUsecase;
   UnfollowUserUsecase? unfollowUserUsecase;
   GetFollowStatusUsecase? getFollowStatusUsecase;
   GetFollowsUsecase? getFollowsUsecase;

   GetUserDetailsByIdUsecase? getUserDetailsByIdUsecase;
   SearchProfileUsecase? searchProfileUsecase;

  UsecaseConfig(){
     authDataSources = AuthDataSourcesImp();
     doctosDataSources = DoctosDataSourcesImp();
      appointmentDataSourcesImp = AppointmentDataSourcesImp();
      marketplaceDataSourcesImp = MarketplaceDataSourcesImp();
      paymentDataSourcesImp = PaymentDataSourcesImp();
      bannersDataSourcesImp = BannersDataSourcesImp();
      addressesDataSourcesImp = AddressesDataSourcesImp();
      subscriptionDataSourcesImp = SubscriptionDataSourcesImp();
      proceduresDataSourcesImp = ProceduresDataSourcesImp();
      reviewDataSourcesImp = ReviewDataSourcesImp();
      notificationDataSourcesImp = NotificationDataSourcesImp();
      blogDataSourcesImp = BlogDataSourcesImp();
      storiesDataSourcesImp = StoriesDataSourcesImp();
      publicationDateSourcesImp = PublicationDateSourcesImp();
      followerDataSourcesImp = FollowerDataSourcesImp();
           userDatasourceImp = UserDatasourceImp();


      
     userRepositoryImp = UserRepositoryImp(userDataSource:  userDatasourceImp!);
     doctorRepositoryImp = DoctorRepositoryImp(doctosDataSources: doctosDataSources!);
     authRepositoryImp = AuthRepositoryImp(authDataSources: authDataSources!);
      appointmentRepositoryImp = AppointmentRepositoryImp(appointmentDataSources: appointmentDataSourcesImp!);
      marketplaceRepositoryImp = MarketplaceRepositoryImp(marketplaceDataSourcesImp: marketplaceDataSourcesImp!);
      paymentRepositoryImp = PaymentRepositoryImpl( paymentDataSourcesImp: paymentDataSourcesImp!, );
      bannersRepositoryImp = BannersRepositoryImp(bannersDataSourcesImp: bannersDataSourcesImp!);
      addressesRepositoryImp = AddressesRepositoryImp(addressesDataSourcesImp: addressesDataSourcesImp!);
      subscriptionRepositoryImp = SubscriptionRepositoryImp(subscriptionDataSourcesImp: subscriptionDataSourcesImp!);
      procedureRepositoryImp = ProcedureRepositoryImp(proceduresDataSourcesImp: proceduresDataSourcesImp!);
      reviewRepositoryImp = ReviewRepositoryImp(reviewDataSourcesImp: reviewDataSourcesImp!);
      notificationRepositoryImp =NotificationRepositoryImp(notificationDataSourcesImp: notificationDataSourcesImp!);
      blogRepositoryImp = BlogRepositoryImp(blogDataSourcesImp: blogDataSourcesImp!);
      storiesRepositoryImp = StoriesRepositoryImp(storiesDataSourcesImp: storiesDataSourcesImp!);
      publicationRepositoryImp = PublicationRepositoryImp(publicationDateSourcesImp: publicationDateSourcesImp!);
      followerRepositoryImp = FollowerRepositoryImp(followerDataSourcesImp: followerDataSourcesImp!);
      getPostsUserUsecase = GetPostsUserUsecase(publicationRepository: publicationRepositoryImp!);

     loginUsecase = LoginUsecase(authRepository: authRepositoryImp!);
     saveTokenFcmUsecase = SaveTokenFcmUsecase(notificationRepository: notificationRepositoryImp!);
     requestPasswordCodeUsecase =RequestPasswordCodeUsecase(authRepository: authRepositoryImp!);
     confirmPasswordResetUsecase = ConfirmPasswordResetUsecase(authRepository: authRepositoryImp!);
     doctorProfileUsecase = DoctorProfileUsecase(doctorRepository: doctorRepositoryImp!);

     getAppointmentsUsecase = GetAppointmentsUsecase(appointmentRepository: appointmentRepositoryImp!);
     deleteAvailabilityUsecase = DeleteAvailabilityUsecase(appointmentRepository: appointmentRepositoryImp!);
     addAvailabilityUsecase = AddAvailabilityUsecase(appointmentRepository: appointmentRepositoryImp!);
     getDoctorAvailabilityUsecase = GetDoctorAvailabilityUsecase(doctorRepository: doctorRepositoryImp!);
     postAppointmentUsecase = PostAppointmentUsecase(appointmentRepository: appointmentRepositoryImp!);
     appointmentCompletedUsecase = AppointmentCompletedUsecase(appointmentRepository: appointmentRepositoryImp!);
     cancelAppointmentUsecase = CancelAppointmentUsecase(appointmentRepository: appointmentRepositoryImp!);
     updateDoctorProfileUsecase = UpdateDoctorProfileUsecase(doctorRepository: doctorRepositoryImp!);
     updatefotoDoctorProfileUsecase = UpdatefotoDoctorProfileUsecase(doctorRepository: doctorRepositoryImp!);
     getPostDoctorUsecase= GetPostDoctorUsecase(publicationRepository: publicationRepositoryImp!);
     fetchDoctorByIdUsecase = FetchDoctorByIdUsecase(doctorRepository: doctorRepositoryImp!);
     

     getMedicineByIdUsecase = GetMedicineByIdUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     getMyOrderUsecase = GetMyOrderUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     getMyLastPaidOrderUsecase = GetMyLastPaidOrderUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     getMedicineByIdUsecase=GetMedicineByIdUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     searchingForMedicationsUsecase = SearchingForMedicationsUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     getCategoryUsecase = GetCategoryUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     getOrderByIdUsecase = GetOrderByIdUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     getMedicinesOnSaleUsecase = GetMedicinesOnSaleUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     shoppingCartUsecase = ShoppingCartUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     createOrderUsecase = CreateOrderUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     payOrderUsecase = PayOrderUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     
     calculateDiscountPointsUsecase =CalculateDiscountPointsUsecase(marketplaceRepository: marketplaceRepositoryImp!);


     getAddressesUsecase = GetAddressesUsecase(addressesRepository: addressesRepositoryImp!);
     postAddressesUsecase = PostAddressesUsecase(addressesRepository: addressesRepositoryImp!);
     putAddressesUsecase = PutAddressesUsecase(addressesRepository: addressesRepositoryImp!);
     deleteAddressesUsecase = DeleteAddressesUsecase(addressesRepository: addressesRepositoryImp!);
     


      attachPaymentMethodToCustomerUsecase = AttachPaymentMethodToCustomerUsecase(repository: paymentRepositoryImp!);
      createPaymentMethodUsecase = CreatePaymentMethodUsecase(repository: paymentRepositoryImp!);
      deletePaymentMethodUsecase = DeletePaymentMethodUsecase(repository: paymentRepositoryImp!);
      getPaymentMethodsUsecase = GetPaymentMethodsUsecase(repository: paymentRepositoryImp!);
      paymentMethodsDefaulUsecase = PaymentMethodsDefaulUsecase(repository: paymentRepositoryImp!);

     deletePaymentMethodBackUsecase = DeletePaymentMethodBackUsecase(repository: paymentRepositoryImp!);
      savecardUsecase = SavecardUsecase(paymentRepository: paymentRepositoryImp!);
      
      getBannersUsecase = GetBannersUsecase(repository: bannersRepositoryImp!);

      changeSubscriptionPlanUsecase = ChangeSubscriptionPlanUsecase(subscriptionRepository: subscriptionRepositoryImp!);
      postCancelSubcriptionUsecase = PostCancelSubcriptionUsecase(subscriptionRepository: subscriptionRepositoryImp!);
      postReactivateSubscriptionUsecase = PostReactivateSubscriptionUsecase(subscriptionRepository: subscriptionRepositoryImp!);
      postSubscribeToPlanUsecase = PostSubscribeToPlanUsecase(subscriptionRepository: subscriptionRepositoryImp!);
      getAllPlansUsecase = GetAllPlansUsecase(subscriptionRepository: subscriptionRepositoryImp!);
      getMySubscriptionUsecase = GetMySubscriptionUsecase(subscriptionRepository: subscriptionRepositoryImp!);



      addImagenesUsecase = AddImagenesUsecase(proceduresRepository: procedureRepositoryImp!);
      createProcedureUsecase = CreateProcedureUsecase(proceduresRepository: procedureRepositoryImp!);
      getProceduresUsecase = GetProceduresUsecase(proceduresRepository: procedureRepositoryImp!);
      getProceduresByDoctorUsecase = GetProceduresByDoctorUsecase(proceduresRepository: procedureRepositoryImp!);
      updateProcedureUsecase = UpdateProcedureUsecase(proceduresRepository: procedureRepositoryImp!);
      deleteImgUsecase = DeleteImgUsecase(proceduresRepository: procedureRepositoryImp!);        
      deleteProcedureUsecase = DeleteProcedureUsecase(proceduresRepository: procedureRepositoryImp!) ;


      myReviewUsecase = MyReviewUsecase(reviewRepository: reviewRepositoryImp!);

      getnotificationUsecase = GetNotificationUsecase(notificationRepository: notificationRepositoryImp!);



      
      getBlogGerenaUsecase = GetBlogGerenaUsecase(blogRepository: blogRepositoryImp!);
      getBlogGerenaByIdUsecase = GetBlogGerenaByIdUsecase(blogRepository: blogRepositoryImp!);
      getBlogSocialUsecase = GetBlogSocialUsecase(blogRepository: blogRepositoryImp!);
      getBlogSocialByIdUsecase = GetBlogSocialByIdUsecase(blogRepository: blogRepositoryImp!);
      createBlogSocialUsecase = CreateBlogSocialUsecase(blogRepository: blogRepositoryImp!);
      postAnswerBlogUsecase = PostAnswerBlogUsecase(blogRepository: blogRepositoryImp!);


      createPublicationUsecase = CreatePublicationUsecase(publicationRepository: publicationRepositoryImp!);
      deletePublicationUsecase = DeletePublicationUsecase(publicationRepository: publicationRepositoryImp!);
      getFeedPostsUsecase = GetFeedPostsUsecase(publicationRepository: publicationRepositoryImp!);
      getMyPostsUsecase = GetMyPostsUsecase(publicationRepository: publicationRepositoryImp!);
      likePublicationUsecase = LikePublicationUsecase(publicationRepository: publicationRepositoryImp!);
      updatePublicationUsecase = UpdatePublicationUsecase(publicationRepository: publicationRepositoryImp!);

      addCommentUsecase =AddCommentUsecase(publicationRepository: publicationRepositoryImp!);
      deleteCommentUsecase = DeleteCommentUsecase(publicationRepository: publicationRepositoryImp!);
      getPostCommentsUsecase = GetPostCommentsUsecase(publicationRepository: publicationRepositoryImp!);
      

      addLikeToStoryUsecase = AddLikeToStoryUsecase(storiesRepository: storiesRepositoryImp!);
      createStroryUsecase = CreateStroryUsecase(storiesRepository: storiesRepositoryImp!);
      fetchStoriesByIdUsecase = FetchStoriesByIdUsecase(storiesRepository: storiesRepositoryImp!);
      fetchStoriesUsecase = FetchStoriesUsecase(storiesRepository: storiesRepositoryImp!);
      removeStoryUsecase = RemoveStoryUsecase(storiesRepository: storiesRepositoryImp!);
      setStoryAsSeenUsecase = SetStoryAsSeenUsecase(storiesRepository: storiesRepositoryImp!);

 
      followUserUsecase = FollowUserUsecase(followerRepository: followerRepositoryImp!);
      unfollowUserUsecase = UnfollowUserUsecase(followerRepository: followerRepositoryImp!);
      getFollowStatusUsecase = GetFollowStatusUsecase(followerRepository: followerRepositoryImp!);
      getFollowsUsecase = GetFollowsUsecase(followerRepository: followerRepositoryImp!);


      getUserDetailsByIdUsecase = GetUserDetailsByIdUsecase(userRepository: userRepositoryImp!);
      searchProfileUsecase = SearchProfileUsecase(userRepository: userRepositoryImp!);
    
  }
}

