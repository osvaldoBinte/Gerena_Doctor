import 'package:gerena/features/blog/domain/entities/create/create_blog_social_entity.dart';
import 'package:gerena/features/blog/domain/repositories/blog_repository.dart';

class CreateBlogSocialUsecase {
  final BlogRepository blogRepository;
  CreateBlogSocialUsecase({required this.blogRepository});
  Future<void> execute(CreateBlogSocialEntity entity) async {
    return await blogRepository.createBlogSocial(entity);
  }
}