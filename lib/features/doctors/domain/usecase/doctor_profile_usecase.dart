import 'package:gerena/features/doctors/domain/entities/doctor/doctor_entity.dart';
import 'package:gerena/features/doctors/domain/repositories/doctor_repository.dart';

class DoctorProfileUsecase {
  final DoctorRepository doctorRepository;
  DoctorProfileUsecase({required this.doctorRepository});
  Future<DoctorEntity> execute() async {
    return await doctorRepository.getDoctorProfile();
  }
}
