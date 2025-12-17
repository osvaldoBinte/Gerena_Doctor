import 'package:gerena/features/publications/domain/entities/myposts/author_entity.dart';

class AuthorModel extends AuthorEntity {
  AuthorModel({
    required super.id,
     super.name,
     super.profilePhoto,
     super.rol
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json["id"],
      name: json["nombre"],
      profilePhoto: json["fotoPerfil"],
      rol: json['rol']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nombre": name,
      "fotoPerfil": profilePhoto,
      'rol':rol
    };
  }

  factory AuthorModel.fromEntity(AuthorEntity entity) {
    return AuthorModel(
      id: entity.id,
      name: entity.name,
      profilePhoto: entity.profilePhoto,
      rol: entity.rol
    );
  }
}
