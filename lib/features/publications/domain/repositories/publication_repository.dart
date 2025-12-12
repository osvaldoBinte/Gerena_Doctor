import 'package:gerena/features/publications/domain/entities/create/create_publications_entity.dart';
import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';

abstract class PublicationRepository {
  Future<List<PublicationEntity>> getMyPosts();
  Future<List<PublicationEntity>> getFeedPosts();
  Future<void> createPublication(CreatePublicationsEntity publication);
  Future<void> likePublication(int publicationId,String tipoReaccion,);
  Future<void> updatePublication(String descripcion, int publicationId);
  Future<void> deletePublication(int publicationId);
  Future<List<PublicationEntity>> getPostsUser(int userid) ;
    Future<List<PublicationEntity>> getPostsDcotor(int userid) ;

}
