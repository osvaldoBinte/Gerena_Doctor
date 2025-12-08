import 'package:gerena/features/followers/domain/entities/follow_user_entity.dart';
import 'package:gerena/features/followers/domain/repositories/follower_repository.dart';

class GetFollowsUsecase {
  final FollowerRepository followerRepository;
  GetFollowsUsecase({required this.followerRepository});
  Future<List<FollowUserEntity>> execute() async {
    return await followerRepository.getFollows();
  }
}