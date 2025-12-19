import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/domain/repositories/publication_repository.dart';

class GetFeedPostsUsecase {
  final PublicationRepository publicationRepository;
  GetFeedPostsUsecase({required this.publicationRepository});
  Future<List<PublicationEntity>> execute(int page,int pagesize,) async {
    return await publicationRepository.getFeedPosts(page,pagesize);  
  }
}