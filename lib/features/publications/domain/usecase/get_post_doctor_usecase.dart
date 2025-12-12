
import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/domain/repositories/publication_repository.dart';

class GetPostDoctorUsecase {
  final PublicationRepository publicationRepository;

  GetPostDoctorUsecase({required this.publicationRepository});

  Future<List<PublicationEntity>> execute(int userid) async {
    return await publicationRepository.getPostsDcotor(userid);
  }
}