import 'package:gerena/features/publications/domain/entities/myposts/author_entity.dart';
import 'package:gerena/features/publications/domain/entities/myposts/image_entity.dart';
import 'package:gerena/features/publications/domain/entities/myposts/reactions_entity.dart';
import 'package:gerena/features/publications/domain/entities/myposts/tagged_doctor_entity.dart';

class PublicationEntity {
  final int id;
  final AuthorEntity? author;
  final String description;
  final List<ImageEntity> images;
  final bool isReview;
  final TaggedDoctorEntity? taggedDoctor;

  final int? rating;
  final ReactionsEntity reactions;
  final bool userHasLiked;
  final DateTime createdAt;
  final DateTime updatedAt;
  String?userreaction;

  PublicationEntity({
    required this.id,
    required this.author,
    required this.description,
    required this.images,
    required this.isReview,
     this.taggedDoctor,
     this.userreaction,
    required this.rating,
    required this.reactions,
    required this.userHasLiked,
    required this.createdAt,
    required this.updatedAt,
  });
}

