import 'package:gerena/features/marketplace/domain/entities/medications/medications_entity.dart';
import 'package:gerena/features/marketplace/domain/usecase/searching_for_medications_usecase.dart';
import 'package:get/get.dart';

class GetMedicationsController extends GetxController {
  final SearchingForMedicationsUsecase searchingForMedicationsUsecase;
  
  GetMedicationsController({required this.searchingForMedicationsUsecase});

  // Estado reactivo
  var medications = <MedicationsEntity>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  
  // Categoría actual (nombre de la categoría)
  var currentCategoryName = ''.obs;
  
  // Búsqueda
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Obtener argumentos de navegación
    final args = Get.arguments;
    if (args != null) {
      currentCategoryName.value = args['categoryName'] ?? 'Categoría';
    }
    
    // Cargar medicamentos de la categoría con búsqueda vacía
    if (currentCategoryName.isNotEmpty) {
      fetchMedicationsByCategory(currentCategoryName.value);
    }
  }

  // Buscar medicamentos por categoría
  // category = categoryName
  // search = búsqueda (vacío por defecto)
  Future<void> fetchMedicationsByCategory(String categoryName, {String search = ''}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Llama al usecase: execute(category, busqueda)
      final result = await searchingForMedicationsUsecase.execute(categoryName, search);
      medications.value = result;
      
    } catch (e) {
      errorMessage.value = 'Error al cargar productos: $e';
      print('Error en fetchMedicationsByCategory: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Buscar con texto
  void searchMedications(String query) {
    searchQuery.value = query;
    fetchMedicationsByCategory(currentCategoryName.value, search: query);
  }

  // Reintentar carga
  void retryFetch() {
    fetchMedicationsByCategory(currentCategoryName.value, search: searchQuery.value);
  }

  // Limpiar búsqueda
  void clearSearch() {
    searchQuery.value = '';
    fetchMedicationsByCategory(currentCategoryName.value);
  }
}