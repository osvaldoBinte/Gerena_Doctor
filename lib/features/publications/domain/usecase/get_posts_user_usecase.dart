import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/domain/repositories/publication_repository.dart';

class GetPostsUserUsecase {
  final PublicationRepository publicationRepository;

  GetPostsUserUsecase({required this.publicationRepository});

  Future<List<PublicationEntity>> execute(int userid) async {
    return await publicationRepository.getPostsUser(userid);
  }
}