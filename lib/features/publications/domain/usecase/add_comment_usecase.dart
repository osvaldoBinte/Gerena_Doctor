import 'package:gerena/features/publications/domain/repositories/publication_repository.dart';

class AddCommentUsecase {
  final PublicationRepository publicationRepository;
  AddCommentUsecase({required this.publicationRepository});
  Future<void> execute(int publicacionId,String comment) async {
    return await publicationRepository.addComment(publicacionId, comment);
  }
}