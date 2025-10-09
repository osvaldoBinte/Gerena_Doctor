import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/features/doctors/domain/usecase/doctor_profile_usecase.dart';
import 'package:get/get.dart';
class SplashController extends GetxController {
  final RxBool isLoading = true.obs;
  
  final DoctorProfileUsecase doctorProfileUsecase;
  
  SplashController({required this.doctorProfileUsecase});
  
  @override
  void onInit()  async{
    super.onInit();
   await checkUserSession();
  }
  
  Future<void> checkUserSession() async {
    try {
     
      await doctorProfileUsecase.execute();
       if (GetPlatform.isMobile) {
        Get.offAllNamed(RoutesNames.homePage, arguments: 0);
      } else {
        Get.toNamed(RoutesNames.dashboardSPage);
      };

    } catch (e) {
      Get.offAllNamed(RoutesNames.loginPage);
    } finally {
      isLoading.value = false;
    }
  }
}