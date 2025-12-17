
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/doctorprocedures/domain/entities/getprocedures/get_procedures_entity.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/get_procedures_by_doctor_usecase.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/get_procedures_usecase.dart';
import 'package:gerena/features/doctors/domain/entities/finddoctors/docotor_by_id_entity.dart';
import 'package:gerena/features/doctors/domain/usecase/fetch_doctor_by_id_usecase.dart';
import 'package:gerena/features/followers/presentation/page/follower_user_controller.dart';
import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/domain/usecase/get_post_doctor_usecase.dart';
import 'package:gerena/features/publications/domain/usecase/get_posts_user_usecase.dart';
import 'package:gerena/movil/home/start_controller.dart';
import 'package:get/get.dart';
class DoctorProfilebyidController extends GetxController {
  final GetProceduresByDoctorUsecase getProceduresByDoctorUsecase;
  final GetPostDoctorUsecase getPostDoctorUsecase;
  final FetchDoctorByIdUsecase fetchDoctorByIdUsecase;
  final GetPostsUserUsecase getPostsUserUsecase;
  
  DoctorProfilebyidController({
    required this.getProceduresByDoctorUsecase,
    required this.getPostDoctorUsecase,
    required this.fetchDoctorByIdUsecase,
    required this.getPostsUserUsecase
  });
  
  final Rx<DocotorByIdEntity?> doctorEntity = Rx<DocotorByIdEntity?>(null);
  final RxList<GetProceduresEntity> procedures = <GetProceduresEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Posts de usuario (publicaciones del doctor)
  final RxList<PublicationEntity> userPosts = <PublicationEntity>[].obs;
  final RxBool isLoadingUserPosts = false.obs;
  final RxString errorMessageUserPosts = ''.obs;

  // Reviews del doctor (reseñas que otros hacen del doctor)
  final RxList<PublicationEntity> reviews = <PublicationEntity>[].obs;
  final RxBool isLoadingReviews = false.obs;
  final RxString errorMessageReviews = ''.obs;

  // NUEVO: Lista combinada de ambos
  final RxList<PublicationEntity> allPublications = <PublicationEntity>[].obs;
  final RxBool isLoadingAllPublications = false.obs;
  final RxString errorMessageAllPublications = ''.obs;

  // Getters
  int? get doctorId => doctorEntity.value?.userId;
  String get doctorName => doctorEntity.value?.nombreCompleto ?? 'Doctor no seleccionado';
  String get doctorSpecialty => doctorEntity.value?.especialidad ?? '';
  String get doctorLocation => doctorEntity.value?.direccion ?? '';
  String get doctorProfileImage => doctorEntity.value?.foto ?? '';
  double get doctorRating => doctorEntity.value?.calificacion ?? 0.0;
  String get doctorLicense => doctorEntity.value?.numeroLicencia ?? '';
  String get doctorPhone => doctorEntity.value?.telefono ?? '';
  String get doctorBio => doctorEntity.value?.biografia ?? '';
  
  String get linkedInUrl => doctorEntity.value?.linkedIn ?? '';
  String get facebookUrl => doctorEntity.value?.facebook ?? '';
  String get xUrl => doctorEntity.value?.x ?? '';
  String get instagramUrl => doctorEntity.value?.instagram ?? '';

  FollowerUserController get followerController => Get.find<FollowerUserController>();

  @override
  void onInit() {
    super.onInit();
    loadDoctorData();
    
    ever(doctorEntity, (entity) {
      if (entity != null) {
        print('🔄 Doctor cargado: ${entity.nombreCompleto}');
        loadProcedures();
        loadAllPublications(); // CAMBIADO: Ahora carga todo junto
        loadFollowStatus();
      }
    });
  }

  void loadDoctorData() async {
    try {
      final startController = Get.find<StartController>();
      final data = startController.currentDoctorData;
      
      if (data == null) {
        print('⚠️ No hay datos de doctor en StartController');
        errorMessage.value = 'No se encontró información del doctor';
        return;
      }

      final userId = data['userId'] as int?;
      
      if (userId == null) {
        print('❌ No se encontró userId en los datos del doctor');
        errorMessage.value = 'ID del doctor no disponible';
        return;
      }

      print('🔍 Cargando doctor con ID: $userId');
      await loadDoctorById(userId);
      
    } catch (e) {
      print('❌ Error al cargar doctor: $e');
      errorMessage.value = 'Error al cargar información del doctor';
    }
  }

