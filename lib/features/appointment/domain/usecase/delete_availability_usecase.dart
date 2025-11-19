import 'package:gerena/features/appointment/domain/repositories/appointment_repository.dart';

class DeleteAvailabilityUsecase {
  final AppointmentRepository appointmentRepository;
  DeleteAvailabilityUsecase({required this.appointmentRepository});
  Future<void> execute(int id) async {
    return appointmentRepository.deleteAvailability(id);
  }
}