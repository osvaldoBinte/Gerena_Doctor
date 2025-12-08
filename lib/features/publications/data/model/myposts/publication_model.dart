import 'package:gerena/features/publications/data/model/myposts/author_model.dart';
import 'package:gerena/features/publications/data/model/myposts/image_model.dart';
import 'package:gerena/features/publications/data/model/myposts/reactions_model.dart';
import 'package:gerena/features/publications/data/model/myposts/tagged_doctor_model.dart';
import 'package:gerena/features/publications/domain/entities/myposts/author_entity.dart';
import 'package:gerena/features/publications/domain/entities/myposts/image_entity.dart';
import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';

class PublicationModel extends PublicationEntity {
  PublicationModel({
    required super.id,
    required AuthorEntity? super.author,
    required super.description,
    required List<ImageEntity> super.images,
    required super.isReview,
    super.taggedDoctor,
    super.userreaction,
    required super.rating,
    required super.reactions,
    required super.userHasLiked,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PublicationModel.fromJson(Map<String, dynamic> json) {
    return PublicationModel(
      id: json['id'],
      author:
          json['autor'] != null ? AuthorModel.fromJson(json['autor']) : null,
      description: json['descripcion'] ?? "",
      images:
          json['imagenes'] != null
              ? (json['imagenes'] as List)
                  .map((e) => ImageModel.fromJson(e))
                  .toList()
              : [],
      isReview: json['esReseña'] ?? false,

      taggedDoctor:
          json['doctorEtiquetado'] != null
              ? TaggedDoctorModel.fromJson(json['doctorEtiquetado'])
              : null,

      rating: json['calificacion'],
      reactions:
          json['reacciones'] != null
              ? ReactionsModel.fromJson(json['reacciones'])
              : ReactionsModel(
                likes: 0,
                ilove: 0,
                amazesme: 0,
                ineedit: 0,
                total: 0,
              ),
      userreaction: json['reaccionDelUsuario'],
      userHasLiked: json['usuarioHaDadoLike'] ?? false,
      createdAt: DateTime.parse(json['fechaCreacion']),
      updatedAt: DateTime.parse(json['fechaActualizacion']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "autor": author != null ? AuthorModel.fromEntity(author!).toJson() : null,
      "descripcion": description,
      "imagenes": images.map((e) => ImageModel.fromEntity(e).toJson()).toList(),
      "esReseña": isReview,
      "doctorEtiquetado": taggedDoctor,
      "calificacion": rating,
      "reacciones":
          reactions is ReactionsModel
              ? (reactions as ReactionsModel).toJson()
              : null,
      "usuarioHaDadoLike": userHasLiked,
      "fechaCreacion": createdAt.toIso8601String(),
      "fechaActualizacion": updatedAt.toIso8601String(),
    };
  }

  factory PublicationModel.fromEntity(PublicationEntity entity) {
    return PublicationModel(
      id: entity.id,
      author: entity.author,
      description: entity.description,
      images: entity.images,
      isReview: entity.isReview,
      taggedDoctor: entity.taggedDoctor,
      rating: entity.rating,
      reactions: entity.reactions,
      userHasLiked: entity.userHasLiked,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
