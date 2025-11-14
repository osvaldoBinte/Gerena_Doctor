import 'package:gerena/features/doctorprocedures/domain/entities/createprocedures/create_procedures_entity.dart';
import 'package:gerena/features/doctorprocedures/domain/entities/getprocedures/get_procedures_entity.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/create_procedure_usecase.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/get_procedures_usecase.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/update_procedure_usecase.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/add_imagenes_usecase.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/delete_procedure_usecase.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/delete_img_usecase.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProceduresController extends GetxController {
  final GetProceduresUsecase getProceduresUsecase;
  final CreateProcedureUsecase createProcedureUsecase;
  final UpdateProcedureUsecase updateProcedureUsecase;
  final AddImagenesUsecase addImagenesUsecase;
  final DeleteProcedureUsecase deleteProcedureUsecase;
  final DeleteImgUsecase deleteImgUsecase;
  
  ProceduresController({
    required this.getProceduresUsecase,
    required this.createProcedureUsecase,
    required this.updateProcedureUsecase,
    required this.addImagenesUsecase,
    required this.deleteProcedureUsecase,
    required this.deleteImgUsecase,
  });

  // Estados observables
  final RxList<GetProceduresEntity> procedures = <GetProceduresEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isAddingImages = false.obs;
  final RxBool isDeleting = false.obs;
  final RxBool isDeletingImage = false.obs;
  final RxString errorMessage = ''.obs;
  
  // Procedimiento seleccionado para editar
  final Rx<GetProceduresEntity?> selectedProcedure = Rx<GetProceduresEntity?>(null);
  final RxBool isEditMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProcedures();
  }

  // Cargar procedimientos
  Future<void> loadProcedures() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final List<GetProceduresEntity> result = await getProceduresUsecase.execute();
      
      procedures.value = result;
      
      print('✅ Procedimientos cargados: ${procedures.length}');
    } catch (e) {
      errorMessage.value = 'Error al cargar procedimientos: $e';
      print('❌ Error: $e');
      _showErrorSnackbar('No se pudieron cargar los procedimientos');
    } finally {
      isLoading.value = false;
    }
  }

  // Crear procedimiento
  Future<bool> createProcedure({
    required String titulo,
    required String description,
    required List<String> fotos,
  }) async {
    try {
      isCreating.value = true;
      errorMessage.value = '';

      if (titulo.trim().isEmpty) {
        _showWarningSnackbar('El título es obligatorio');
        return false;
      }

      if (description.trim().isEmpty) {
        _showWarningSnackbar('La descripción es obligatoria');
        return false;
      }

      if (fotos.isEmpty) {
        _showWarningSnackbar('Agrega al menos una imagen');
        return false;
      }

      final entity = ProceduresEntity(
        titulo: titulo,
        description: description,
        fotos: fotos,
      );

      await createProcedureUsecase.execute(entity);
      
      print('✅ Procedimiento creado exitosamente');
      _showSuccessSnackbar('Procedimiento guardado exitosamente');
      
      await loadProcedures();
      
      return true;
    } catch (e) {
      errorMessage.value = 'Error al crear procedimiento: $e';
      print('❌ Error: $e');
      _showErrorSnackbar('No se pudo guardar el procedimiento');
      return false;
    } finally {
      isCreating.value = false;
    }
  }

  // Actualizar procedimiento
  Future<bool> updateProcedure({
    required int id,
    required String titulo,
    required String description,
  }) async {
    try {
      isUpdating.value = true;
      errorMessage.value = '';

      if (titulo.trim().isEmpty) {
        _showWarningSnackbar('El título es obligatorio');
        return false;
      }

      if (description.trim().isEmpty) {
        _showWarningSnackbar('La descripción es obligatoria');
        return false;
      }

      final entity = ProceduresEntity(
        titulo: titulo,
        description: description,
        fotos: [],
      );

      await updateProcedureUsecase.execute(entity, id);
      
      print('✅ Procedimiento actualizado exitosamente');
      _showSuccessSnackbar('Procedimiento actualizado exitosamente');
      
      await loadProcedures();
      clearEditMode();
      
      return true;
    } catch (e) {
      errorMessage.value = 'Error al actualizar procedimiento: $e';
      print('❌ Error: $e');
      _showErrorSnackbar('No se pudo actualizar el procedimiento');
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  // Agregar imágenes a un procedimiento existente
  Future<bool> addImagesToProcedure({
    required int procedimientoId,
    required List<String> fotos,
  }) async {
    try {
      isAddingImages.value = true;
      errorMessage.value = '';

      if (fotos.isEmpty) {
        _showWarningSnackbar('Selecciona al menos una imagen');
        return false;
      }

      final entity = ProceduresEntity(
        titulo: null,
        description: null,
        fotos: fotos,
      );

      await addImagenesUsecase.execute(entity, procedimientoId);
      
      print('✅ Imágenes agregadas exitosamente al procedimiento $procedimientoId');
      _showSuccessSnackbar('Imágenes agregadas exitosamente');
      
      await loadProcedures();
      
      return true;
    } catch (e) {
      errorMessage.value = 'Error al agregar imágenes: $e';
      print('❌ Error: $e');
      _showErrorSnackbar('No se pudieron agregar las imágenes');
      return false;
    } finally {
      isAddingImages.value = false;
    }
  }

  // Eliminar procedimiento completo
  Future<bool> deleteProcedure(int id) async {
    try {
      isDeleting.value = true;
      errorMessage.value = '';

      await deleteProcedureUsecase.execute(id);
      
      print('✅ Procedimiento eliminado exitosamente');
      _showSuccessSnackbar('Procedimiento eliminado exitosamente');
      
      await loadProcedures();
      
      return true;
    } catch (e) {
      errorMessage.value = 'Error al eliminar procedimiento: $e';
      print('❌ Error: $e');
      _showErrorSnackbar('No se pudo eliminar el procedimiento');
      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  // Eliminar una imagen específica
  Future<bool> deleteImage(int imageId) async {
    try {
      isDeletingImage.value = true;
      errorMessage.value = '';

      await deleteImgUsecase.execute(imageId);
      
      print('✅ Imagen eliminada exitosamente');
      _showSuccessSnackbar('Imagen eliminada exitosamente');
      
      await loadProcedures();
      
      return true;
    } catch (e) {
      errorMessage.value = 'Error al eliminar imagen: $e';
      print('❌ Error: $e');
      _showErrorSnackbar('No se pudo eliminar la imagen');
      return false;
    } finally {
      isDeletingImage.value = false;
    }
  }

  // Mostrar confirmación para eliminar procedimiento
  void showDeleteProcedureConfirmation(int id, String titulo) {
    Get.dialog(
      AlertDialog(
        title: Text('Eliminar Procedimiento', style: GerenaColors.headingSmall),
        content: Text(
          '¿Estás seguro de que deseas eliminar el procedimiento "$titulo"? Esta acción no se puede deshacer.',
          style: GerenaColors.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancelar', style: TextStyle(color: Colors.grey[600])),
          ),
          Obx(() => isDeleting.value
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : ElevatedButton(
                  onPressed: () async {
                    final success = await deleteProcedure(id);
                    if (success) {
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Eliminar'),
                )),
        ],
      ),
    );
  }

  // Mostrar confirmación para eliminar imagen
  void showDeleteImageConfirmation(int imageId) {
    Get.dialog(
      AlertDialog(
        title: Text('Eliminar Imagen', style: GerenaColors.headingSmall),
        content: Text(
          '¿Estás seguro de que deseas eliminar esta imagen?',
          style: GerenaColors.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancelar', style: TextStyle(color: Colors.grey[600])),
          ),
          Obx(() => isDeletingImage.value
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : ElevatedButton(
                  onPressed: () async {
                    final success = await deleteImage(imageId);
                    if (success) {
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Eliminar'),
                )),
        ],
      ),
    );
  }

  // Activar modo edición
  void enterEditMode(GetProceduresEntity procedure) {
    selectedProcedure.value = procedure;
    isEditMode.value = true;
    print('📝 Modo edición activado para: ${procedure.titulo}');
  }

  // Limpiar modo edición
  void clearEditMode() {
    selectedProcedure.value = null;
    isEditMode.value = false;
    print('✖️ Modo edición desactivado');
  }

  // Obtener un procedimiento por ID
  GetProceduresEntity? getProcedureById(int id) {
    try {
      return procedures.firstWhere((procedure) => procedure.id == id);
    } catch (e) {
      return null;
    }
  }

  // Snackbars
  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Éxito',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: GerenaColors.errorColor,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      duration: const Duration(seconds: 4),
    );
  }

  void _showWarningSnackbar(String message) {
    Get.snackbar(
      'Advertencia',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: GerenaColors.warningColor,
      colorText: Colors.white,
      icon: const Icon(Icons.warning, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }
}