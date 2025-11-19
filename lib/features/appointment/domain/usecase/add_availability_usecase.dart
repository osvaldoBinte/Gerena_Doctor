import 'package:gerena/features/appointment/domain/entities/availability/add_availability_entity.dart';
import 'package:gerena/features/appointment/domain/repositories/appointment_repository.dart';

class AddAvailabilityUsecase {
  final AppointmentRepository appointmentRepository;
  AddAvailabilityUsecase({required this.appointmentRepository});
   Future<void> execute(List<AddAvailabilityEntity> entities) async{
    return await appointmentRepository.addAvailability(entities);
   }
}