import 'package:gerena/features/blog/domain/entities/blog_social_entity.dart';
import 'package:gerena/features/blog/domain/repositories/blog_repository.dart';

class GetBlogSocialUsecase {
  final BlogRepository blogRepository;
  GetBlogSocialUsecase({required this.blogRepository});
  Future<List<BlogSocialEntity>> execute() async {
    return await blogRepository.blogSocial();
  }
}