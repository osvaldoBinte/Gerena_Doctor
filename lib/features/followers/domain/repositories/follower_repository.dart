import 'package:gerena/features/followers/domain/entities/follow_status_entity.dart';
import 'package:gerena/features/followers/domain/entities/follow_user_entity.dart';

abstract class FollowerRepository {
  Future<void> followUser(int userId);
  Future<void> unfollowUser(int userId);
  Future<FollowStatusEntity> getFollowStatus(int userId);
  Future<List<FollowUserEntity>> getFollows();
}