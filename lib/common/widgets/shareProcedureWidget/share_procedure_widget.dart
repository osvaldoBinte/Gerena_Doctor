import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/controller/mediacontroller/media_controller.dart';
import 'package:gerena/features/doctorprocedures/presentation/page/procedures_controller.dart';
import 'package:get/get.dart';
import 'dart:io';

class ShareProcedureWidget extends StatelessWidget {
  final MediaController mediaController;

  const ShareProcedureWidget({
    Key? key,
    required this.mediaController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener el ProceduresController
    final proceduresController = Get.find<ProceduresController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: GerenaColors.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 800;
              
              if (isSmallScreen) {
                return Column(
                  children: [
                    _buildTitleField(),
                    const SizedBox(height: 12),
                    _buildDescriptionContainer(),
                    const SizedBox(height: 12),
                    _buildMediaContainer(mediaController),
                    const SizedBox(height: 16),
                    Obx(() => SizedBox(
                      width: double.infinity,
                      child: proceduresController.isCreating.value
                          ? const Center(child: CircularProgressIndicator())
                          : GerenaColors.widgetButton(
                              onPressed: () => _handleSave(
                                mediaController,
                                proceduresController,
                              ),
                              text: 'GUARDAR',
                              showShadow: false,
                              borderRadius: 5,
                            ),
                    )),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildTitleField(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildDescriptionContainer(),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: _buildMediaContainer(mediaController),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(() => proceduresController.isCreating.value
                            ? const CircularProgressIndicator()
                            : GerenaColors.widgetButton(
                                onPressed: () => _handleSave(
                                  mediaController,
                                  proceduresController,
                                ),
                                text: 'GUARDAR',
                                showShadow: false,
                                borderRadius: 5,
                              )),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Campo para el título
  Widget _buildTitleField() {
    return TextField(
      onChanged: (value) => mediaController.procedureTitle.value = value,
      decoration: InputDecoration(
        hintText: 'Título del procedimiento...',
        hintStyle: GerenaColors.bodySmall.copyWith(
          color: GerenaColors.textSecondaryColor.withOpacity(0.7),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: GerenaColors.smallBorderRadius,
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: GerenaColors.smallBorderRadius,
          borderSide: BorderSide(color: GerenaColors.accentColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildDescriptionContainer() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (value) => mediaController.procedureDescription.value = value,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Escribe aquí los detalles del procedimiento...',
              hintStyle: GerenaColors.bodySmall.copyWith(
                color: GerenaColors.textSecondaryColor.withOpacity(0.7),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: GerenaColors.smallBorderRadius,
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: GerenaColors.smallBorderRadius,
                borderSide: BorderSide(color: GerenaColors.accentColor, width: 1.5),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  // Manejar el guardado
  Future<void> _handleSave(
    MediaController mediaController,
    ProceduresController proceduresController,
  ) async {
    // Obtener las rutas de las imágenes
    final List<String> imagesPaths = mediaController.selectedImages
        .map((file) => file.path)
        .toList();

    // Crear el procedimiento
    final success = await proceduresController.createProcedure(
      titulo: mediaController.procedureTitle.value,
      description: mediaController.procedureDescription.value,
      fotos: imagesPaths,
    );

    // Limpiar si fue exitoso
    if (success) {
      mediaController.clearAllFiles();
      mediaController.procedureTitle.value = '';
      mediaController.procedureDescription.value = '';
    }
  }

  Widget _buildMediaContainer(MediaController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: GerenaColors.smallBorderRadius,
        border: Border.all(
          color: GerenaColors.textSecondaryColor.withOpacity(0.3),
          style: BorderStyle.solid,
          width: 1,
        ),
      ),
      child: Obx(() => Column(
        children: [
          const SizedBox(height: 16),
          
          if (controller.isLoading.value)
            const CircularProgressIndicator()
          else
            !controller.hasFiles
                ? _buildAddButton(controller)
                : _buildPreviewSection(controller),
          
          const SizedBox(height: 12),
          
          if (controller.hasFiles && !controller.isLoading.value)
            _buildAddMoreButton(controller),
          
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Agregar fotos / videos',
                  style: GerenaColors.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: GerenaColors.textTertiaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }

  Widget _buildAddButton(MediaController controller) {
    return GestureDetector(
      onTap: controller.pickFiles,
      child: const Icon(
        Icons.add_box_rounded,
        size: 50,
      ),
    );
  }

  Widget _buildAddMoreButton(MediaController controller) {
    return GestureDetector(
      onTap: controller.pickFiles,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: GerenaColors.accentColor,
          borderRadius: GerenaColors.smallBorderRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              'Agregar más',
              style: GerenaColors.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection(MediaController controller) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: SingleChildScrollView(
        child: Obx(() => Column(
          children: [
            if (controller.hasImages) _buildImagesPreview(controller),
            
            if (controller.hasImages && controller.hasVideos)
              const SizedBox(height: 16),
            
            if (controller.hasVideos) _buildVideosPreview(controller),
          ],
        )),
      ),
    );
  }

  Widget _buildImagesPreview(MediaController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.image, color: GerenaColors.accentColor, size: 16),
            const SizedBox(width: 4),
            Obx(() => Text(
              'Imágenes (${controller.selectedImages.length})',
              style: GerenaColors.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: GerenaColors.textPrimaryColor,
              ),
            )),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() => GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: controller.selectedImages.length,
          itemBuilder: (context, index) {
            return _buildImagePreviewItem(
              controller.selectedImages[index],
              index,
              controller,
            );
          },
        )),
      ],
    );
  }

  Widget _buildVideosPreview(MediaController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.videocam, color: GerenaColors.accentColor, size: 16),
            const SizedBox(width: 4),
            Obx(() => Text(
              'Videos (${controller.selectedVideos.length})',
              style: GerenaColors.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: GerenaColors.textPrimaryColor,
              ),
            )),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.selectedVideos.length,
          itemBuilder: (context, index) {
            return _buildVideoPreviewItem(
              controller.selectedVideos[index],
              index,
              controller,
            );
          },
        )),
      ],
    );
  }

  Widget _buildImagePreviewItem(File imageFile, int index, MediaController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: GerenaColors.smallBorderRadius,
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: GerenaColors.smallBorderRadius,
            child: Image.file(
              imageFile,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.broken_image, color: Colors.grey[400]),
                );
              },
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => controller.removeImage(index),
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
      ),
    );
  }

  Widget _buildVideoPreviewItem(File videoFile, int index, MediaController controller) {
    String fileName = videoFile.path.split(Platform.pathSeparator).last;
    
    return FutureBuilder<Map<String, dynamic>>(
      future: controller.getFileInfo(videoFile),
      builder: (context, snapshot) {
        double mb = 0;
        if (snapshot.hasData) {
          mb = snapshot.data!['sizeMB'] ?? 0;
        }
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: GerenaColors.smallBorderRadius,
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: GerenaColors.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.play_circle_fill, color: GerenaColors.accentColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: GerenaColors.bodySmall.copyWith(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${mb.toStringAsFixed(1)} MB',
                      style: GerenaColors.bodySmall.copyWith(
                        color: GerenaColors.textSecondaryColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => controller.removeVideo(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.delete_outline, color: Colors.red[400], size: 18),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}