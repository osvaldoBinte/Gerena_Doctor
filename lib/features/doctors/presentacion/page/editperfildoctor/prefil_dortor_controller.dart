import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/features/doctors/domain/entities/doctor/doctor_entity.dart';
import 'package:gerena/features/doctors/domain/usecase/doctor_profile_usecase.dart';
import 'package:get/get.dart';

class PrefilDortorController extends GetxController {
  final RxBool isLoading = true.obs;
  final Rx<DoctorEntity?> doctorProfile = Rx<DoctorEntity?>(null);
  
  final DoctorProfileUsecase doctorProfileUsecase;
  
  PrefilDortorController({required this.doctorProfileUsecase});
  
  @override
  void onInit() async {
    super.onInit();
    await loadProfile();
  }
  
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final profile = await doctorProfileUsecase.execute();
      doctorProfile.value = profile;
      print('✅ Perfil cargado: ${profile.nombreCompleto}');
    } catch (e) {
      print('❌ Error al cargar perfil: $e');
      Get.snackbar('Error', 'No se pudo cargar el perfil');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> updateProfile({
    String? nombreCompleto,
    String? telefono,
    String? direccion,
    String? biografia,
  }) async {
    // Implementar actualización del perfil
  }
}