import 'package:gerena/features/user/domain/entities/getuser/get_user_entity.dart';
import 'package:gerena/features/user/domain/repositories/user_repository.dart';

class GetUserDetailsByIdUsecase {
  final UserRepository userRepository;

  GetUserDetailsByIdUsecase({required this.userRepository});

  Future<GetUserEntity> execute(int iduser) async {
    return await userRepository.getUserDetailsbyid(iduser);
  }
}