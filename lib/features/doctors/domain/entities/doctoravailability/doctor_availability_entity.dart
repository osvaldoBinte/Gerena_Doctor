class DoctorAvailabilityEntity {
  final String fecha;
  final String diaNombre;
  final List<HorariosDisponiblesEntity> horariosDisponibles;
  
  DoctorAvailabilityEntity({
    required this.fecha,
    required this.diaNombre,
    required this.horariosDisponibles,
  });
}

class HorariosDisponiblesEntity {
  final String hora;
  
  HorariosDisponiblesEntity({
    required this.hora,
  });
}