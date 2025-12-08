import 'package:gerena/features/followers/domain/repositories/follower_repository.dart';

class UnfollowUserUsecase {
  final FollowerRepository followerRepository;
  UnfollowUserUsecase({required this.followerRepository});
  Future<void> execute(int userId) async {
    return await followerRepository.unfollowUser(userId);
  }
}