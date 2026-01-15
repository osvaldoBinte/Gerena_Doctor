
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/followers/domain/entities/follow_status_entity.dart';
import 'package:gerena/features/followers/domain/entities/follow_user_entity.dart';
import 'package:gerena/features/followers/domain/usecase/follow_user_usecase.dart';
import 'package:gerena/features/followers/domain/usecase/get_follow_status_usecase.dart';
import 'package:gerena/features/followers/domain/usecase/get_following_by_user_usecase.dart';
import 'package:gerena/features/followers/domain/usecase/get_user_followers_usecase.dart';
import 'package:gerena/features/followers/domain/usecase/unfollow_user_usecase.dart';
import 'package:get/get.dart';

class FollowerUserController extends GetxController {
  final FollowUserUsecase followUserUsecase;
  final UnfollowUserUsecase unfollowUserUsecase;
  final GetFollowStatusUsecase getFollowStatusUsecase;
  final GetUserFollowersUsecase getUserFollowersUsecase;
  final GetFollowingByUserUsecase getFollowingByUserUsecase;

  FollowerUserController({
    required this.followUserUsecase,
    required this.unfollowUserUsecase,
    required this.getFollowStatusUsecase,
    required this.getUserFollowersUsecase,
    required this.getFollowingByUserUsecase,
  });

  // Estados de seguimiento por usuario
  final RxMap<int, FollowStatusEntity> followStatusMap = <int, FollowStatusEntity>{}.obs;
  final RxBool isLoadingFollow = false.obs;
  final RxInt currentUserId = 0.obs;

  // Listas de seguidores y seguidos por usuario
  final RxMap<int, List<FollowUserEntity>> followersMap = <int, List<FollowUserEntity>>{}.obs;
  final RxMap<int, List<FollowUserEntity>> followingMap = <int, List<FollowUserEntity>>{}.obs;
  final RxMap<int, bool> isLoadingFollowersMap = <int, bool>{}.obs;
  final RxMap<int, bool> isLoadingFollowingMap = <int, bool>{}.obs;

  // Getters para el usuario actual
  bool isFollowing(int userId) => followStatusMap[userId]?.isFollowing ?? false;
  int totalFollowers(int userId) => followStatusMap[userId]?.totalFollowers ?? 0;
  int totalFollowing(int userId) => followStatusMap[userId]?.totalFollowing ?? 0;

  // Getters para listas
  List<FollowUserEntity> getFollowers(int userId) => followersMap[userId] ?? [];
  List<FollowUserEntity> getFollowing(int userId) => followingMap[userId] ?? [];
  bool isLoadingFollowers(int userId) => isLoadingFollowersMap[userId] ?? false;
  bool isLoadingFollowing(int userId) => isLoadingFollowingMap[userId] ?? false;

  /// Carga el estado de seguimiento de un usuario específico
  Future<void> loadFollowStatus(int userId) async {
    try {
      print('🔍 Cargando estado de seguimiento para usuario ID: $userId');
      
      final status = await getFollowStatusUsecase.execute(userId);
      
      followStatusMap[userId] = status;
      
      print('✅ Estado de seguimiento cargado para usuario $userId:');
      print('   - Siguiendo: ${status.isFollowing}');
      print('   - Seguidores: ${status.totalFollowers}');
      print('   - Siguiendo: ${status.totalFollowing}');
      
    } catch (e) {
      print('❌ Error al cargar estado de seguimiento para usuario $userId: $e');
      // Inicializar con valores por defecto si hay error
      followStatusMap[userId] = FollowStatusEntity(
        isFollowing: false,
        totalFollowers: 0,
        totalFollowing: 0,
      );
    }
  }

  /// Cargar lista de seguidores de un usuario
  Future<void> loadFollowers(int userId) async {
    try {
      isLoadingFollowersMap[userId] = true;
      isLoadingFollowersMap.refresh();
      
      print('🔍 Cargando seguidores del usuario ID: $userId');
      final result = await getUserFollowersUsecase.execute(userId);
      
      followersMap[userId] = result;
      followersMap.refresh();
      
      print('✅ Seguidores cargados para usuario $userId: ${result.length}');
      
    } catch (e) {
      print('❌ Error al cargar seguidores para usuario $userId: $e');
      followersMap[userId] = [];
      followersMap.refresh();
      showErrorSnackbar('No se pudieron cargar los seguidores');
    } finally {
      isLoadingFollowersMap[userId] = false;
      isLoadingFollowersMap.refresh();
    }
  }

