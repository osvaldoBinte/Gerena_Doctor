import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/features/followers/domain/entities/follow_status_entity.dart';
import 'package:gerena/features/followers/domain/entities/follow_user_entity.dart';
import 'package:gerena/features/followers/domain/usecase/get_follow_status_usecase.dart';
import 'package:gerena/features/followers/domain/usecase/get_following_by_user_usecase.dart';
import 'package:gerena/features/followers/domain/usecase/get_user_followers_usecase.dart';
import 'package:get/get.dart';

class FollowerController extends GetxController {
  final GetFollowStatusUsecase getFollowStatusUsecase;
  final GetUserFollowersUsecase getUserFollowersUsecase;
  final GetFollowingByUserUsecase getFollowingByUserUsecase;
  
  FollowerController({
    required this.getFollowStatusUsecase,
    required this.getUserFollowersUsecase,
    required this.getFollowingByUserUsecase,
  });
  
  final AuthService authService = AuthService();

  // Estado general
  final Rx<FollowStatusEntity?> followStatus = Rx<FollowStatusEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Listas de seguidores y seguidos
  final RxList<FollowUserEntity> followers = <FollowUserEntity>[].obs;
  final RxList<FollowUserEntity> following = <FollowUserEntity>[].obs;
  final RxBool isLoadingFollowers = false.obs;
  final RxBool isLoadingFollowing = false.obs;

  int get totalFollowers => followStatus.value?.totalFollowers ?? 0;
  int get totalFollowing => followStatus.value?.totalFollowing ?? 0;

  @override
  void onInit() {
    super.onInit();
    loadFollowStatus();
  }

  Future<void> loadFollowStatus() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final userId = await authService.getUsuarioId();
      
      if (userId == null) {
        throw Exception('No hay sesión activa. El usuario debe iniciar sesión.');
      }

      final status = await getFollowStatusUsecase.execute(userId);

      if (status != null) {
        followStatus.value = status;
        hasError.value = false;
      } else {
        hasError.value = true;
        errorMessage.value = 'No se pudo obtener el estado de seguimiento';
        followStatus.value = null;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error inesperado: ${e.toString()}';
      followStatus.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadFollowers() async {
    try {
      isLoadingFollowers.value = true;
      
      final userId = await authService.getUsuarioId();
      
      if (userId == null) {
        throw Exception('No hay sesión activa');
      }

      final followersList = await getUserFollowersUsecase.execute(userId);
      followers.value = followersList;
      
    } catch (e) {
      print('Error al cargar seguidores: $e');
      followers.value = [];
    } finally {
      isLoadingFollowers.value = false;
    }
  }

  Future<void> loadFollowing() async {
    try {
      isLoadingFollowing.value = true;
      
      final userId = await authService.getUsuarioId();
      
      if (userId == null) {
        throw Exception('No hay sesión activa');
      }

      final followingList = await getFollowingByUserUsecase.execute(userId);
      following.value = followingList;
      
    } catch (e) {
      print('Error al cargar seguidos: $e');
      following.value = [];
    } finally {
      isLoadingFollowing.value = false;
    }
  }

  Future<void> refreshFollowStatus() async {
    await loadFollowStatus();
  }

  void incrementFollowing() {
    if (followStatus.value != null) {
      followStatus.value = FollowStatusEntity(
        totalFollowers: followStatus.value!.totalFollowers,
        totalFollowing: followStatus.value!.totalFollowing + 1,
      );
    }
  }

  void decrementFollowing() {
    if (followStatus.value != null && followStatus.value!.totalFollowing > 0) {
      followStatus.value = FollowStatusEntity(
        totalFollowers: followStatus.value!.totalFollowers,
        totalFollowing: followStatus.value!.totalFollowing - 1,
      );
    }
  }

  void updateFollowers(int newCount) {
    if (followStatus.value != null) {
      followStatus.value = FollowStatusEntity(
        totalFollowers: newCount,
        totalFollowing: followStatus.value!.totalFollowing,
      );
    }
  }
}