import 'package:flutter/material.dart';
import 'package:gerena/common/controller/mediacontroller/media_controller.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'dart:io';

class PromotionPreviewWidget extends StatelessWidget {
  final dynamic promotionController;

  const PromotionPreviewWidget({
    Key? key,
    required this.promotionController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
Obx(() => promotionController.isPublished.value ? Column(
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
             
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  _buildMainPreview(),
                ],
              ),
            ),
          ],
        ) : const SizedBox.shrink()),   
             _buildFormView(),
        
        Obx(() => !promotionController.isPublished.value && promotionController.mediaController.hasFiles 
          ? Column(
              children: [
                const SizedBox(height: 12),
                _buildSelectedFilesPreview(),
              ],
            )
          : const SizedBox.shrink()
        ),
        
        
      ],
    );
  }

  Widget _buildFormView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 2,
          child: IntrinsicHeight(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: GestureDetector(
                    onTap: () => promotionController.mediaController.pickFiles(),
                    child: Image.asset(
                      'assets/icons/edit.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GerenaColors.buildLabeledTextField(
                    'DESCRIPCIÓN',
                    '',
                    controller: promotionController.descriptionController
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: GerenaColors.widgetButton(
            onPressed: promotionController.publishPromotion,
            text: 'Publicar',
            borderRadius: 5,
            showShadow: false,
          ),
        ),
      ],
    );
  }


  Widget _buildMainPreview() {
    return Obx(() => Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 2,
          child: IntrinsicHeight(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: _buildMediaPreview(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  
                  child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: _buildDescriptionDisplay(),
                ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: GerenaColors.widgetButton(
            onPressed: promotionController.editPromotion,
            text: 'Editar',
            borderRadius: 5,
            showShadow: false,
          ),
        ),
      ],
    ));
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: promotionController.clearPromotion,
          child: Text(
            'Nueva promoción',
            style: GoogleFonts.rubik(
              color: GerenaColors.textSecondaryColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: promotionController.editPromotion,
          child: Text(
            'Editar',
            style: GoogleFonts.rubik(
              color: GerenaColors.accentColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedFilesPreview() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (promotionController.mediaController.hasImages) ...[
            Text(
              'Imágenes (${promotionController.mediaController.selectedImages.length})',
              style: GoogleFonts.rubik(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: GerenaColors.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              children: promotionController.mediaController.selectedImages.take(3).map<Widget>((image) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          if (promotionController.mediaController.hasVideos) ...[
            if (promotionController.mediaController.hasImages) const SizedBox(height: 8),
            Text(
              'Videos (${promotionController.mediaController.selectedVideos.length})',
              style: GoogleFonts.rubik(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: GerenaColors.textPrimaryColor,
              ),
            ),
          ],
        ],
      )),
    );
  }

  Widget _buildMediaPreview() {
    if (!promotionController.mediaController.hasFiles) {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: GerenaColors.backgroundColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Icon(
          Icons.image_outlined,
          size: 20,
          color: Colors.grey[400],
        ),
      );
    }

    if (promotionController.mediaController.hasImages) {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.file(
            promotionController.mediaController.selectedImages.first,
            width: 30,
            height: 30,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    if (promotionController.mediaController.hasVideos) {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: GerenaColors.accentColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: GerenaColors.accentColor.withOpacity(0.3)),
        ),
        child: Icon(
          Icons.play_circle_fill,
          size: 20,
          color: GerenaColors.accentColor,
        ),
      );
    }

    return Container(
      width: 30,
      height: 30,
      child: Icon(Icons.image_outlined, size: 20),
    );
  }

  Widget _buildDescriptionDisplay() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
       Text(
            promotionController.description.value.isEmpty ? 'Sin descripción' : promotionController.description.value,
            style: GoogleFonts.rubik(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: GerenaColors.textPrimaryColor,
          ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    ));
  }
}
