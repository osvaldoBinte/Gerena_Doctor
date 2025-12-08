import 'package:gerena/features/followers/domain/entities/follow_status_entity.dart';
import 'package:gerena/features/followers/domain/repositories/follower_repository.dart';

class GetFollowStatusUsecase {
  final FollowerRepository followerRepository;
  GetFollowStatusUsecase({required this.followerRepository});
  Future<FollowStatusEntity> execute(int userId) async {
    return await followerRepository.getFollowStatus(userId);
  }
}