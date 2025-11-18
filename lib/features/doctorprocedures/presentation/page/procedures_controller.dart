import 'package:gerena/features/doctorprocedures/domain/entities/createprocedures/create_procedures_entity.dart';
import 'package:gerena/features/doctorprocedures/domain/entities/getprocedures/get_procedures_entity.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/create_procedure_usecase.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/get_procedures_usecase.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/update_procedure_usecase.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/add_imagenes_usecase.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/delete_procedure_usecase.dart';
import 'package:gerena/features/doctorprocedures/domain/usecase/delete_img_usecase.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart'; 
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

  final RxList<GetProceduresEntity> procedures = <GetProceduresEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isAddingImages = false.obs;
  final RxBool isDeleting = false.obs;
  final RxBool isDeletingImage = false.obs;
  final RxString errorMessage = ''.obs;
  
  final Rx<GetProceduresEntity?> selectedProcedure = Rx<GetProceduresEntity?>(null);
  final RxBool isEditMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProcedures();
  }

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
      showErrorSnackbar('No se pudieron cargar los procedimientos');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createProcedure({
    required String titulo,
    required String description,
    required List<String> fotos,
  }) async {
    try {
      isCreating.value = true;
      errorMessage.value = '';

      if (titulo.trim().isEmpty) {
        showWarningSnackbar('El título es obligatorio');
        return false;
      }

      if (description.trim().isEmpty) {
        showWarningSnackbar('La descripción es obligatoria');
        return false;
      }

      if (fotos.isEmpty) {
        showWarningSnackbar('Agrega al menos una imagen');
        return false;
      }

      final entity = ProceduresEntity(
        titulo: titulo,
        description: description,
        fotos: fotos,
      );

      await createProcedureUsecase.execute(entity);
      
      print('✅ Procedimiento creado exitosamente');
      showSuccessSnackbar('Procedimiento guardado exitosamente');
      
      await loadProcedures();
      
      return true;
    } catch (e) {
      errorMessage.value = 'Error al crear procedimiento: $e';
      print('❌ Error: $e');
      showErrorSnackbar('No se pudo guardar el procedimiento');
      return false;
    } finally {
      isCreating.value = false;
    }
  }

  Future<bool> updateProcedure({
    required int id,
    required String titulo,
    required String description,
  }) async {
    try {
      isUpdating.value = true;
      errorMessage.value = '';

      if (titulo.trim().isEmpty) {
        showWarningSnackbar('El título es obligatorio');
        return false;
      }

      if (description.trim().isEmpty) {
        showWarningSnackbar('La descripción es obligatoria');
        return false;
      }

      final entity = ProceduresEntity(
        titulo: titulo,
        description: description,
        fotos: [],
      );

      await updateProcedureUsecase.execute(entity, id);
      
      print('✅ Procedimiento actualizado exitosamente');
      showSuccessSnackbar('Procedimiento actualizado exitosamente');
      
      await loadProcedures();
      clearEditMode();
      
      return true;
    } catch (e) {
      errorMessage.value = 'Error al actualizar procedimiento: $e';
      print('❌ Error: $e');
      showErrorSnackbar('No se pudo actualizar el procedimiento');
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  Future<bool> addImagesToProcedure({
    required int procedimientoId,
    required List<String> fotos,
  }) async {
    try {
      isAddingImages.value = true;
      errorMessage.value = '';

      if (fotos.isEmpty) {
        showWarningSnackbar('Selecciona al menos una imagen');
        return false;
      }

      final entity = ProceduresEntity(
        titulo: null,
        description: null,
        fotos: fotos,
      );

      await addImagenesUsecase.execute(entity, procedimientoId);
      
      print('✅ Imágenes agregadas exitosamente al procedimiento $procedimientoId');
      showSuccessSnackbar('Imágenes agregadas exitosamente');
      
      await loadProcedures();
      
      return true;
    } catch (e) {
      errorMessage.value = 'Error al agregar imágenes: $e';
      print('❌ Error: $e');
      showErrorSnackbar('No se pudieron agregar las imágenes');
      return false;
    } finally {
      isAddingImages.value = false;
    }
  }

  Future<bool> deleteProcedure(int id) async {
    try {
      isDeleting.value = true;
      errorMessage.value = '';

      await deleteProcedureUsecase.execute(id);
      
      print('✅ Procedimiento eliminado exitosamente');
      showSuccessSnackbar('Procedimiento eliminado exitosamente');
      
      await loadProcedures();
      
      return true;
    } catch (e) {
      errorMessage.value = 'Error al eliminar procedimiento: $e';
      print('❌ Error: $e');
      showErrorSnackbar('No se pudo eliminar el procedimiento');
      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  Future<bool> deleteImage(int imageId) async {
    try {
      isDeletingImage.value = true;
      errorMessage.value = '';

      await deleteImgUsecase.execute(imageId);
      
      print('✅ Imagen eliminada exitosamente');
      showSuccessSnackbar('Imagen eliminada exitosamente');
      
      await loadProcedures();
      
      return true;
    } catch (e) {
      errorMessage.value = 'Error al eliminar imagen: $e';
      print('❌ Error: $e');
      showErrorSnackbar('No se pudo eliminar la imagen');
      return false;
    } finally {
      isDeletingImage.value = false;
    }
  }

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

  // ✅ Métodos simplificados usando el helper
  void showWarningSnackbar(String message) {
    showSnackBar(message, GerenaColors.warningColor);
  }
}