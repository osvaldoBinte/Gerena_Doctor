import 'package:gerena/features/appointment/domain/repositories/appointment_repository.dart';

class AppointmentCompletedUsecase {
  final AppointmentRepository appointmentRepository;
  AppointmentCompletedUsecase({required this.appointmentRepository});
  Future<void> execute(int id,String notasDoctor,String diagnostico) async {
  return await appointmentRepository.appointmentcompleted(id, notasDoctor, diagnostico);
  }
}