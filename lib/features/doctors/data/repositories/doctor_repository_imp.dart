import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/features/doctors/data/datasources/doctos_data_sources_imp.dart';
import 'package:gerena/features/doctors/domain/entities/doctor/doctor_entity.dart';
import 'package:gerena/features/doctors/domain/entities/doctoravailability/doctor_availability_entity.dart';
import 'package:gerena/features/doctors/domain/repositories/doctor_repository.dart';

class DoctorRepositoryImp implements DoctorRepository {
  final DoctosDataSourcesImp doctosDataSources;
    final AuthService authService = AuthService();

  DoctorRepositoryImp({required this.doctosDataSources});
  @override
  Future<DoctorEntity> getDoctorProfile() async {
      final session = await authService.getToken();
     if (session == null) {
        throw Exception('No hay sesión activa. El usuario debe iniciar sesión.');
      }
    return await doctosDataSources.getDoctorProfile(token: session);
  }

  @override
  Future<List<DoctorAvailabilityEntity>> getDoctorAvailability() async {
    final token = await authService.getToken() 
    ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));

    return await doctosDataSources.getDoctorAvailability(
      token: token,
    );
  }
}