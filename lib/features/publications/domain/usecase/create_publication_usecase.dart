import 'package:gerena/features/publications/domain/entities/create/create_publications_entity.dart';
import 'package:gerena/features/publications/domain/repositories/publication_repository.dart';

class CreatePublicationUsecase {
  final PublicationRepository publicationRepository;
  CreatePublicationUsecase({required this.publicationRepository});
  Future<void> execute(CreatePublicationsEntity entity) async {
    return await publicationRepository.createPublication(entity);
  }
}