import 'package:gerena/features/appointment/domain/repositories/appointment_repository.dart';

class CancelAppointmentUsecase {
  final AppointmentRepository appointmentRepository;
  CancelAppointmentUsecase({required this.appointmentRepository});
  Future<void> execute(int id, String motivoCancelacion) async {
    return await appointmentRepository.cancelappointment(id, motivoCancelacion);
  }
}