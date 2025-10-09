class AddAppointmentEntity {
  final int doctorId;
  final String fechaHoraInicio;
  final String tipoCita;
  final String motivoCita;
  AddAppointmentEntity({
    required this.doctorId,
    required this.fechaHoraInicio,
    required this.tipoCita,
    required this.motivoCita,
  });
}