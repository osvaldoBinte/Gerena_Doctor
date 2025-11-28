import 'package:gerena/features/blog/domain/entities/blog_social_entity.dart';
import 'package:gerena/features/blog/domain/repositories/blog_repository.dart';


class GetBlogSocialByIdUsecase {
  final BlogRepository blogRepository;
  GetBlogSocialByIdUsecase({required this.blogRepository});
  Future<BlogSocialEntity> execute(int id) async {
    return await blogRepository.blogSocialbyid(id);
  }
}