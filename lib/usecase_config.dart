import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gerena/features/appointment/data/datasources/appointment_data_sources_imp.dart';
import 'package:gerena/features/appointment/data/repositories/appointment_repository_imp.dart';
import 'package:gerena/features/appointment/domain/usecase/get_appointments_usecase.dart';
import 'package:gerena/features/appointment/domain/usecase/post_appointment_usecase.dart';
import 'package:gerena/features/auth/data/datasources/auth_data_sources_imp.dart';
import 'package:gerena/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:gerena/features/auth/domain/usecase/login_usecase.dart';
import 'package:gerena/features/banners/data/datasources/banners_data_sources_imp.dart';
import 'package:gerena/features/banners/data/repositories/banners_repository_imp.dart';
import 'package:gerena/features/banners/domain/usecase/get_banners_usecase.dart';
import 'package:gerena/features/doctors/data/datasources/doctos_data_sources_imp.dart';
import 'package:gerena/features/doctors/data/repositories/doctor_repository_imp.dart';
import 'package:gerena/features/doctors/domain/usecase/doctor_profile_usecase.dart';
import 'package:gerena/features/doctors/domain/usecase/get_doctor_availability_usecase.dart';
import 'package:gerena/features/marketplace/data/datasources/Payment_data_sources_imp.dart';
import 'package:gerena/features/marketplace/data/datasources/addresses_data_sources_imp.dart';
import 'package:gerena/features/marketplace/data/datasources/marketplace_data_sources_imp.dart';
import 'package:gerena/features/marketplace/data/repositories/addresses_repository_imp.dart';
import 'package:gerena/features/marketplace/data/repositories/marketplace_repository_imp.dart';
import 'package:gerena/features/marketplace/data/repositories/payment_repository_imp.dart';
import 'package:gerena/features/marketplace/domain/usecase/addresses/get_addresses_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/create_order_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_category_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_medicine_by_id_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_medicines_on_sale_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_my_order_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_order_by_id_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/pay_order_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/attach_payment_method_to_customer_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/payment_methods_defaul_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/create_payment_method_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/delete_payment_method_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/get_payment_methods_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/savecard_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/searching_for_medications_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/shopping_cart_usecase.dart';
import 'package:gerena/features/subscription/data/datasources/subscription_data_sources_imp.dart';
import 'package:gerena/features/subscription/data/repositories/subscription_repository_imp.dart';
import 'package:gerena/features/subscription/domain/usecase/change_subscription_plan_usecase.dart';
import 'package:gerena/features/subscription/domain/usecase/get_all_plans_usecase.dart';
import 'package:gerena/features/subscription/domain/usecase/get_my_subscription_usecase.dart';
import 'package:gerena/features/subscription/domain/usecase/post_cancel_subcription_usecase.dart';
import 'package:gerena/features/subscription/domain/usecase/post_reactivate_subscription_usecase.dart';
import 'package:gerena/features/subscription/domain/usecase/post_subscribe_to_plan_usecase.dart';

class UsecaseConfig {
   AuthRepositoryImp? authRepositoryImp;
   MarketplaceRepositoryImp? marketplaceRepositoryImp;
   PaymentRepositoryImpl? paymentRepositoryImp;
   BannersRepositoryImp? bannersRepositoryImp;
   AddressesRepositoryImp? addressesRepositoryImp;
   SubscriptionRepositoryImp? subscriptionRepositoryImp;


   AuthDataSourcesImp? authDataSources;
   MarketplaceDataSourcesImp?marketplaceDataSourcesImp;
   PaymentDataSourcesImp? paymentDataSourcesImp;
   BannersDataSourcesImp? bannersDataSourcesImp;
   AddressesDataSourcesImp? addressesDataSourcesImp;
   SubscriptionDataSourcesImp? subscriptionDataSourcesImp;


   LoginUsecase? loginUsecase;

   DoctorRepositoryImp? doctorRepositoryImp;
   DoctosDataSourcesImp? doctosDataSources;
   DoctorProfileUsecase? doctorProfileUsecase;
   GetDoctorAvailabilityUsecase? getDoctorAvailabilityUsecase;

   AppointmentRepositoryImp? appointmentRepositoryImp;
   AppointmentDataSourcesImp? appointmentDataSourcesImp;
   GetAppointmentsUsecase? getAppointmentsUsecase;


   GetMyOrderUsecase? getMyOrderUsecase;
   GetOrderByIdUsecase?getOrderByIdUsecase;
   GetMedicineByIdUsecase?getMedicineByIdUsecase;
   SearchingForMedicationsUsecase? searchingForMedicationsUsecase;
   GetCategoryUsecase? getCategoryUsecase;
   GetMedicinesOnSaleUsecase? getMedicinesOnSaleUsecase;
   ShoppingCartUsecase? shoppingCartUsecase;
   PostAppointmentUsecase? postAppointmentUsecase;
   CreateOrderUsecase? createOrderUsecase;
   PayOrderUsecase? payOrderUsecase;

   GetAddressesUsecase ? getAddressesUsecase;


   AttachPaymentMethodToCustomerUsecase? attachPaymentMethodToCustomerUsecase;
   CreatePaymentMethodUsecase? createPaymentMethodUsecase;
   DeletePaymentMethodUsecase? deletePaymentMethodUsecase;
   GetPaymentMethodsUsecase? getPaymentMethodsUsecase;
   PaymentMethodsDefaulUsecase? paymentMethodsDefaulUsecase;
   SavecardUsecase? savecardUsecase;