  Future<void> loadDoctorById(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      print('🔍 Obteniendo información completa del doctor ID: $id');
      final result = await fetchDoctorByIdUsecase.execute(id);
      
      doctorEntity.value = result;
      print('✅ Doctor cargado: ${result.nombreCompleto}');
      
    } catch (e) {
      errorMessage.value = 'Error al cargar información del doctor: $e';
      print('❌ Error en loadDoctorById: $e');
      showErrorSnackbar('No se pudo cargar la información del doctor');
    } finally {
      isLoading.value = false;
    }
  }

  // NUEVO: Método para cargar AMBOS tipos de publicaciones
  Future<void> loadAllPublications() async {
    try {
      isLoadingAllPublications.value = true;
      errorMessageAllPublications.value = '';
      
      final id = doctorId;
      if (id == null) {
        throw Exception('ID del doctor no disponible');
      }
      
      print('🔍 Cargando todas las publicaciones del doctor ID: $id');
      
      // Cargar ambos en paralelo
      final results = await Future.wait([
        getPostsUserUsecase.execute(id),      // Publicaciones del doctor
        getPostDoctorUsecase.execute(id),     // Reseñas del doctor
      ]);
      
      userPosts.value = results[0];
      reviews.value = results[1];
      
      // Combinar ambas listas
      final combined = <PublicationEntity>[];
      combined.addAll(results[0]); // Publicaciones del doctor
      combined.addAll(results[1]); // Reseñas del doctor
      
      // Ordenar por fecha (más recientes primero)
      combined.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      allPublications.value = combined;
      
      print('✅ Publicaciones cargadas: ${userPosts.length} posts + ${reviews.length} reseñas = ${allPublications.length} total');
      
    } catch (e) {
      errorMessageAllPublications.value = 'Error al cargar las publicaciones: $e';
      print('❌ Error en loadAllPublications: $e');
      showErrorSnackbar('No se pudieron cargar las publicaciones');
    } finally {
      isLoadingAllPublications.value = false;
    }
  }

  Future<void> refreshAllPublications() async {
    if (doctorId != null) {
      await loadAllPublications();
    }
  }

  // Mantener métodos individuales por si los necesitas
  Future<void> loadUserPosts() async {
    try {
      isLoadingUserPosts.value = true;
      errorMessageUserPosts.value = '';
      
      final id = doctorId;
      if (id == null) {
        throw Exception('ID del doctor no disponible');
      }
      
      print('🔍 Cargando posts del usuario ID: $id');
      final result = await getPostsUserUsecase.execute(id);
      userPosts.value = result;
      print('✅ Posts del usuario cargados: ${userPosts.length}');
      
    } catch (e) {
      errorMessageUserPosts.value = 'Error al cargar las publicaciones: $e';
      print('❌ Error en loadUserPosts: $e');
      showErrorSnackbar('No se pudieron cargar las publicaciones');
    } finally {
      isLoadingUserPosts.value = false;
    }
  }

  Future<void> loadReviews() async {
    try {
      isLoadingReviews.value = true;
      errorMessageReviews.value = '';
      
      final id = doctorId;
      if (id == null) {
        throw Exception('ID del doctor no disponible');
      }
      
      print('🔍 Cargando reseñas para doctor ID: $id');
      final result = await getPostDoctorUsecase.execute(id);
      reviews.value = result;
      print('✅ Reseñas cargadas: ${reviews.length}');
      
    } catch (e) {
      errorMessageReviews.value = 'Error al cargar las reseñas: $e';
      print('❌ Error en loadReviews: $e');
      showErrorSnackbar('No se pudieron cargar las reseñas');
    } finally {
      isLoadingReviews.value = false;
    }
  }

  Future<void> refreshReviews() async {
    if (doctorId != null) {
      await loadReviews();
    }
  }

  Future<void> refreshUserPosts() async {
    if (doctorId != null) {
      await loadUserPosts();
    }
  }

  Future<void> loadProcedures() async {
    try {
      final id = doctorId;
      if (id == null) {
        throw Exception('ID del doctor no disponible');
      }
      
      print('🔍 Cargando procedimientos para doctor ID: $id');
      final List<GetProceduresEntity> result = await getProceduresByDoctorUsecase.execute(id);
      
      procedures.value = result;
      print('✅ Procedimientos cargados: ${procedures.length}');
      
    } catch (e) {
      print('❌ Error en loadProcedures: $e');
      showErrorSnackbar('No se pudieron cargar los procedimientos');
    }
  }

  // ============ MÉTODOS DE SEGUIMIENTO ============

  Future<void> loadFollowStatus() async {
    final id = doctorId;
    if (id != null) {
      await followerController.loadFollowStatus(id);
    }
  }

  Future<void> toggleFollow() async {
    final id = doctorId;
    if (id != null) {
      await followerController.toggleFollow(id, userName: doctorName);
    }
  }

  bool get isFollowing {
    final id = doctorId;
    return id != null ? followerController.isFollowing(id) : false;
  }

  int get totalFollowers {
    final id = doctorId;
    return id != null ? followerController.totalFollowers(id) : 0;
  }

  int get totalFollowing {
    final id = doctorId;
    return id != null ? followerController.totalFollowing(id) : 0;
  }

  bool get isLoadingFollow {
    final id = doctorId;
    return id != null ? followerController.isLoadingFollowFor(id) : false;
  }

  Future<void> retryLoad() async {
    loadDoctorData();
  }
}