import 'package:gerena/features/marketplace/domain/entities/medications/medications_entity.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_medicine_by_id_usecase.dart';
import 'package:get/get.dart';
class ProductDetailController extends GetxController {
  final GetMedicineByIdUsecase getMedicineByIdUsecase;
  
  ProductDetailController({required this.getMedicineByIdUsecase});

  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  
  Rx<MedicationsEntity?> medication = Rx<MedicationsEntity?>(null);

  @override
  void onInit() {
    super.onInit();
    // Obtener el ID del medicamento de los argumentos
    final arguments = Get.arguments;
    
    int? medicineId;
    
    // Manejar diferentes tipos de argumentos
    if (arguments is int) {
      medicineId = arguments;
    } else if (arguments is Map<String, dynamic>) {
      medicineId = arguments['id'] as int?;
    } else if (arguments is String) {
      medicineId = int.tryParse(arguments);
    }
    
    if (medicineId != null && medicineId > 0) {
      loadMedicineData(medicineId);
    } else {
      hasError.value = true;
      errorMessage.value = 'ID de producto inválido';
      isLoading.value = false;
    }
  }

  Future<void> loadMedicineData(int id) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      final result = await getMedicineByIdUsecase.execute(id);
      medication.value = result;
      
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error al cargar el producto: ${e.toString()}';
      print('Error loading medicine: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void refreshData() {
    if (medication.value != null) {
      loadMedicineData(medication.value!.id);
    }
  }
}