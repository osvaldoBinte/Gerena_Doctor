import 'package:gerena/features/appointment/domain/entities/addappointment/add_appointment_entity.dart';

class AddAppointmentModel extends AddAppointmentEntity {
  AddAppointmentModel({
    required super.fechaHoraInicio,
    required super.tipoCita,
    required super.motivoConsulta,
    required super.nombres,
    required super.apellidos,
    required super.fechaCliente,
    required super.tipoSangre,
    required super.direccion,
    required super.ciudad,
    required super.codigoPostal,
    required super.colonia,
    required super.correo,
    required super.telefono,
    required super.alergias,
    required super.padecimientos,
    required super.enfermedadesCirugias,
    required super.pruebasEstudios,
    required super.comentarios,
  });

  factory AddAppointmentModel.fromJson(Map<String, dynamic> json) {
    return AddAppointmentModel(
      fechaHoraInicio: json['fechaHoraInicio'] ?? '',
      tipoCita: json['tipoCita'] ?? '',
      motivoConsulta: json['motivoConsulta'] ?? '',
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      fechaCliente: json['fechaCliente'] ?? '',
      tipoSangre: json['tipoSangre'] ?? '',
      direccion: json['direccion'] ?? '',
      ciudad: json['ciudad'] ?? '',
      codigoPostal: json['codigoPostal'] ?? '',
      colonia: json['colonia'] ?? '',
      correo: json['correo'] ?? '',
      telefono: json['telefono'] ?? '',
      alergias: json['alergias'] ?? '',
      padecimientos: json['padecimientos'] ?? '',
      enfermedadesCirugias: json['enfermedadesCirugias'] ?? '',
      pruebasEstudios: json['pruebasEstudios'] ?? '',
      comentarios: json['comentarios'] ?? '',
    );
  }

  factory AddAppointmentModel.fromEntity(AddAppointmentEntity entity) {
    return AddAppointmentModel(
      fechaHoraInicio: entity.fechaHoraInicio,
      tipoCita: entity.tipoCita,
      motivoConsulta: entity.motivoConsulta,
      nombres: entity.nombres,
      apellidos: entity.apellidos,
      fechaCliente: entity.fechaCliente,
      tipoSangre: entity.tipoSangre,
      direccion: entity.direccion,
      ciudad: entity.ciudad,
      codigoPostal: entity.codigoPostal,
      colonia: entity.colonia,
      correo: entity.correo,
      telefono: entity.telefono,
      alergias: entity.alergias,
      padecimientos: entity.padecimientos,
      enfermedadesCirugias: entity.enfermedadesCirugias,
      pruebasEstudios: entity.pruebasEstudios,
      comentarios: entity.comentarios,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'fechaHoraInicio': fechaHoraInicio,
      'tipoCita': tipoCita,
      'motivoConsulta': motivoConsulta,
      'nombres': nombres,
      'apellidos': apellidos,
      'fechaCliente': fechaCliente,
      'tipoSangre': tipoSangre,
      'direccion': direccion,
      'ciudad': ciudad,
      'codigoPostal': codigoPostal,
      'colonia': colonia,
      'correo': correo,
      'telefono': telefono,
      'alergias': alergias,
      'padecimientos': padecimientos,
      'enfermedadesCirugias': enfermedadesCirugias,
      'pruebasEstudios': pruebasEstudios,
      'comentarios': comentarios,
    };
  }
}
