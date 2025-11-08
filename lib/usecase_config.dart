import 'package:flutter/widgets.dart';
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
import 'package:gerena/features/marketplace/data/datasources/marketplace_data_sources_imp.dart';
import 'package:gerena/features/marketplace/data/repositories/marketplace_repository_imp.dart';
import 'package:gerena/features/marketplace/data/repositories/payment_repository_imp.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_category_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_medicine_by_id_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_medicines_on_sale_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_my_order_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_order_by_id_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/attach_payment_method_to_customer_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/create_payment_method_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/delete_payment_method_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/get_payment_methods_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/searching_for_medications_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/shopping_cart_usecase.dart';

class UsecaseConfig {
   AuthRepositoryImp? authRepositoryImp;
   MarketplaceRepositoryImp? marketplaceRepositoryImp;
   PaymentRepositoryImpl? paymentRepositoryImp;
   BannersRepositoryImp? bannersRepositoryImp;


   AuthDataSourcesImp? authDataSources;
   MarketplaceDataSourcesImp?marketplaceDataSourcesImp;
   PaymentDataSourcesImp? paymentDataSourcesImp;
   BannersDataSourcesImp? bannersDataSourcesImp;


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


   AttachPaymentMethodToCustomerUsecase? attachPaymentMethodToCustomerUsecase;
   CreatePaymentMethodUsecase? createPaymentMethodUsecase;
   DeletePaymentMethodUsecase? deletePaymentMethodUsecase;
   GetPaymentMethodsUsecase? getPaymentMethodsUsecase;

   GetBannersUsecase? getBannersUsecase;




  UsecaseConfig(){
     authDataSources = AuthDataSourcesImp();
     doctosDataSources = DoctosDataSourcesImp();
      appointmentDataSourcesImp = AppointmentDataSourcesImp();
      marketplaceDataSourcesImp = MarketplaceDataSourcesImp();
      paymentDataSourcesImp = PaymentDataSourcesImp();
      bannersDataSourcesImp = BannersDataSourcesImp();

     doctorRepositoryImp = DoctorRepositoryImp(doctosDataSources: doctosDataSources!);
     authRepositoryImp = AuthRepositoryImp(authDataSources: authDataSources!);
      appointmentRepositoryImp = AppointmentRepositoryImp(appointmentDataSources: appointmentDataSourcesImp!);
      marketplaceRepositoryImp = MarketplaceRepositoryImp(marketplaceDataSourcesImp: marketplaceDataSourcesImp!);
      paymentRepositoryImp = PaymentRepositoryImpl( paymentDataSourcesImp: paymentDataSourcesImp!, );
      bannersRepositoryImp = BannersRepositoryImp(bannersDataSourcesImp: bannersDataSourcesImp!);

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


      attachPaymentMethodToCustomerUsecase = AttachPaymentMethodToCustomerUsecase(repository: paymentRepositoryImp!);
      createPaymentMethodUsecase = CreatePaymentMethodUsecase(repository: paymentRepositoryImp!);
      deletePaymentMethodUsecase = DeletePaymentMethodUsecase(repository: paymentRepositoryImp!);
      getPaymentMethodsUsecase = GetPaymentMethodsUsecase(repository: paymentRepositoryImp!);
      
      getBannersUsecase = GetBannersUsecase(repository: bannersRepositoryImp!);
      

    
  }
}

