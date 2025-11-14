import 'package:flutter/material.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/marketplace/domain/entities/medications/medications_entity.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_medicine_by_id_usecase.dart';
import 'package:get/get.dart';

class GetMedicationsByIdController extends GetxController {
  final GetMedicineByIdUsecase getMedicineByIdUsecase;
  
  final RxBool isLoading = true.obs;
  final Rx<MedicationsEntity?> medication = Rx<MedicationsEntity?>(null);
  
  GetMedicationsByIdController({required this.getMedicineByIdUsecase, });
  
  Future<void> loadMedicationById(int id) async {
    try {
      isLoading.value = true;
      final result = await getMedicineByIdUsecase.execute(id);
      medication.value = result;
    } catch (e) {
      showErrorSnackbar('No se pudo cargar el producto');
    } finally {
      isLoading.value = false;
    }
  }
  
  @override
  void onClose() {
    medication.value = null;
    super.onClose();
  }
}