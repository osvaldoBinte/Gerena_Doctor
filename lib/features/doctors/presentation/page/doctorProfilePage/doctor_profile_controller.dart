
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/doctorprocedures/domain/entities/getprocedures/get_procedures_entity.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/get_procedures_by_doctor_usecase.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/get_procedures_usecase.dart';
import 'package:gerena/features/doctors/domain/entities/finddoctors/docotor_by_id_entity.dart';
import 'package:gerena/features/doctors/domain/usecase/fetch_doctor_by_id_usecase.dart';
import 'package:gerena/features/followers/presentation/page/follower_user_controller.dart';
import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/domain/usecase/get_post_doctor_usecase.dart';
import 'package:gerena/movil/home/start_controller.dart';
import 'package:get/get.dart';

class DoctorProfileController extends GetxController {
  final GetProceduresByDoctorUsecase getProceduresByDoctorUsecase;
  final GetPostDoctorUsecase getPostDoctorUsecase;
  final FetchDoctorByIdUsecase fetchDoctorByIdUsecase;
  
  DoctorProfileController({
    required this.getProceduresByDoctorUsecase,
    required this.getPostDoctorUsecase,
    required this.fetchDoctorByIdUsecase,
  });
  
  // ÚNICA FUENTE DE VERDAD: la entidad completa del doctor
  final Rx<DocotorByIdEntity?> doctorEntity = Rx<DocotorByIdEntity?>(null);
  
  final RxList<GetProceduresEntity> procedures = <GetProceduresEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Getters que SOLO usan doctorEntity
  int? get doctorId => doctorEntity.value?.userId;
  String get doctorName => doctorEntity.value?.nombreCompleto ?? 'Doctor no seleccionado';
  String get doctorSpecialty => doctorEntity.value?.especialidad ?? '';
  String get doctorLocation => doctorEntity.value?.direccion ?? '';
  String get doctorProfileImage => doctorEntity.value?.foto ?? '';
  double get doctorRating => doctorEntity.value?.calificacion ?? 0.0;
  String get doctorLicense => doctorEntity.value?.numeroLicencia ?? '';
  String get doctorPhone => doctorEntity.value?.telefono ?? '';
  String get doctorBio => doctorEntity.value?.biografia ?? '';
  
  // Redes sociales
  String get linkedInUrl => doctorEntity.value?.linkedIn ?? '';
  String get facebookUrl => doctorEntity.value?.facebook ?? '';
  String get xUrl => doctorEntity.value?.x ?? '';
  String get instagramUrl => doctorEntity.value?.instagram ?? '';

  final RxList<PublicationEntity> reviews = <PublicationEntity>[].obs;
  final RxBool isLoadingReviews = false.obs;
  final RxString errorMessageReviews = ''.obs;

  FollowerUserController get followerController => Get.find<FollowerUserController>();

  @override
  void onInit() {
    super.onInit();
    loadDoctorData();
    
    // Escuchar cambios en doctorEntity (no en currentDoctorId)
    ever(doctorEntity, (entity) {
      if (entity != null) {
        print('🔄 Doctor cargado: ${entity.nombreCompleto}');
        // Cargar datos relacionados
        loadProcedures();
        loadReviews();
        loadFollowStatus();
      }
    });
  }

  // Este método ahora extrae el ID y carga la entidad completa
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

  // ============ MÉTODO GENERAL DE RETRY ============

  Future<void> retryLoad() async {
     loadDoctorData();
  }
}