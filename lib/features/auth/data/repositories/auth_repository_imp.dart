import 'package:gerena/features/auth/data/datasources/auth_data_sources_imp.dart';
import 'package:gerena/features/auth/domain/entities/response/login_response_entity.dart';
import 'package:gerena/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthDataSourcesImp authDataSources;
  AuthRepositoryImp({required this.authDataSources});

  @override
  Future<LoginResponseEntity> login(String email, String password) async {
    return await authDataSources.login(email, password);
  }
 
}