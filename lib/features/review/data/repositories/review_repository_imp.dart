import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/review/data/datasources/review_data_sources_imp.dart';
import 'package:gerena/features/review/domain/repositories/review_repository.dart';

class ReviewRepositoryImp extends ReviewRepository {
  ReviewDataSourcesImp reviewDataSourcesImp;
  final AuthService authService = AuthService();
  ReviewRepositoryImp({required this.reviewDataSourcesImp});
  @override
  Future<List< PublicationEntity>> myreview() async {
   final token = await authService.getToken() ??(throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
      final id = await authService.getUsuarioId() ??(throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
      return await reviewDataSourcesImp.getMyReview(id, token);

  }

}