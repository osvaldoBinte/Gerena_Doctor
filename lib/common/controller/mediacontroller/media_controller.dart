import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:gerena/common/theme/App_Theme.dart';

class MediaController extends GetxController {
  final RxList<File> selectedImages = <File>[].obs;
  final RxList<File> selectedVideos = <File>[].obs;
  
  final RxBool isLoading = false.obs;
  
  final RxString procedureDescription = ''.obs;
  
  bool get hasImages => selectedImages.isNotEmpty;
  bool get hasVideos => selectedVideos.isNotEmpty;
  bool get hasFiles => hasImages || hasVideos;
  int get totalFiles => selectedImages.length + selectedVideos.length;
  
  Future<void> pickFiles() async {
    try {
      isLoading.value = true;
      
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'heic',
          'mp4', 'mov', 'avi', 'mkv', 'wmv', 'flv', '3gp', 'm4v'
        ],
        allowMultiple: true,
        withData: false, 
      );

      if (result != null && result.files.isNotEmpty) {
        List<File> validFiles = [];
        
        for (PlatformFile file in result.files) {
          if (file.path != null) {
            File fileObject = File(file.path!);
            if (await fileObject.exists()) {
              validFiles.add(fileObject);
            }
          }
        }
        
        if (validFiles.isNotEmpty) {
          await _processSelectedFiles(validFiles);
        } else {
          _showErrorMessage('No se pudieron cargar los archivos seleccionados');
        }
      }
    } on PlatformException catch (e) {
      String errorMessage = _getReadableErrorMessage(e);
      _showErrorMessage(errorMessage);
      print('PlatformException: ${e.code} - ${e.message}');
    } catch (e) {
      _showErrorMessage('Error inesperado: $e');
      print('Error general: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> _processSelectedFiles(List<File> files) async {
    List<File> newImages = [];
    List<File> newVideos = [];
    List<File> invalidFiles = [];
    
    for (File file in files) {
      try {
        String fileName = file.path.split(Platform.pathSeparator).last;
        String extension = fileName.split('.').last.toLowerCase();
        
        int bytes = await file.length();
        double mb = bytes / (1024 * 1024);
        
        if (mb > 100) {
          invalidFiles.add(file);
          continue;
        }
        
        if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'heic'].contains(extension)) {
          newImages.add(file);
        } else if (['mp4', 'mov', 'avi', 'mkv', 'wmv', 'flv', '3gp', 'm4v'].contains(extension)) {
          newVideos.add(file);
        } else {
          invalidFiles.add(file);
        }
      } catch (e) {
        print('Error procesando archivo ${file.path}: $e');
        invalidFiles.add(file);
      }
    }
    
    selectedImages.addAll(newImages);
    selectedVideos.addAll(newVideos);
    
    if (newImages.isNotEmpty || newVideos.isNotEmpty) {
      String message = 'Agregados: ';
      if (newImages.isNotEmpty) {
        message += '${newImages.length} imagen(es)';
      }
      if (newVideos.isNotEmpty) {
        if (newImages.isNotEmpty) message += ', ';
        message += '${newVideos.length} video(s)';
      }
    }
    
    if (invalidFiles.isNotEmpty) {
      _showWarningMessage(
        '${invalidFiles.length} archivo(s) omitidos (muy grandes o formato no soportado)'
      );
    }
  }
  
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }
  
  void removeVideo(int index) {
    if (index >= 0 && index < selectedVideos.length) {
      selectedVideos.removeAt(index);
    }
  }
  
  void clearAllFiles() {
    selectedImages.clear();
    selectedVideos.clear();
  }
  
  void updateDescription(String description) {
    procedureDescription.value = description;
  }
  
  Future<void> saveProcedure() async {
    try {
      isLoading.value = true;
      
      if (!hasFiles) {
        _showWarningMessage('Agrega al menos una imagen o video antes de guardar');
        return;
      }
      
      if (procedureDescription.value.trim().isEmpty) {
        _showWarningMessage('Agrega una descripción del procedimiento');
        return;
      }
      
      await Future.delayed(const Duration(seconds: 2));
      
      
      print('Guardando procedimiento:');
      print('- Descripción: ${procedureDescription.value}');
      print('- Imágenes: ${selectedImages.length}');
      print('- Videos: ${selectedVideos.length}');
     
      
      // _clearAfterSave();
      
    } catch (e) {
      _showErrorMessage('Error al guardar: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void _clearAfterSave() {
    selectedImages.clear();
    selectedVideos.clear();
    procedureDescription.value = '';
  }
  
  Future<Map<String, dynamic>> getFileInfo(File file) async {
    try {
      String fileName = file.path.split(Platform.pathSeparator).last;
      String extension = fileName.split('.').last.toLowerCase();
      int bytes = await file.length();
      double mb = bytes / (1024 * 1024);
      
      return {
        'fileName': fileName,
        'extension': extension,
        'sizeBytes': bytes,
        'sizeMB': mb,
        'isImage': ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'heic'].contains(extension),
        'isVideo': ['mp4', 'mov', 'avi', 'mkv', 'wmv', 'flv', '3gp', 'm4v'].contains(extension),
      };
    } catch (e) {
      print('Error obteniendo info del archivo: $e');
      return {};
    }
  }
  
  
  void _showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: GerenaColors.errorColor,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      duration: const Duration(seconds: 5),
    );
  }
  
  void _showWarningMessage(String message) {
    Get.snackbar(
      'Advertencia',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: GerenaColors.warningColor,
      colorText: Colors.white,
      icon: const Icon(Icons.warning, color: Colors.white),
      duration: const Duration(seconds: 4),
    );
  }
  
 
  
  String _getReadableErrorMessage(PlatformException e) {
    switch (e.code) {
      case 'ENTITLEMENT_NOT_FOUND':
        if (Platform.isMacOS) {
          return 'Error de permisos en macOS. Verifica los archivos de entitlements.';
        }
        return 'Error de permisos del sistema.';
      case 'PERMISSION_DENIED':
        return 'Permisos denegados. Verifica los permisos en la configuración.';
      case 'INVALID_EXTENSION':
        return 'Tipo de archivo no válido.';
      case 'FILE_NOT_FOUND':
        return 'No se pudo encontrar el archivo seleccionado.';
      default:
        return 'Error del sistema: ${e.message ?? 'Desconocido'}';
    }
  }
  
  void showClearConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text('Confirmar acción', style: GerenaColors.headingSmall),
        content: Text(
          '¿Estás seguro de que deseas eliminar todos los archivos seleccionados?',
          style: GerenaColors.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              clearAllFiles();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar todo'),
          ),
        ],
      ),
    );
  }
  
  @override
  void onClose() {
    selectedImages.clear();
    selectedVideos.clear();
    super.onClose();
  }
}