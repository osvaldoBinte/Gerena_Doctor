import 'package:gerena/features/publications/domain/entities/myposts/author_entity.dart';

class AuthorModel extends AuthorEntity {
  AuthorModel({
    required super.id,
     super.name,
     super.profilePhoto,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json["id"],
      name: json["nombre"],
      profilePhoto: json["fotoPerfil"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nombre": name,
      "fotoPerfil": profilePhoto,
    };
  }

  factory AuthorModel.fromEntity(AuthorEntity entity) {
    return AuthorModel(
      id: entity.id,
      name: entity.name,
      profilePhoto: entity.profilePhoto,
    );
  }
}
