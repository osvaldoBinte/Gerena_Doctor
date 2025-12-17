
import 'package:gerena/features/publications/domain/entities/myposts/author_entity.dart';

class GetCommentsEntity {
  final int id;
  final String? comentario;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final AuthorEntity? authorEntity;
   bool? esAutor;
  GetCommentsEntity({
    required this.id,
     this.comentario,
     this.createdAt,
     this.updatedAt,
     this.authorEntity,
    this.esAutor
  });


}