import 'package:gerena/common/controller/mediacontroller/media_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PromotionController extends GetxController {
  
  final RxBool isPublished = false.obs;
  final RxString description = ''.obs;
  
  late TextEditingController descriptionController;
  
  late MediaController mediaController;
  
  @override
  void onInit() {
    super.onInit();
    descriptionController = TextEditingController();
    
    if (Get.isRegistered<MediaController>()) {
      mediaController = Get.find<MediaController>();
    } else {
      mediaController = Get.put(MediaController());
    }
    
    descriptionController.addListener(() {
      description.value = descriptionController.text;
    });
  }
  
  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
  
  void publishPromotion() {
    if (description.value.isEmpty && !mediaController.hasFiles) {
      Get.snackbar(
        'Error',
        'Agrega una descripción o selecciona archivos multimedia',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
      );
      return;
    }
    
    isPublished.value = true;
    
    Get.snackbar(
      'Éxito',
      'Promoción publicada correctamente',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.primaryColor.withOpacity(0.1),
      colorText: Get.theme.primaryColor,
    );
    
    print('Promoción publicada:');
    print('Descripción: ${description.value}');
    print('Imágenes: ${mediaController.selectedImages.length}');
    print('Videos: ${mediaController.selectedVideos.length}');
  }
  
  void editPromotion() {
    isPublished.value = false;
  }
  
  void clearPromotion() {
    isPublished.value = false;
    description.value = '';
    descriptionController.clear();
    mediaController.clearAllFiles();
  }
  bool canPublish() {
    return description.value.isNotEmpty || mediaController.hasFiles;
  }
}