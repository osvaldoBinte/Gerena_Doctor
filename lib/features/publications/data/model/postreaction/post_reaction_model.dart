import 'package:gerena/features/publications/domain/entities/postreaction/post_reaction_entity.dart';

class PostReactionModel extends PostReactionEntity {
  PostReactionModel({required super.userId,  super.nameuser,  super.fotouser, required super.type});
  factory PostReactionModel.fromEntity(PostReactionEntity entity) {
    return PostReactionModel(
      userId: entity.userId,
      nameuser: entity.nameuser,
      fotouser: entity.fotouser,
      type: entity.type,
    );
  }
  factory PostReactionModel.fromJson(Map<String, dynamic> json) {
    return PostReactionModel(
      userId: json['idUsuario'],
      nameuser: json['nombreUsuario'],
      fotouser: json['fotoPerfil'],
      type: json['tipoReaccion'],
    );
  }
}
