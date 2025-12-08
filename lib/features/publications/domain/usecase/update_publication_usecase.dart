import 'package:gerena/features/publications/domain/repositories/publication_repository.dart';

class UpdatePublicationUsecase {
  final PublicationRepository publicationRepository;
  UpdatePublicationUsecase({required this.publicationRepository});
  Future<void> execute(String descripcion, int publicationId) async {
    return await publicationRepository.updatePublication(descripcion,publicationId);
  }
}