import 'package:gerena/features/publications/domain/repositories/publication_repository.dart';

class DeletePublicationUsecase {
  final PublicationRepository publicationRepository;
  DeletePublicationUsecase({required this.publicationRepository});
  Future<void> execute(int publicationId) async {
    return await publicationRepository.deletePublication(publicationId);
  }
}