

import 'package:gerena/features/publications/data/model/myposts/author_model.dart';
import 'package:gerena/features/publications/domain/entities/comments/get_comments_entity.dart';

class GetCommentsModel extends GetCommentsEntity {
  GetCommentsModel({required super.id,  super.comentario,  super.updatedAt,  super.createdAt,  super.authorEntity, super.esAutor});
  
factory GetCommentsModel.fromJson(Map<String, dynamic> json) {
  return GetCommentsModel(
    id: json['id'] ?? 0,
    comentario: json['comentario'] ?? '',
    createdAt: json['fechaCreacion'] != null
        ? DateTime.parse(json['fechaCreacion'])
        : null,
    updatedAt: json['fechaActualizacion'] != null
        ? DateTime.parse(json['fechaActualizacion'])
        : null,
    authorEntity: json['usuario'] != null
        ? AuthorModel.fromJson(json['usuario'])
        : null,
    esAutor: json['esAutor']
  );
}


}