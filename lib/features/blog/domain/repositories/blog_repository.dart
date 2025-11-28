import 'package:gerena/features/blog/domain/entities/blog_social_entity.dart';
import 'package:gerena/features/blog/domain/entities/create/create_blog_social_entity.dart';
import 'package:gerena/features/blog/domain/entities/blog_gerena_entity.dart';

abstract class BlogRepository {
   Future<List<BlogGerenaEntity>> blogGerena();
   Future<BlogGerenaEntity> blogGerenabyid(int id);
   Future<List<BlogSocialEntity>> blogSocial();
   Future<BlogSocialEntity> blogSocialbyid(int id);
   Future<void> createBlogSocial(CreateBlogSocialEntity entity);
   Future<void> answerBlog(int idblog,String answer);
}