import 'package:gerena/features/user/domain/entities/getuser/search_profile_entity.dart';
import 'package:gerena/features/user/domain/entities/getuser/search_profile_request_entity.dart';
import 'package:gerena/features/user/domain/repositories/user_repository.dart';

class SearchProfileUsecase {
  final UserRepository userRepository;
  SearchProfileUsecase({required this.userRepository});
  Future<List<SearchProfileEntity>> searchProfile(SearchProfileRequestEntity entity) async {
    return await userRepository.searchProfile(entity);
  }
}