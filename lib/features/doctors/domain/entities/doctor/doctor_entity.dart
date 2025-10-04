class DoctorEntity  {
  final int userId;
  final String nombreCompleto;
  final String email;
  final String numeroLicencia;
  final String especialidad;
  final int experienciaTiempo;
  final String fechaNacimiento;
  final String telefono;
  final String direccion;
  final String biografia;
  final String educacion;
  final String foto;
  DoctorEntity({
    required this.userId,
    required this.nombreCompleto,
    required this.email,
    required this.numeroLicencia,
    required this.especialidad,
    required this.experienciaTiempo,
    required this.fechaNacimiento,
    required this.telefono,
    required this.direccion,
    required this.biografia,
    required this.educacion,
    required this.foto,
  });
}