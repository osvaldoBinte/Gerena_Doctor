import 'package:gerena/features/publications/domain/repositories/publication_repository.dart';

class LikePublicationUsecase {
  final PublicationRepository publicationRepository;
  LikePublicationUsecase({required this.publicationRepository});
  Future<void> execute(int publicationId,String tipoReaccion,) async {
    return await publicationRepository.likePublication(publicationId,tipoReaccion);
  }
}