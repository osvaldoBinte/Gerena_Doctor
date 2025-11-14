import 'package:gerena/features/doctors/domain/repositories/doctor_repository.dart';

class UpdatefotoDoctorProfileUsecase {
  final DoctorRepository doctorRepository;
  UpdatefotoDoctorProfileUsecase({required this.doctorRepository});
  Future<void> execute(String fotoPath) async {
    return await doctorRepository.updatefotoDoctorProfile(fotoPath);
  }
}