import 'package:gerena/features/auth/domain/entities/response/login_response_entity.dart';
import 'package:gerena/features/user/domain/entities/getuser/get_user_entity.dart';
import 'package:gerena/features/user/domain/entities/post/post_user_entity.dart';

abstract class UserRepository {
  Future<GetUserEntity> getUserDetailsbyid(int iduser);
}