
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/followers/presentation/page/follower_user_controller.dart';
import 'package:gerena/features/publications/domain/entities/myposts/image_entity.dart';
import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/domain/usecase/get_posts_user_usecase.dart';
import 'package:gerena/features/user/domain/entities/getuser/get_user_entity.dart';
import 'package:gerena/features/user/domain/usecase/get_user_details_by_id_usecase.dart';
import 'package:gerena/movil/home/start_controller.dart';
import 'package:get/get.dart';

class GetUserByIdController extends GetxController {
  final GetUserDetailsByIdUsecase getUserDetailsByIdUsecase;
  final GetPostsUserUsecase getPostsUserUsecase;

  GetUserByIdController({
    required this.getUserDetailsByIdUsecase,
    required this.getPostsUserUsecase,
  });

  // ÚNICA FUENTE DE VERDAD: la entidad completa del usuario
  final Rx<GetUserEntity?> userEntity = Rx<GetUserEntity?>(null);
  
  final RxList<PublicationEntity> userPosts = <PublicationEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingPosts = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString errorMessagePosts = ''.obs;

  // Getters que SOLO usan userEntity
  int? get userId => userEntity.value?.userId;
  String get userName => userEntity.value?.nombreCompleto ?? 'Usuario no encontrado';
  String get userUsername => userEntity.value?.username ?? 'username';
  String get userEmail => userEntity.value?.email ?? '';
  String get userPhone => userEntity.value?.telefono ?? '';
  String get userAddress => userEntity.value?.direccion ?? '';
  String get userCity => userEntity.value?.ciudad ?? '';
  String get userProfileImage => userEntity.value?.foto ?? '';
  String get userBio => userEntity.value?.resumenMedico ?? '';
  int? get userAge => userEntity.value?.edad;
  String get userGender => userEntity.value?.genero ?? '';
  String get userBloodType => userEntity.value?.tipoSangre ?? '';

  FollowerUserController get followerController => Get.find<FollowerUserController>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    
    // Escuchar cambios en userEntity
    ever(userEntity, (entity) {
      if (entity != null) {
        print('🔄 Usuario cargado: ${entity.nombreCompleto}');
        // Cargar datos relacionados
        loadUserPosts();
        loadFollowStatus();
      }
    });
  }

  // Este método extrae el ID y carga la entidad completa
  void loadUserData() async {
    try {
      final startController = Get.find<StartController>();
      final data = startController.currentUserData;
      
      if (data == null) {
        print('⚠️ No hay datos de usuario en StartController');
        errorMessage.value = 'No se encontró información del usuario';
        return;
      }

      final userId = data['userId'] as int?;
      
      if (userId == null) {
        print('❌ No se encontró userId en los datos');
        errorMessage.value = 'ID del usuario no disponible';
        return;
      }

      print('🔍 Cargando usuario con ID: $userId');
      await loadUserById(userId);
      
    } catch (e) {
      print('❌ Error al cargar usuario: $e');
      errorMessage.value = 'Error al cargar información del usuario';
    }
  }

  Future<void> loadUserById(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      print('🔍 Obteniendo información completa del usuario ID: $id');
      final result = await getUserDetailsByIdUsecase.execute(id);
      
      userEntity.value = result;
      print('✅ Usuario cargado: ${result.nombreCompleto}');
      
    } catch (e) {
      errorMessage.value = 'Error al cargar información del usuario: $e';
      print('❌ Error en loadUserById: $e');
      showErrorSnackbar('No se pudo cargar la información del usuario');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadUserPosts() async {
    try {
      isLoadingPosts.value = true;
      errorMessagePosts.value = '';
      
      final id = userId;
      if (id == null) {
        throw Exception('ID del usuario no disponible');
      }
      
      print('🔍 Cargando publicaciones del usuario ID: $id');
      final result = await getPostsUserUsecase.execute(id);
      userPosts.value = result;
      print('✅ Publicaciones cargadas: ${userPosts.length}');
      
    } catch (e) {
      errorMessagePosts.value = 'Error al cargar las publicaciones: $e';
      print('❌ Error en loadUserPosts: $e');
      showErrorSnackbar('No se pudieron cargar las publicaciones');
    } finally {
      isLoadingPosts.value = false;
    }
  }

  Future<void> refreshUserPosts() async {
    if (userId != null) {
      await loadUserPosts();
    }
  }

  // ============ MÉTODOS DE SEGUIMIENTO ============

  Future<void> loadFollowStatus() async {
    final id = userId;
    if (id != null) {
      await followerController.loadFollowStatus(id);
    }
  }

  Future<void> toggleFollow() async {
    final id = userId;
    if (id != null) {
      await followerController.toggleFollow(id, userName: userName);
    }
  }

  bool get isFollowing {
    final id = userId;
    return id != null ? followerController.isFollowing(id) : false;
  }

  int get totalFollowers {
    final id = userId;
    return id != null ? followerController.totalFollowers(id) : 0;
  }

  int get totalFollowing {
    final id = userId;
    return id != null ? followerController.totalFollowing(id) : 0;
  }

  bool get isLoadingFollow {
    final id = userId;
    return id != null ? followerController.isLoadingFollowFor(id) : false;
  }

  // Contador de reseñas
  int get reviewsCount => userPosts.where((post) => post.isReview).length;

  // ============ MÉTODO GENERAL DE RETRY ============

  Future<void> retryLoad() async {
     loadUserData();
  }

  // Formatear fecha
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Hace un momento';
        }
        return 'Hace ${difference.inMinutes} min';
      }
      return 'Hace ${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Hace ${weeks} ${weeks == 1 ? 'semana' : 'semanas'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Hace ${months} ${months == 1 ? 'mes' : 'meses'}';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'Hace ${years} ${years == 1 ? 'año' : 'años'}';
    }
  }

  // Obtener imágenes ordenadas
  List<String> getOrderedImages(PublicationEntity post) {
    final sortedImages = List<ImageEntity>.from(post.images)
      ..sort((a, b) => a.order.compareTo(b.order));
    return sortedImages.map((img) => img.imageUrl).toList();
  }
}