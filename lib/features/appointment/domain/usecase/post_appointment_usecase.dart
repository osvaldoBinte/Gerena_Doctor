
import 'package:gerena/features/appointment/domain/entities/addappointment/add_appointment_entity.dart';
import 'package:gerena/features/appointment/domain/repositories/appointment_repository.dart';

class PostAppointmentUsecase {
  final AppointmentRepository appointmentRepository;

  PostAppointmentUsecase({required this.appointmentRepository});

  Future<void> execute(AddAppointmentEntity addAppointment) async {
    return await appointmentRepository.addAppointment(addAppointment);
  }
}