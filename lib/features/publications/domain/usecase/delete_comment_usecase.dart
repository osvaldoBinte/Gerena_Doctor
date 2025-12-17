import 'package:gerena/features/publications/domain/repositories/publication_repository.dart';

class DeleteCommentUsecase {
  PublicationRepository publicationRepository;
  DeleteCommentUsecase({required this.publicationRepository});
  Future<void> execute(int publicacionId,int idcomment) async {
    return await publicationRepository.deleteComment(publicacionId, idcomment);
  }
}