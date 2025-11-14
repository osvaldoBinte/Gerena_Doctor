class DoctorEntity  {
   int? userId;
   String? nombreCompleto;
   String? nombre;
   String? apellidos;
   String?email;
  final String numeroLicencia;
  final String especialidad;
  final int experienciaTiempo;
  final String fechaNacimiento;
  final String telefono;
  final String direccion;
  final String biografia;
   String? educacion;
   String? foto;
   String?titulo;
   String?institucion;
   String?certificacion;
   String?institucionCertificacion ;
  DoctorEntity( {
     this.userId,
    required this.nombreCompleto,
    required this.email,
    required this.numeroLicencia,
    required this.especialidad,
    required this.experienciaTiempo,
    required this.fechaNacimiento,
    required this.telefono,
    required this.direccion,
    required this.biografia,
     this.educacion,
 this.foto,
 this.nombre, this.apellidos,
  this.titulo,
  this.institucion,
  this.certificacion,
  this.institucionCertificacion,
    
  });
}