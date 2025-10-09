
import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/features/appointment/data/datasources/appointment_data_sources_imp.dart';
import 'package:gerena/features/appointment/domain/entities/addappointment/add_appointment_entity.dart';
import 'package:gerena/features/appointment/domain/entities/getappointment/get_apppointment_entity.dart';
import 'package:gerena/features/appointment/domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImp implements AppointmentRepository {
  final AppointmentDataSourcesImp appointmentDataSources;
  final AuthService authService = AuthService();

  AppointmentRepositoryImp({required this.appointmentDataSources});
  @override
  Future<void> addAppointment(AddAppointmentEntity appointment) async {
    final session = await authService.getToken();
    if (session == null) {
      throw Exception('No hay sesión activa. El usuario debe iniciar sesión.');
    }
    return await appointmentDataSources.postAppointments(
      appointment,
      session,
    );
  }

  @override
  Future<List<GetApppointmentEntity>> getAppointments(String date,String day) async {
     final session = await authService.getToken();
    if (session == null) {
      throw Exception('No hay sesión activa. El usuario debe iniciar sesión.');
    }
    return await appointmentDataSources.getAppointments(session,date,day);
  }
}
