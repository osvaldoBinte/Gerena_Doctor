import 'package:gerena/features/doctors/domain/entities/doctor/doctor_entity.dart';
import 'package:gerena/features/doctors/domain/entities/doctoravailability/doctor_availability_entity.dart';

abstract class DoctorRepository {
  Future<DoctorEntity> getDoctorProfile();
    Future<List<DoctorAvailabilityEntity>> getDoctorAvailability();

}