class GetUserEntity {
  final int userId;
  final String? nombreCompleto;
  final String ?apellidos;
  final String? direccion;
  final int? edad;
  final String? genero;
  final String ?tipoSangre;
  final String? ine;
  final String ?email;
  final String ?fechaNacimiento;
  final String ?telefono;
  final String? resumenMedico;
  final String? foto;
  final int? codigoPostal;
  final String ?ciudad;
  final String? username;

  GetUserEntity({
    required this.userId,
     this.nombreCompleto,
     this.apellidos,
     this.direccion,
     this.edad,
    this.genero,
     this.tipoSangre,
     this.ine,
     this.email,
     this.fechaNacimiento,
     this.telefono,
    this.resumenMedico,
    this.foto,
     this.codigoPostal,
     this.ciudad,
     this.username, 
  });
}