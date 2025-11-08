import 'package:gerena/features/banners/domain/entity/banners_entity.dart';
import 'package:gerena/features/banners/domain/usecase/get_banners_usecase.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  final GetBannersUsecase getBannersUsecase;
  
  BannerController({required this.getBannersUsecase});

  // Observable list de banners
  final RxList<BannersEntity> banners = <BannersEntity>[].obs;
  
  // Loading state
  final RxBool isLoading = false.obs;
  
  // Error state
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadBanners();
  }

  Future<void> loadBanners() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final result = await getBannersUsecase.execute();
      banners.value = result;
      
    } catch (e) {
      errorMessage.value = 'Error al cargar banners: $e';
      print('Error loading banners: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Método para refrescar
  Future<void> refreshBanners() async {
    await loadBanners();
  }
}