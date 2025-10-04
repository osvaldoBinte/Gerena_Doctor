import 'package:gerena/features/doctors/domain/entities/doctor/doctor_entity.dart';

abstract class DoctorRepository {
  Future<DoctorEntity> getDoctorProfile();

}