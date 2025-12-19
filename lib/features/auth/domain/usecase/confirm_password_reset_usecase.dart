import 'package:gerena/features/auth/domain/repositories/auth_repository.dart';

class ConfirmPasswordResetUsecase {
  final AuthRepository authRepository;
  ConfirmPasswordResetUsecase({required this.authRepository});
  Future<void> confirmPasswordReset(String email,String code ,String  newpassword) async {
    return await authRepository.confirmPasswordReset(email, code, newpassword);
  }
}