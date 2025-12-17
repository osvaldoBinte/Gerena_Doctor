

import 'package:gerena/features/publications/domain/entities/comments/get_comments_entity.dart';
import 'package:gerena/features/publications/domain/repositories/publication_repository.dart';

class GetPostCommentsUsecase {
  final PublicationRepository publicationRepository;
  GetPostCommentsUsecase({required this.publicationRepository});
  Future<List<GetCommentsEntity>> execute(int publicacionId, int page) async {
    return await publicationRepository.getPostComments(publicacionId, page);
  }
}