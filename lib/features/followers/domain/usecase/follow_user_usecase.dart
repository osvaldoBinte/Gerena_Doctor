import 'package:gerena/features/followers/domain/repositories/follower_repository.dart';

class FollowUserUsecase {
  final FollowerRepository followerRepository;
  FollowUserUsecase({required this.followerRepository});
  Future<void> execute(int userId) async {
    return await followerRepository.followUser(userId);
  }
}