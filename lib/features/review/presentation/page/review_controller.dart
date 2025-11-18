import 'package:gerena/features/review/domain/entities/my_review_entity.dart';
import 'package:gerena/features/review/domain/usecase/my_review_usecase.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  final MyReviewUsecase myReviewUsecase;
  
  ReviewController({required this.myReviewUsecase});
  
  // Observable para las reviews
  final RxList<MyReviewEntity> reviews = <MyReviewEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadReviews();
  }

  Future<void> loadReviews() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final result = await myReviewUsecase.execute();
      reviews.value = result;
      
    } catch (e) {
      errorMessage.value = 'Error al cargar las reseñas: $e';
      print('Error en loadReviews: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshReviews() async {
    await loadReviews();
  }
}