import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/features/followers/data/datasources/follower_data_sources_imp.dart';
import 'package:gerena/features/followers/domain/entities/follow_status_entity.dart';
import 'package:gerena/features/followers/domain/entities/follow_user_entity.dart';
import 'package:gerena/features/followers/domain/repositories/follower_repository.dart';

class FollowerRepositoryImp  extends FollowerRepository{
  final FollowerDataSourcesImp followerDataSourcesImp;
  FollowerRepositoryImp({required this.followerDataSourcesImp});
  AuthService authService = AuthService();
  @override
  Future<void> followUser(int userId) async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return followerDataSourcesImp.followUser(userId,token);
  }

  @override
  Future<FollowStatusEntity> getFollowStatus(int userId) async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return followerDataSourcesImp.getFollowStatus(userId,token);
  }

  Future<List<FollowUserEntity>> getFollowingByUser(int userid)  async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await followerDataSourcesImp.getFollowingByUser(userid, token);
  }
  
  @override
  Future<List<FollowUserEntity>> getUserFollowers(int userid) async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await followerDataSourcesImp.getUserFollowers(userid, token);
  }

  @override
  Future<void> unfollowUser(int userId) async {
    final token = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return followerDataSourcesImp.unfollowUser(userId,token);
  }
}