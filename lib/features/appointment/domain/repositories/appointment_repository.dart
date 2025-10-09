
import 'package:gerena/features/appointment/domain/entities/addappointment/add_appointment_entity.dart';
import 'package:gerena/features/appointment/domain/entities/getappointment/get_apppointment_entity.dart';

abstract class AppointmentRepository {
  Future<void> addAppointment(AddAppointmentEntity appointment);
  Future<List<GetApppointmentEntity>> getAppointments(String date,String day);
}