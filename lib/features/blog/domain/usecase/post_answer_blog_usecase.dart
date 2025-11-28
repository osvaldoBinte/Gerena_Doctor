import 'package:gerena/features/blog/domain/repositories/blog_repository.dart';

class PostAnswerBlogUsecase {
  final BlogRepository blogRepository;
  PostAnswerBlogUsecase({required this.blogRepository});
  Future<void> execute(int idblog,String answer) async {
    return await blogRepository.answerBlog(idblog, answer);
  }
}