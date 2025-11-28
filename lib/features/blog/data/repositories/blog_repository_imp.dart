import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/features/blog/data/datasources/blog_data_sources_imp.dart';
import 'package:gerena/features/blog/domain/entities/blog_gerena_entity.dart';
import 'package:gerena/features/blog/domain/entities/blog_social_entity.dart';
import 'package:gerena/features/blog/domain/entities/create/create_blog_social_entity.dart';
import 'package:gerena/features/blog/domain/repositories/blog_repository.dart';

class BlogRepositoryImp implements BlogRepository {
  final BlogDataSourcesImp blogDataSourcesImp;
  BlogRepositoryImp({required this.blogDataSourcesImp});
  AuthService authService = AuthService();
  @override
  Future<List<BlogGerenaEntity>> blogGerena() async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await blogDataSourcesImp.blogGerena(token);
  }

  @override
  Future<List<BlogSocialEntity>> blogSocial() async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await blogDataSourcesImp.blogSocial(token);
  }

  @override
  Future<void> createBlogSocial(CreateBlogSocialEntity entity) async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));

    return await blogDataSourcesImp.createBlogSocial(entity, token);
  }
  
  @override
  Future<void> answerBlog(int idblog, String answer) async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));

    return await blogDataSourcesImp.answerBlog(idblog, answer, token);
  }
  
  @override
  Future<BlogGerenaEntity> blogGerenabyid(int id) async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));

    return await blogDataSourcesImp.blogGerenabyid(token, id);
  }
  
  @override
  Future<BlogSocialEntity> blogSocialbyid(int id) async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));

    return await blogDataSourcesImp.blogSocialbyid(token, id);
  }
  
}