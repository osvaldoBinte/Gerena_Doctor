
import 'package:gerena/features/followers/domain/entities/follow_user_entity.dart';
import 'package:gerena/features/followers/domain/repositories/follower_repository.dart';

class GetFollowingByUserUsecase {
  final FollowerRepository followerRepository;
  GetFollowingByUserUsecase({required this.followerRepository});
  Future<List<FollowUserEntity>> execute(int userid) async {
    return await followerRepository.getFollowingByUser(userid);
  }
}