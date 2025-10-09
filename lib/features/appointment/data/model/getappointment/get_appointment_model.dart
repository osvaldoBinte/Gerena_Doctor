import 'package:flutter/foundation.dart';
import 'package:gerena/features/appointment/domain/entities/getappointment/get_apppointment_entity.dart';

class GetAppointmentModel extends GetApppointmentEntity {
  GetAppointmentModel(
      {required super.id,
      required super.clientId,
      required super.clientName,
      required super.doctorId,
      required super.doctorName,
      required super.startDateTime,
      required super.endDateTime,
      required super.status,
      required super.appointmentType,
      required super.consultationReason,
      required super.doctorNotes,
      required super.diagnosis,
      required super.cancellationReason});

  factory GetAppointmentModel.fromJson(Map<String, dynamic> json) {
    return GetAppointmentModel(
      id: json['id'] ?? 0,
      clientId: json['clienteId'] ?? 0,
      clientName: json['clienteNombre'] ?? '',
      doctorId: json['doctorId'] ?? 0,
      doctorName: json['doctorNombre'] ?? '',
      startDateTime: json['fechaHoraInicio'] ?? '',
      endDateTime: json['fechaHoraFin'] ?? '',
      status: json['estado'] ?? '',
      appointmentType: json['tipoCita'] ?? '',
      consultationReason: json['motivoConsulta'] ?? '',
      doctorNotes: json['notasDoctor'] ?? '',
      diagnosis: json['diagnostico'] ?? '',
      cancellationReason: json['motivoCancelacion'] ?? '',
    );
  }
}
