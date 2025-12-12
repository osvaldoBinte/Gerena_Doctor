import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/features/publications/data/datasources/publication_date_sources_imp.dart';
import 'package:gerena/features/publications/domain/entities/create/create_publications_entity.dart';
import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/domain/repositories/publication_repository.dart';

class PublicationRepositoryImp extends PublicationRepository {

  final PublicationDateSourcesImp publicationDateSourcesImp;
  PublicationRepositoryImp({required this.publicationDateSourcesImp});
  AuthService authService = AuthService();

  @override
  Future<void> createPublication(CreatePublicationsEntity publication) async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await publicationDateSourcesImp.createPublication(publication, token);
  }

  @override
  Future<void> deletePublication(int publicationId) async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return publicationDateSourcesImp.deletePublication(publicationId,token);
  }

  @override
  Future<List<PublicationEntity>> getFeedPosts() async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));

    return publicationDateSourcesImp.getFeedPosts(token);
  }

  @override
  Future<List<PublicationEntity>> getMyPosts() async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));

    return publicationDateSourcesImp.getMyPosts(token);
  }

  @override
  Future<void> likePublication(int publicationId,String tipoReaccion,) async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));

    return publicationDateSourcesImp.likePublication(publicationId,tipoReaccion,token);
  }

  @override
  Future<void> updatePublication(String descripcion, int publicationId) async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));

    return publicationDateSourcesImp.updatePublication(descripcion, publicationId,token);
  }
  
  @override
  Future<List<PublicationEntity>> getPostsUser(int userid, ) async {
        final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));

    return await publicationDateSourcesImp.getPostsUser(userid, token);
  }
  
  @override
  Future<List<PublicationEntity>> getPostsDcotor(int userid) async  {
           final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await publicationDateSourcesImp.getPostsDcotor(userid, token);
   ;
  }
  
}