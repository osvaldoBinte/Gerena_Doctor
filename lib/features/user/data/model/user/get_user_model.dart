
import 'package:gerena/features/user/domain/entities/getuser/get_user_entity.dart';

class GetUserModel extends GetUserEntity {
  GetUserModel({
    required super.userId,
     super.nombreCompleto,
     super.apellidos,
     super.direccion,
     super.edad,
     super.tipoSangre,
     super.ine,
     super.email,
     super.fechaNacimiento,
     super.telefono,
     super.codigoPostal,
     super.ciudad,
     super.foto,
     super.genero,
     super.resumenMedico,
     super.username,
  });
  factory GetUserModel.fromJson(Map<String, dynamic> json) {
    return GetUserModel(
      userId: json['userId'] ?? 0,
      nombreCompleto: json['nombreCompleto']??'',
      apellidos: json['apellidos']??'',
      direccion: json['direccion']??'',
      edad: json['edad']??0,
      tipoSangre: json['tipoSangre']??'',
      ine: json['ine']??'',
      email: json['email']??'',
      fechaNacimiento: json['fechaNacimiento'] ?? '',
      telefono: json['telefono'] ?? '',
      codigoPostal: json['codigoPostal']??0,
      ciudad: json['ciudad']??'',
      foto: json['foto']??'',
      genero: json['genero']??'',
      resumenMedico: json['resumenMedico']??'',
      username: json['usuario']??'',
    );
  }
}