   GetBannersUsecase? getBannersUsecase;


   ChangeSubscriptionPlanUsecase? changeSubscriptionPlanUsecase;
   PostCancelSubcriptionUsecase? postCancelSubcriptionUsecase;
   PostReactivateSubscriptionUsecase? postReactivateSubscriptionUsecase;
   PostSubscribeToPlanUsecase? postSubscribeToPlanUsecase;
   GetAllPlansUsecase? getAllPlansUsecase;
   GetMySubscriptionUsecase? getMySubscriptionUsecase;





  UsecaseConfig(){
     authDataSources = AuthDataSourcesImp();
     doctosDataSources = DoctosDataSourcesImp();
      appointmentDataSourcesImp = AppointmentDataSourcesImp();
      marketplaceDataSourcesImp = MarketplaceDataSourcesImp();
      paymentDataSourcesImp = PaymentDataSourcesImp();
      bannersDataSourcesImp = BannersDataSourcesImp();
      addressesDataSourcesImp = AddressesDataSourcesImp();
      subscriptionDataSourcesImp = SubscriptionDataSourcesImp();

     doctorRepositoryImp = DoctorRepositoryImp(doctosDataSources: doctosDataSources!);
     authRepositoryImp = AuthRepositoryImp(authDataSources: authDataSources!);
      appointmentRepositoryImp = AppointmentRepositoryImp(appointmentDataSources: appointmentDataSourcesImp!);
      marketplaceRepositoryImp = MarketplaceRepositoryImp(marketplaceDataSourcesImp: marketplaceDataSourcesImp!);
      paymentRepositoryImp = PaymentRepositoryImpl( paymentDataSourcesImp: paymentDataSourcesImp!, );
      bannersRepositoryImp = BannersRepositoryImp(bannersDataSourcesImp: bannersDataSourcesImp!);
      addressesRepositoryImp = AddressesRepositoryImp(addressesDataSourcesImp: addressesDataSourcesImp!);
      subscriptionRepositoryImp = SubscriptionRepositoryImp(subscriptionDataSourcesImp: subscriptionDataSourcesImp!);

     loginUsecase = LoginUsecase(authRepository: authRepositoryImp!);
     doctorProfileUsecase = DoctorProfileUsecase(doctorRepository: doctorRepositoryImp!);
     getAppointmentsUsecase = GetAppointmentsUsecase(appointmentRepository: appointmentRepositoryImp!);
     getDoctorAvailabilityUsecase = GetDoctorAvailabilityUsecase(doctorRepository: doctorRepositoryImp!);
     postAppointmentUsecase = PostAppointmentUsecase(appointmentRepository: appointmentRepositoryImp!);

     getMedicineByIdUsecase = GetMedicineByIdUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     getMyOrderUsecase = GetMyOrderUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     getMedicineByIdUsecase=GetMedicineByIdUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     searchingForMedicationsUsecase = SearchingForMedicationsUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     getCategoryUsecase = GetCategoryUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     getOrderByIdUsecase = GetOrderByIdUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     getMedicinesOnSaleUsecase = GetMedicinesOnSaleUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     shoppingCartUsecase = ShoppingCartUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     createOrderUsecase = CreateOrderUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     payOrderUsecase = PayOrderUsecase(marketplaceRepository: marketplaceRepositoryImp!);

     getAddressesUsecase = GetAddressesUsecase(addressesRepository: addressesRepositoryImp!);


      attachPaymentMethodToCustomerUsecase = AttachPaymentMethodToCustomerUsecase(repository: paymentRepositoryImp!);
      createPaymentMethodUsecase = CreatePaymentMethodUsecase(repository: paymentRepositoryImp!);
      deletePaymentMethodUsecase = DeletePaymentMethodUsecase(repository: paymentRepositoryImp!);
      getPaymentMethodsUsecase = GetPaymentMethodsUsecase(repository: paymentRepositoryImp!);
      paymentMethodsDefaulUsecase = PaymentMethodsDefaulUsecase(repository: paymentRepositoryImp!);
      savecardUsecase = SavecardUsecase(paymentRepository: paymentRepositoryImp!);
      
      getBannersUsecase = GetBannersUsecase(repository: bannersRepositoryImp!);

      changeSubscriptionPlanUsecase = ChangeSubscriptionPlanUsecase(subscriptionRepository: subscriptionRepositoryImp!);
      postCancelSubcriptionUsecase = PostCancelSubcriptionUsecase(subscriptionRepository: subscriptionRepositoryImp!);
      postReactivateSubscriptionUsecase = PostReactivateSubscriptionUsecase(subscriptionRepository: subscriptionRepositoryImp!);
      postSubscribeToPlanUsecase = PostSubscribeToPlanUsecase(subscriptionRepository: subscriptionRepositoryImp!);
      getAllPlansUsecase = GetAllPlansUsecase(subscriptionRepository: subscriptionRepositoryImp!);
      getMySubscriptionUsecase = GetMySubscriptionUsecase(subscriptionRepository: subscriptionRepositoryImp!);
      

    
  }
}

