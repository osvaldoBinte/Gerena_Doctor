
import 'package:gerena/features/doctors/domain/entities/doctoravailability/doctor_availability_entity.dart';
import 'package:gerena/features/doctors/domain/repositories/doctor_repository.dart';

class GetDoctorAvailabilityUsecase {
  final DoctorRepository doctorRepository;
  GetDoctorAvailabilityUsecase({required this.doctorRepository});
   Future<List<DoctorAvailabilityEntity>> getDoctorAvailability() async {
    return await doctorRepository.getDoctorAvailability();
   }
}