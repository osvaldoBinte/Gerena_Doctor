
import 'package:gerena/features/doctors/domain/entities/doctoravailability/doctor_availability_entity.dart';

class DoctorAvailabilityModel extends DoctorAvailabilityEntity {
  DoctorAvailabilityModel({
    required super.fecha,
    required super.diaNombre,
    required super.horariosDisponibles,
  });

  factory DoctorAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return DoctorAvailabilityModel(
      fecha: json['fecha'] ?? '',
      diaNombre: json['diaNombre'] ?? '',
      horariosDisponibles: json['horariosDisponibles'] != null
          ? List<HorariosDisponiblesEntity>.from(
              (json['horariosDisponibles'] as List).map(
                (item) => HorariosDisponiblesEntity(
                  hora: item.toString(), 
                ),
              ),
            )
          : <HorariosDisponiblesEntity>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fecha': fecha,
      'diaNombre': diaNombre,
      'horariosDisponibles': horariosDisponibles.map((h) => h.hora).toList(),
    };
  }
}