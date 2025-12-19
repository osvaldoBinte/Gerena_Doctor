import 'package:gerena/features/auth/domain/entities/response/login_response_entity.dart';

abstract class AuthRepository {
  Future<LoginResponseEntity> login(String email, String password);
  Future<void> requestPasswordCode(String email);
  Future<void> confirmPasswordReset(String email,String code ,String  newpassword);

}