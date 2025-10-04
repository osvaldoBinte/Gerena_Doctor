import 'package:gerena/features/auth/domain/entities/response/login_response_entity.dart';

class UserModel  extends UserEntity{
  UserModel({
    required super.id,
    required super.email,
    required super.rol,
    required super.nombreCompleto,
    required super.telefono
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']??0,
      email: json['email'] ??'',
      rol: json['rol'] ??'',
      nombreCompleto: json['nombreCompleto'] ??'',
      telefono: json['telefono'] ??'',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'rol': rol,
      'nombreCompleto': nombreCompleto,
      'telefono': telefono,
    };
  }
}