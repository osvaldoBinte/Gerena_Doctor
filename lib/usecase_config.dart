import 'package:gerena/features/appointment/data/datasources/appointment_data_sources_imp.dart';
import 'package:gerena/features/appointment/data/repositories/appointment_repository_imp.dart';
import 'package:gerena/features/appointment/domain/usecase/get_appointments_usecase.dart';
import 'package:gerena/features/auth/data/datasources/auth_data_sources_imp.dart';
import 'package:gerena/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:gerena/features/auth/domain/usecase/login_usecase.dart';
import 'package:gerena/features/doctors/data/datasources/doctos_data_sources_imp.dart';
import 'package:gerena/features/doctors/data/repositories/doctor_repository_imp.dart';
import 'package:gerena/features/doctors/domain/usecase/doctor_profile_usecase.dart';
import 'package:gerena/features/marketplace/data/datasources/marketplace_data_sources_imp.dart';
import 'package:gerena/features/marketplace/data/repositories/marketplace_repository_imp.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_medicine_by_id_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_my_order_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_order_by_id_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/searching_for_medications_usecase.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class UsecaseConfig {
   AuthRepositoryImp? authRepositoryImp;
   MarketplaceRepositoryImp? marketplaceRepositoryImp;


   AuthDataSourcesImp? authDataSources;
   MarketplaceDataSourcesImp?marketplaceDataSourcesImp;


   LoginUsecase? loginUsecase;

   DoctorRepositoryImp? doctorRepositoryImp;
   DoctosDataSourcesImp? doctosDataSources;
   DoctorProfileUsecase? doctorProfileUsecase;

   AppointmentRepositoryImp? appointmentRepositoryImp;
   AppointmentDataSourcesImp? appointmentDataSourcesImp;
   GetAppointmentsUsecase? getAppointmentsUsecase;


   GetMyOrderUsecase? getMyOrderUsecase;
   GetOrderByIdUsecase?getOrderByIdUsecase;
   GetMedicineByIdUsecase?getMedicineByIdUsecase;
   SearchingForMedicationsUsecase? searchingForMedicationsUsecase;




  UsecaseConfig(){
     authDataSources = AuthDataSourcesImp();
     doctosDataSources = DoctosDataSourcesImp();
      appointmentDataSourcesImp = AppointmentDataSourcesImp();
      marketplaceDataSourcesImp = MarketplaceDataSourcesImp();

     doctorRepositoryImp = DoctorRepositoryImp(doctosDataSources: doctosDataSources!);
     authRepositoryImp = AuthRepositoryImp(authDataSources: authDataSources!);
      appointmentRepositoryImp = AppointmentRepositoryImp(appointmentDataSources: appointmentDataSourcesImp!);
      marketplaceRepositoryImp = MarketplaceRepositoryImp(marketplaceDataSourcesImp: marketplaceDataSourcesImp!);

     loginUsecase = LoginUsecase(authRepository: authRepositoryImp!);
     doctorProfileUsecase = DoctorProfileUsecase(doctorRepository: doctorRepositoryImp!);
     getAppointmentsUsecase = GetAppointmentsUsecase(appointmentRepository: appointmentRepositoryImp!);

     getMedicineByIdUsecase = GetMedicineByIdUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     getMyOrderUsecase = GetMyOrderUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     getMedicineByIdUsecase=GetMedicineByIdUsecase(marketplaceRepository: marketplaceRepositoryImp!);
     searchingForMedicationsUsecase = SearchingForMedicationsUsecase(marketplaceRepository: marketplaceRepositoryImp!);
    
  }
}

