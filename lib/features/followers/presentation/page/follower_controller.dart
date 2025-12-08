import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/features/followers/domain/entities/follow_status_entity.dart';
import 'package:gerena/features/followers/domain/usecase/get_follow_status_usecase.dart';
import 'package:get/get.dart';

class FollowerController extends GetxController {
  final GetFollowStatusUsecase getFollowStatusUsecase;
  
  FollowerController({required this.getFollowStatusUsecase});
  
  final AuthService authService = AuthService();

  // Estados observables
  final Rx<FollowStatusEntity?> followStatus = Rx<FollowStatusEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Getters para acceso fácil
  int get totalFollowers => followStatus.value?.totalFollowers ?? 0;
  int get totalFollowing => followStatus.value?.totalFollowing ?? 0;

  @override
  void onInit() {
    super.onInit();
    loadFollowStatus();
  }

  /// Cargar el estado de seguidores y seguidos
  Future<void> loadFollowStatus() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Obtener el ID del usuario actual
      final userId = await authService.getUsuarioId();
      
      if (userId == null) {
        throw Exception('No hay sesión activa. El usuario debe iniciar sesión.');
      }

      // Ejecutar el caso de uso
      final status = await getFollowStatusUsecase.execute(userId);

      // Si el caso de uso retorna directamente un FollowStatusEntity
      if (status != null) {
        // Éxito
        followStatus.value = status;
        hasError.value = false;
      } else {
        // Manejar caso nulo o inesperado
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

  /// Refrescar el estado de seguidores
  Future<void> refreshFollowStatus() async {
    await loadFollowStatus();
  }

  /// Incrementar contador de seguidores (útil después de seguir a alguien)
  void incrementFollowing() {
    if (followStatus.value != null) {
      followStatus.value = FollowStatusEntity(
        totalFollowers: followStatus.value!.totalFollowers,
        totalFollowing: followStatus.value!.totalFollowing + 1,
      );
    }
  }

  /// Decrementar contador de seguidos (útil después de dejar de seguir)
  void decrementFollowing() {
    if (followStatus.value != null && followStatus.value!.totalFollowing > 0) {
      followStatus.value = FollowStatusEntity(
        totalFollowers: followStatus.value!.totalFollowers,
        totalFollowing: followStatus.value!.totalFollowing - 1,
      );
    }
  }

  /// Actualizar contador de seguidores (útil cuando alguien te sigue/deja de seguir)
  void updateFollowers(int newCount) {
    if (followStatus.value != null) {
      followStatus.value = FollowStatusEntity(
        totalFollowers: newCount,
        totalFollowing: followStatus.value!.totalFollowing,
      );
    }
  }
}