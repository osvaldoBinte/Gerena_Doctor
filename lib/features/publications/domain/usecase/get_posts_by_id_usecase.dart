import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/domain/repositories/publication_repository.dart';

class GetPostsByIdUsecase {
  final PublicationRepository publicationRepository;
  GetPostsByIdUsecase({required this.publicationRepository});
  Future<PublicationEntity> execute(int postId) async {
    return await publicationRepository.getPostsByid(postId);
  }
}