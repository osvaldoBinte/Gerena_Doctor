import 'package:gerena/features/appointment/domain/entities/getappointment/get_apppointment_entity.dart';
import 'package:gerena/features/appointment/domain/repositories/appointment_repository.dart';

class GetAppointmentsUsecase {
  final AppointmentRepository appointmentRepository;
  GetAppointmentsUsecase({required this.appointmentRepository});
  Future<List<GetApppointmentEntity>> execute(String date,String day) async{
    return await appointmentRepository.getAppointments(date,day);
  }
}