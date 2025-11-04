import 'package:gerena/features/doctors/domain/entities/doctor/doctor_entity.dart';

class DoctorModel extends DoctorEntity {
  DoctorModel({
    required super.userId,
    required super.nombreCompleto,
    required super.email,
    required super.numeroLicencia,
    required super.especialidad,
    required super.experienciaTiempo,
    required super.fechaNacimiento,
    required super.telefono,
    required super.direccion,
    required super.biografia,
    required super.educacion,
     super.foto,
     super.nombre,
     super.apellidos,
     super.titulo,
      super.institucion,
      super.certificacion,
      super.institucionCertificacion,
  });
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      userId: json['userId'],
      nombreCompleto: json['nombreCompleto'],
      email: json['email'],
      numeroLicencia: json['numeroLicencia'],
      especialidad: json['especialidad'],
      experienciaTiempo: json['experienciaTiempo'],
      fechaNacimiento:json['fechaNacimiento'],
      telefono: json['telefono'],
      direccion: json['direccion'],
      biografia: json['biografia'],
      educacion: json['educacion'],
      foto: json['foto']??'',
      nombre: json['nombre']??'',
      apellidos: json['apellidos']??'',
      titulo: json['titulo']??'',
      institucion: json['institucion']??'',
      certificacion: json['certificacion']??'',
      institucionCertificacion: json['institucionCertificacion']??'',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nombreCompleto': nombreCompleto,
      'email': email,
      'numeroLicencia': numeroLicencia,
      'especialidad': especialidad,
      'experienciaTiempo': experienciaTiempo,
      'fechaNacimiento': fechaNacimiento,
      'telefono': telefono,
      'direccion': direccion,
      'biografia': biografia,
      'educacion': educacion,
      'foto': foto,
      'nombre': nombre,
      'apellidos': apellidos,
      'titulo': titulo,
      'institucion': institucion,
      'certificacion': certificacion,
      'institucionCertificacion': institucionCertificacion,
    };
  }
  
}
