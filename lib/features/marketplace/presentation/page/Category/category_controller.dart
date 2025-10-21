import 'package:gerena/features/marketplace/domain/entities/categories/categories_entity.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_category_usecase.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final GetCategoryUsecase getCategoryUsecase;
  
  CategoryController({required this.getCategoryUsecase});

  // Estado reactivo
  var categories = <CategoriesEntity>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final result = await getCategoryUsecase.execute();
      categories.value = result;
      
    } catch (e) {
      errorMessage.value = 'Error al cargar categorías: $e';
      print('Error en fetchCategories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void retryFetch() {
    fetchCategories();
  }
}