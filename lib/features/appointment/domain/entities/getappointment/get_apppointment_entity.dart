  class GetApppointmentEntity {
    final int id;
    final int clientId;
    final String clientName;

    final String clientPhone;

      final String doctorPhone;
    final int doctorId;
    final String doctorName;
    final String startDateTime;
    final String endDateTime;
    final String status;
    final String appointmentType;
    final String consultationReason;
    final String doctorNotes;
    final String diagnosis;
    final String cancellationReason;
    final String?foto;


  final String? alergias;
  final String? padecimientos;
  final String? enfermedadesCirugias;
  final String? pruebasEstudios;
  final String? comentarios;
    GetApppointmentEntity({
      required this.id,
      required this.clientId,
      required this.clientName,
      required this.clientPhone,
      required this.doctorPhone,
      required this.doctorId,
      required this.doctorName,
      required this.startDateTime,
      required this.endDateTime,
      required this.status,
      required this.appointmentType,
      required this.consultationReason,
      required this.doctorNotes,
      required this.diagnosis,
      required this.cancellationReason,
     this.foto,
    this.alergias,
    this.padecimientos,
    this.enfermedadesCirugias,
    this.pruebasEstudios,
    this.comentarios,
    });
  }