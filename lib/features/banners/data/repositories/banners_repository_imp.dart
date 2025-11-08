import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/features/banners/data/datasources/banners_data_sources_imp.dart';
import 'package:gerena/features/banners/domain/entity/banners_entity.dart';
import 'package:gerena/features/banners/domain/repositories/banners_repository.dart';

class BannersRepositoryImp implements BannersRepository {
  final BannersDataSourcesImp bannersDataSourcesImp;
  AuthService authService = AuthService();
  BannersRepositoryImp({required this.bannersDataSourcesImp});
  @override
  Future<List<BannersEntity>> getBannersList() async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await bannersDataSourcesImp.getBannersList(token);
  }
}