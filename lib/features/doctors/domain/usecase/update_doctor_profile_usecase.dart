import 'package:gerena/features/doctors/domain/entities/doctor/doctor_entity.dart';
import 'package:gerena/features/doctors/domain/repositories/doctor_repository.dart';

class UpdateDoctorProfileUsecase {
  final DoctorRepository doctorRepository;
  UpdateDoctorProfileUsecase({required this.doctorRepository});
  Future<void> execute(DoctorEntity doctor) async {
    return await doctorRepository.updateDoctorProfile(doctor);
  }
}