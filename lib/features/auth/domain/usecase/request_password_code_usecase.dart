import 'package:gerena/features/auth/domain/repositories/auth_repository.dart';

class RequestPasswordCodeUsecase {
  final AuthRepository authRepository;
  RequestPasswordCodeUsecase({required this.authRepository});
    Future<void> execute(String email) async {
      return await authRepository.requestPasswordCode(email);
    }

}