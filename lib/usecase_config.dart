import 'package:gerena/features/auth/data/datasources/auth_data_sources_imp.dart';
import 'package:gerena/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:gerena/features/auth/domain/usecase/login_usecase.dart';
import 'package:gerena/features/doctors/data/datasources/doctos_data_sources.dart';
import 'package:gerena/features/doctors/data/repositories/doctor_repository_imp.dart';
import 'package:gerena/features/doctors/domain/usecase/doctor_profile_usecase.dart';

class UsecaseConfig {
   AuthRepositoryImp? authRepositoryImp;
   AuthDataSourcesImp? authDataSources;
   LoginUsecase? loginUsecase;

   DoctorRepositoryImp? doctorRepositoryImp;
   DoctosDataSources? doctosDataSources;
   DoctorProfileUsecase? doctorProfileUsecase;


  UsecaseConfig(){
     authDataSources = AuthDataSourcesImp();
     doctosDataSources = DoctosDataSources();
     doctorRepositoryImp = DoctorRepositoryImp(doctosDataSources: doctosDataSources!);
    authRepositoryImp = AuthRepositoryImp(authDataSources: authDataSources!);
    loginUsecase = LoginUsecase(authRepository: authRepositoryImp!);

     doctorProfileUsecase = DoctorProfileUsecase(doctorRepository: doctorRepositoryImp!);
    
  }
}