  /// Cargar lista de seguidos de un usuario
  Future<void> loadFollowing(int userId) async {
    try {
      isLoadingFollowingMap[userId] = true;
      isLoadingFollowingMap.refresh();
      
      print('🔍 Cargando seguidos del usuario ID: $userId');
      final result = await getFollowingByUserUsecase.execute(userId);
      
      followingMap[userId] = result;
      followingMap.refresh();
      
      print('✅ Seguidos cargados para usuario $userId: ${result.length}');
      
    } catch (e) {
      print('❌ Error al cargar seguidos para usuario $userId: $e');
      followingMap[userId] = [];
      followingMap.refresh();
      showErrorSnackbar('No se pudieron cargar los seguidos');
    } finally {
      isLoadingFollowingMap[userId] = false;
      isLoadingFollowingMap.refresh();
    }
  }

  /// Toggle de seguir/dejar de seguir a un usuario
  Future<void> toggleFollow(int userId, {String? userName}) async {
    try {
      currentUserId.value = userId;
      isLoadingFollow.value = true;

      final currentStatus = followStatusMap[userId];
      final wasFollowing = currentStatus?.isFollowing ?? false;

      if (wasFollowing) {
        // Dejar de seguir
        print('🔄 Dejando de seguir al usuario ID: $userId');
        
        // Actualización optimista
        followStatusMap[userId] = FollowStatusEntity(
          isFollowing: false,
          totalFollowers: (currentStatus!.totalFollowers - 1).clamp(0, double.infinity).toInt(),
          totalFollowing: currentStatus.totalFollowing,
        );
        
        await unfollowUserUsecase.execute(userId);
        
        showSuccessSnackbar(
          userName != null 
            ? 'Has dejado de seguir a $userName' 
            : 'Has dejado de seguir a este usuario'
        );
        print('✅ Se dejó de seguir correctamente');
        
      } else {
        // Seguir
        print('🔄 Siguiendo al usuario ID: $userId');
        
        // Actualización optimista
        followStatusMap[userId] = FollowStatusEntity(
          isFollowing: true,
          totalFollowers: (currentStatus?.totalFollowers ?? 0) + 1,
          totalFollowing: currentStatus?.totalFollowing ?? 0,
        );
        
        await followUserUsecase.execute(userId);
        
        showSuccessSnackbar(
          userName != null 
            ? 'Ahora sigues a $userName' 
            : 'Ahora sigues a este usuario'
        );
        print('✅ Se siguió correctamente');
      }

      // Actualizar el estado real desde el servidor
      await loadFollowStatus(userId);
      
    } catch (e) {
      print('❌ Error al cambiar estado de seguimiento: $e');
      showErrorSnackbar('Error al actualizar el seguimiento');
      
      // Revertir el cambio optimista
      await loadFollowStatus(userId);
      
    } finally {
      isLoadingFollow.value = false;
      currentUserId.value = 0;
    }
  }

  /// Seguir a un usuario
  Future<void> followUser(int userId, {String? userName}) async {
    if (!isFollowing(userId)) {
      await toggleFollow(userId, userName: userName);
    }
  }

  /// Dejar de seguir a un usuario
  Future<void> unfollowUser(int userId, {String? userName}) async {
    if (isFollowing(userId)) {
      await toggleFollow(userId, userName: userName);
    }
  }

  /// Verificar si se está cargando el seguimiento de un usuario específico
  bool isLoadingFollowFor(int userId) {
    return isLoadingFollow.value && currentUserId.value == userId;
  }

  /// Limpiar el estado de seguimiento de un usuario
  void clearFollowStatus(int userId) {
    followStatusMap.remove(userId);
    followersMap.remove(userId);
    followingMap.remove(userId);
    isLoadingFollowersMap.remove(userId);
    isLoadingFollowingMap.remove(userId);
  }

  /// Limpiar todos los estados de seguimiento
  void clearAllFollowStatus() {
    followStatusMap.clear();
    followersMap.clear();
    followingMap.clear();
    isLoadingFollowersMap.clear();
    isLoadingFollowingMap.clear();
  }

  @override
  void onClose() {
    clearAllFollowStatus();
    super.onClose();
  }
}