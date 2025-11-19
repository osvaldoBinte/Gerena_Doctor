import 'package:gerena/features/appointment/domain/entities/availability/add_availability_entity.dart';

class AddAvailabilityModel extends AddAvailabilityEntity {
  AddAvailabilityModel({
    required super.dayOfWeek,
    required super.startTime,
    required super.endTime,
  });

  factory AddAvailabilityModel.fromEntity(AddAvailabilityEntity entity) {
    return AddAvailabilityModel(
      dayOfWeek: entity.dayOfWeek,
      startTime: entity.startTime,
      endTime: entity.endTime,
    );
  }

Map<String, dynamic> toJson() {
  final json = {
    'diaSemana': dayOfWeek.toUpperCase(),
    'horaInicio': _formatTimeWithSeconds(startTime),
    'horaFin': _formatTimeWithSeconds(endTime),
  };

  print('=== JSON ENVIADO AL BACKEND ===');
  print(json);
  print('================================');

  return json;
}

  // Convertir "08:00" a "08:00:00"
  String _formatTimeWithSeconds(String time) {
    if (time.split(':').length == 2) {
      return '$time:00';
    }
    return time;
  }
}