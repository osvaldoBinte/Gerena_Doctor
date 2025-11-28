import 'package:gerena/features/blog/domain/entities/blog_gerena_entity.dart';
import 'package:gerena/features/blog/domain/repositories/blog_repository.dart';

class GetBlogGerenaUsecase {
  final BlogRepository blogRepository;
  GetBlogGerenaUsecase({required this.blogRepository});
  Future<List<BlogGerenaEntity>> execute() async {
    return await blogRepository.blogGerena();
  }
}