import 'package:gerena/features/followers/domain/entities/follow_user_entity.dart';

class FollowUserModel extends FollowUserEntity {
  FollowUserModel({required super.userId, required super.username,super.fotoPerfil,super.especialidad, required super.rol});
  factory FollowUserModel.fromJson(Map<String, dynamic> json) {
    return FollowUserModel(
      userId: json['userId'],
      fotoPerfil: json['fotoPerfil'],
      especialidad: json['especialidad'],
      username: json['nombreCompleto'],
      rol: json['rol']
    );
  }
}