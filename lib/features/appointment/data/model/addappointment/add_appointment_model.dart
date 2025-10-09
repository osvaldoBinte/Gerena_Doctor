
import 'package:gerena/features/appointment/domain/entities/addappointment/add_appointment_entity.dart';

class AddAppointmentModel extends AddAppointmentEntity {
  AddAppointmentModel({
    required super.doctorId,
    required super.fechaHoraInicio,
    required super.tipoCita,
    required super.motivoCita,
  });
  factory AddAppointmentModel.fromJson(Map<String, dynamic> json) {
    return AddAppointmentModel(
      doctorId: json['doctorId']??0,
      fechaHoraInicio: json['fechaHoraInicio'] ?? '',
      tipoCita: json['tipoCita'] ?? '',
      motivoCita: json['motivoCita']??'',
    );
  }
  factory AddAppointmentModel.fromEntity(AddAppointmentEntity entity) {
    return AddAppointmentModel(
      doctorId: entity.doctorId,
      fechaHoraInicio: entity.fechaHoraInicio,
      tipoCita: entity.tipoCita,
      motivoCita: entity.motivoCita,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'fechaHoraInicio': fechaHoraInicio,
      'tipoCita': tipoCita,
      'motivoCita': motivoCita,
    };
  }
}
