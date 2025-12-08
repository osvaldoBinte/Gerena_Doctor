import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/domain/repositories/publication_repository.dart';

class GetMyPostsUsecase {
  final PublicationRepository publicationRepository;
  GetMyPostsUsecase({required this.publicationRepository});
  Future<List<PublicationEntity>> execute() async {
    return await publicationRepository.getMyPosts();  
  }
}