import 'package:gerena/features/publications/domain/entities/postreaction/post_reaction_entity.dart';
import 'package:gerena/features/publications/domain/repositories/publication_repository.dart';

class GetPostReactionUsecase {
  final PublicationRepository publicationRepository;

  GetPostReactionUsecase({ required this.publicationRepository});

  Future<List<PostReactionEntity>> execute(int publicationId) async {
    return await publicationRepository.getpostReaction(publicationId);
  }
}