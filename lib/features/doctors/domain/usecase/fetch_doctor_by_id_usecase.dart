

import 'package:gerena/features/doctors/domain/entities/finddoctors/docotor_by_id_entity.dart';
import 'package:gerena/features/doctors/domain/repositories/doctor_repository.dart';

class FetchDoctorByIdUsecase {
  final DoctorRepository doctorRepository;
  FetchDoctorByIdUsecase({required this.doctorRepository});
  Future<DocotorByIdEntity> execute(int id) async {
    return await doctorRepository.fetchDoctorsbyid(id); 
  }
}