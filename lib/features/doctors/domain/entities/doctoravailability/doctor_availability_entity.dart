class DoctorAvailabilityEntity {
   final int id;
  final int doctorId;
  final String diaSemana;
  final String horaInicio;
  final String horaFin;
  final bool activo;

  DoctorAvailabilityEntity({
    required this.id,
    required this.doctorId,
    required this.diaSemana,
    required this.horaInicio,
    required this.horaFin,
    required this.activo,
  });
}