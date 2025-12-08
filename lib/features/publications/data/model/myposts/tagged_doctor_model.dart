import 'package:gerena/features/publications/domain/entities/myposts/tagged_doctor_entity.dart';

class TaggedDoctorModel extends TaggedDoctorEntity {
  TaggedDoctorModel({
    required super.id,
    super.nombreCompleto,
    super.especialidad,
    super.fotoPerfil,
  });

  factory TaggedDoctorModel.fromJson(Map<String, dynamic> json) {
    return TaggedDoctorModel(
      id: json['id'],
      nombreCompleto: json['nombreCompleto'],
      especialidad: json['especialidad'],
      fotoPerfil: json['fotoPerfil'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombreCompleto': nombreCompleto,
      'especialidad': especialidad,
      'fotoPerfil': fotoPerfil,
    };
  }
}
