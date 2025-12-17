import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/features/auth/domain/entities/response/login_response_entity.dart';
import 'package:gerena/features/user/data/datasources/user_datasource_imp.dart';
import 'package:gerena/features/user/domain/entities/getuser/get_user_entity.dart';
import 'package:gerena/features/user/domain/entities/getuser/search_profile_entity.dart';
import 'package:gerena/features/user/domain/entities/getuser/search_profile_request_entity.dart';
import 'package:gerena/features/user/domain/entities/post/post_user_entity.dart';
import 'package:gerena/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImp implements UserRepository {
  final UserDatasourceImp userDataSource;
  final AuthService authService = AuthService();

  UserRepositoryImp({required this.userDataSource});
 
  
  @override
  Future<GetUserEntity> getUserDetailsbyid(int iduser) async {
   final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
   return userDataSource.getUserDetailsbyid(iduser, token);
  }

  @override
  Future<List<SearchProfileEntity>> searchProfile(SearchProfileRequestEntity entity) async {
   final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await userDataSource.searchProfile(entity, token);
  }
  
}
