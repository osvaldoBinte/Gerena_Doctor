import 'package:gerena/features/blog/domain/entities/blog_gerena_entity.dart';
import 'package:gerena/features/blog/domain/repositories/blog_repository.dart';

class GetBlogGerenaByIdUsecase {
  final BlogRepository blogRepository;
  GetBlogGerenaByIdUsecase({required this.blogRepository});
  Future<BlogGerenaEntity> execute(int id) async {
    return await blogRepository.blogGerenabyid(id);
  }
  
}