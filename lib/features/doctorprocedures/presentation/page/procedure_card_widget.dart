import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/doctorprocedures/domain/entities/getprocedures/get_procedures_entity.dart';
import 'package:gerena/features/doctorprocedures/presentation/page/procedures_controller.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

class ProcedureCardWidget extends StatelessWidget {
  final GetProceduresEntity procedure;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;
  final bool showAddImageButton;

  const ProcedureCardWidget({
    Key? key,
    required this.procedure,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
    this.showAddImageButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final proceduresController = Get.find<ProceduresController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: GerenaColors.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con título y acciones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  procedure.titulo,
                  style: GerenaColors.headingSmall.copyWith(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showActions)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Botón editar
                    GestureDetector(
                      onTap: onEdit ?? () => _showEditDialog(context, procedure, proceduresController),
                      child: Image.asset(
                        'assets/icons/edit.png',
                        color: GerenaColors.accentColor,
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Botón eliminar procedimiento
                    GestureDetector(
                      onTap: onDelete ??
                          () => proceduresController.showDeleteProcedureConfirmation(
                                procedure.id,
                                procedure.titulo,
                              ),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red[400],
                        size: 30,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Descripción con límite de líneas y "Continuar leyendo"
          _buildDescriptionSection(context),

          const SizedBox(height: 12),

          // Galería de imágenes
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Imágenes existentes
                ...procedure.img.map((imagen) {
                  return _buildImageItem(imagen, proceduresController);
                }),

                // Botón para agregar más imágenes
                if (showAddImageButton)
                  GestureDetector(
                    onTap: () => _showAddImagesDialog(context, procedure, proceduresController),
                    child: Container(
                      width: 120,
                      height: 100,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: GerenaColors.smallBorderRadius,
                        color: GerenaColors.accentColor.withOpacity(0.1),
                        border: Border.all(
                          color: GerenaColors.accentColor,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            color: GerenaColors.accentColor,
                            size: 32,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Agregar',
                            style: GerenaColors.bodySmall.copyWith(
                              color: GerenaColors.accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para la descripción con "Continuar leyendo"
  Widget _buildDescriptionSection(BuildContext context) {
    final bool isLongDescription = procedure.description.length > 150; // Ajusta este valor según necesites

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          procedure.description,
          style: GerenaColors.bodySmall,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        if (isLongDescription) ...[
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => _showFullDescriptionDialog(context),
            child: Text(
              'Continuar leyendo',
              style: GoogleFonts.rubik(
                fontSize: 14,
                color: GerenaColors.accentColor,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                decorationColor: GerenaColors.accentColor,
                decorationThickness: 1.0,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // Diálogo para mostrar la descripción completa
  void _showFullDescriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: GerenaColors.backgroundColor,
              borderRadius: GerenaColors.mediumBorderRadius,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header con título y botón cerrar
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            procedure.titulo,
                            style: GoogleFonts.rubik(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: GerenaColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.close,
                            color: GerenaColors.textTertiary,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Descripción completa
                    Text(
                      procedure.description,
                      style: GoogleFonts.rubik(
                        color: GerenaColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    
                    // Galería de imágenes en el diálogo
                    if (procedure.img.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        'Imágenes del procedimiento',
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: GerenaColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: procedure.img.map((imagen) {
                          return ClipRRect(
                            borderRadius: GerenaColors.smallBorderRadius,
                            child: Image.network(
                              imagen.urlImagen,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 150,
                                  height: 150,
                                  color: GerenaColors.backgroundColorfondo,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.broken_image,
                                        color: Colors.grey[400],
                                        size: 40,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Imagen no disponible',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget para cada imagen
  Widget _buildImageItem(ImagenesEntity imagen, ProceduresController controller) {
    return Container(
      width: 120,
      height: 100,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: GerenaColors.smallBorderRadius,
        color: GerenaColors.backgroundColorfondo,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: GerenaColors.smallBorderRadius,
            child: Image.network(
              imagen.urlImagen,
              width: 120,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: GerenaColors.backgroundColorfondo,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image,
                        color: Colors.grey[400],
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Imagen no encontrada',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: GerenaColors.backgroundColorfondo,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          // Botón eliminar imagen (X roja en la esquina)
          if (showActions)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => controller.showDeleteImageConfirmation(imagen.id),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Dialog para editar procedimiento
  void _showEditDialog(
    BuildContext context,
    GetProceduresEntity procedure,
    ProceduresController controller,
  ) {
    final titleController = TextEditingController(text: procedure.titulo);
    final descriptionController = TextEditingController(text: procedure.description);

    Get.dialog(
      AlertDialog(
        title: Text('Editar Procedimiento', style: GerenaColors.headingSmall),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(
                    borderRadius: GerenaColors.smallBorderRadius,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: GerenaColors.smallBorderRadius,
                    borderSide: BorderSide(color: GerenaColors.accentColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(
                    borderRadius: GerenaColors.smallBorderRadius,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: GerenaColors.smallBorderRadius,
                    borderSide: BorderSide(color: GerenaColors.accentColor, width: 2),
                  ),
                ),
                maxLines: 4,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.clearEditMode();
              Get.back();
            },
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Obx(() => controller.isUpdating.value
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
                    final success = await controller.updateProcedure(
                      id: procedure.id,
                      titulo: titleController.text,
                      description: descriptionController.text,
                    );
                    if (success) {
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GerenaColors.accentColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Guardar'),
                )),
        ],
      ),
    );
  }

  // Dialog para agregar imágenes
  void _showAddImagesDialog(
    BuildContext context,
    GetProceduresEntity procedure,
    ProceduresController controller,
  ) async {
    final RxList<File> selectedImages = <File>[].obs;
    final RxBool isPickingFiles = false.obs;

    Future<void> pickImages() async {
      try {
        isPickingFiles.value = true;

        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: true,
          withData: false,
        );

        if (result != null && result.files.isNotEmpty) {
          for (PlatformFile file in result.files) {
            if (file.path != null) {
              File fileObject = File(file.path!);
              if (await fileObject.exists()) {
                selectedImages.add(fileObject);
              }
            }
          }
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'No se pudieron seleccionar las imágenes: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: GerenaColors.errorColor,
          colorText: Colors.white,
        );
      } finally {
        isPickingFiles.value = false;
      }
    }

    Get.dialog(
      AlertDialog(
        title: Text('Agregar Imágenes', style: GerenaColors.headingSmall),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => selectedImages.isEmpty
                  ? GestureDetector(
                      onTap: pickImages,
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: GerenaColors.backgroundColor,
                          borderRadius: GerenaColors.smallBorderRadius,
                          border: Border.all(
                            color: GerenaColors.accentColor,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 48,
                                color: GerenaColors.accentColor,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Seleccionar imágenes',
                                style: GerenaColors.bodyMedium.copyWith(
                                  color: GerenaColors.accentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: selectedImages.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: GerenaColors.smallBorderRadius,
                                  child: Image.file(
                                    selectedImages[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => selectedImages.removeAt(index),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: pickImages,
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar más'),
                        ),
                      ],
                    )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Obx(() => controller.isAddingImages.value
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : ElevatedButton(
                  onPressed: selectedImages.isEmpty
                      ? null
                      : () async {
                          final imagePaths =
                              selectedImages.map((file) => file.path).toList();

                          final success = await controller.addImagesToProcedure(
                            procedimientoId: procedure.id,
                            fotos: imagePaths,
                          );

                          if (success) {
                            Get.back();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GerenaColors.accentColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Guardar'),
                )),
        ],
      ),
    );
  }
}