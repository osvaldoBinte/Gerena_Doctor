import 'package:gerena/features/doctors/domain/entities/doctor/doctor_entity.dart';

class DoctorModel extends DoctorEntity {
  DoctorModel({
     super.userId,
     super.nombreCompleto,
     super.email,
     super.numeroLicencia,
     super.especialidad,
     super.experienciaTiempo,
     super.fechaNacimiento,
     super.telefono,
     super.direccion,
     super.biografia,
     super.educacion,
     super.foto,
     super.nombre,
     super.apellidos,
     super.titulo,
      super.institucion,
      super.certificacion,
      super.institucionCertificacion,

      super.linkedIn,
      super.facebook,
      super.x,
      super.instagram,
      super.nombreVendedor,
      super.whatsAppVendedor,
      super.correoVendedor,
      super.puntosDisponibles

     

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
      linkedIn: json['linkedIn']??'',
      facebook: json['facebook']??'',
      x: json['x']??'',
      instagram:json['instagram']??'',
      nombreVendedor:json['nombreVendedor']??'',
      whatsAppVendedor:json['whatsAppVendedor']??'',
      correoVendedor:json['correoVendedor']??'',
      puntosDisponibles:json['puntosDisponibles']??0
    );
  }
factory DoctorModel.fromEntity(DoctorEntity entity) {
  return DoctorModel(
    nombreCompleto: entity.nombreCompleto,
    nombre: entity.nombre,
    apellidos: entity.apellidos,
    numeroLicencia: entity.numeroLicencia,
    especialidad: entity.especialidad,
    experienciaTiempo: entity.experienciaTiempo,
    fechaNacimiento: entity.fechaNacimiento,
    telefono: entity.telefono,
    direccion: entity.direccion,
    biografia: entity.biografia,
    titulo: entity.titulo,
    institucion: entity.institucion,
    certificacion: entity.certificacion,
    institucionCertificacion: entity.institucionCertificacion,
    linkedIn: entity.linkedIn,
    facebook:entity.facebook,
    x: entity.x,
    instagram:entity.instagram,

  
  );
}

Map<String, dynamic> toJson() {
  return {
    'nombreCompleto': nombreCompleto,
    'nombre': nombre,
    'apellidos': apellidos,
    'numeroLicencia': numeroLicencia,
    'especialidad': especialidad,
    'experienciaTiempo': experienciaTiempo,
    'fechaNacimiento': fechaNacimiento,
    'telefono': telefono,
    'direccion': direccion,
    'biografia': biografia,
    'titulo': titulo,
    'institucion': institucion,
    'certificacion': certificacion,
    'institucionCertificacion': institucionCertificacion,
    'linkedIn': linkedIn,
    'facebook':facebook,
    'x': x,
    'instagram':instagram,
  };
}

  
}
