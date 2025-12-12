
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/followers/domain/entities/follow_status_entity.dart';
import 'package:gerena/features/followers/domain/usecase/follow_user_usecase.dart';
import 'package:gerena/features/followers/domain/usecase/get_follow_status_usecase.dart';
import 'package:gerena/features/followers/domain/usecase/unfollow_user_usecase.dart';
import 'package:get/get.dart';

class FollowerUserController extends GetxController {
  final FollowUserUsecase followUserUsecase;
  final UnfollowUserUsecase unfollowUserUsecase;
  final GetFollowStatusUsecase getFollowStatusUsecase;

  FollowerUserController({
    required this.followUserUsecase,
    required this.unfollowUserUsecase,
    required this.getFollowStatusUsecase,
  });

  // Estado de seguimiento por usuario (Map con userId como key)
  final RxMap<int, FollowStatusEntity> followStatusMap = <int, FollowStatusEntity>{}.obs;
  final RxBool isLoadingFollow = false.obs;
  final RxInt currentUserId = 0.obs;

  // Getters para el usuario actual
  bool isFollowing(int userId) => followStatusMap[userId]?.isFollowing ?? false;
  int totalFollowers(int userId) => followStatusMap[userId]?.totalFollowers ?? 0;
  int totalFollowing(int userId) => followStatusMap[userId]?.totalFollowing ?? 0;

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
  }

  /// Limpiar todos los estados de seguimiento
  void clearAllFollowStatus() {
    followStatusMap.clear();
  }

  @override
  void onClose() {
    followStatusMap.clear();
    super.onClose();
  }
}