import 'package:gerena/features/doctors/domain/entities/doctoravailability/doctor_availability_entity.dart';

class DoctorAvailabilityModel extends DoctorAvailabilityEntity {
  DoctorAvailabilityModel({
    required super.id,
    required super.doctorId,
    required super.diaSemana,
    required super.horaInicio,
    required super.horaFin,
    required super.activo,
  });

  factory DoctorAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return DoctorAvailabilityModel(
      id: json['id'] ?? 0,
      doctorId: json['doctorId'] ?? 0,
      diaSemana: json['diaSemana'] ?? '',
      horaInicio: json['horaInicio'] ?? '',
      horaFin: json['horaFin'] ?? '',
      activo: json['activo'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'diaSemana': diaSemana,
      'horaInicio': horaInicio,
      'horaFin': horaFin,
      'activo': activo,
    };
  }
}
