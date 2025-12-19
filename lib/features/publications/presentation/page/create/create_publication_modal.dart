import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/publications/presentation/page/create/create_publication_controller.dart';
import 'package:get/get.dart';

class CreatePublication extends StatelessWidget {
  const CreatePublication({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreatePublicationController>();

    return Scaffold(   
      backgroundColor: GerenaColors.colorFondo,
      resizeToAvoidBottomInset: false,
      body: Material(
        color: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: GerenaColors.colorFondo,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
          ),
          child: Column(
            children: [
              _buildModernHeader(controller),
              
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: Column(
                    children: [
                      _buildStyledDescriptionField(controller),
                      const SizedBox(height: 28),
                      _buildGallerySection(controller),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              
              _buildFloatingActionButton(controller),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildModernHeader(CreatePublicationController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        boxShadow: [
          BoxShadow(
            color: GerenaColors.primaryColor.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    GerenaColors.secondaryColor.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      GerenaColors.primaryColor.withOpacity(0.1),
                      GerenaColors.secondaryColor.withOpacity(0.1),
                    ],
                  ),
                ),
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: GerenaColors.primaryColor,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crear Publicación',
                      style: GerenaColors.headingMedium.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Comparte con la comunidad',
                      style: GerenaColors.bodySmall.copyWith(
                        color: GerenaColors.textSecondaryColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStyledDescriptionField(CreatePublicationController controller) {
    return Container(
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: GerenaColors.primaryColor.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: GerenaColors.primaryColor.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Padding(
  padding: const EdgeInsets.fromLTRB(22, 20, 22, 12),
  child: Row(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: GerenaColors.primaryGradient,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.edit_rounded,
          color: GerenaColors.textLightColor,
          size: 18,
        ),
      ),
      const SizedBox(width: 12),

      // ⬇️ Esto evita el overflow
      Expanded(
        child: Text(
          'Escribe tu mensaje',
          style: GerenaColors.headingSmall.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,         // opcional
          overflow: TextOverflow.ellipsis,  // opcional
        ),
      ),
    ],
  ),
)
,
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  GerenaColors.primaryColor.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          TextField(
            controller: controller.descriptionController,
            maxLines: 6,
            style: GerenaColors.bodyMedium.copyWith(
              fontSize: 15,
              height: 1.6,
              letterSpacing: 0.2,
            ),
            decoration: InputDecoration(
              hintText: '¿Qué quieres compartir con la comunidad?',
              hintStyle: GerenaColors.bodyMedium.copyWith(
                color: GerenaColors.textSecondaryColor.withOpacity(0.5),
                fontSize: 15,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection(CreatePublicationController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: GerenaColors.primaryColor.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: GerenaColors.primaryColor.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: GerenaColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: GerenaColors.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.photo_library_rounded,
                  color: GerenaColors.textLightColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Galería de Imágenes',
                      style: GerenaColors.headingSmall.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Añade hasta 5 fotos',
                      style: GerenaColors.bodySmall.copyWith(
                        color: GerenaColors.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient:
                        controller.selectedImages.length >= 5
                            ? LinearGradient(
                              colors: [
                                GerenaColors.errorColor,
                                GerenaColors.errorColor.withOpacity(0.8),
                              ],
                            )
                            : GerenaColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (controller.selectedImages.length >= 5
                                ? GerenaColors.errorColor
                                : GerenaColors.primaryColor)
                            .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    '${controller.selectedImages.length}/5',
                    style: GerenaColors.bodyMedium.copyWith(
                      color: GerenaColors.textLightColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(
            () => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount:
                  controller.selectedImages.length +
                  (controller.selectedImages.length < 5 ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.selectedImages.length) {
                  return GestureDetector(
                    onTap: controller.showImageSourceOptions,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            GerenaColors.primaryColor.withOpacity(0.08),
                            GerenaColors.secondaryColor.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: GerenaColors.primaryColor.withOpacity(0.2),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: GerenaColors.primaryGradient,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add_rounded,
                              color: GerenaColors.textLightColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Agregar',
                            style: GerenaColors.bodySmall.copyWith(
                              color: GerenaColors.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final imageFile = controller.selectedImages[index];
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: GerenaColors.primaryColor.withOpacity(0.2),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: GerenaColors.primaryColor.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(
                          imageFile,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => controller.removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                GerenaColors.errorColor,
                                GerenaColors.errorColor.withOpacity(0.9),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: GerenaColors.textLightColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

Widget _buildFloatingActionButton(CreatePublicationController controller) {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: GerenaColors.colorFondo,
      boxShadow: [
        BoxShadow(
          color: GerenaColors.primaryColor.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, -10),
        ),
      ],
    ),
    child: SafeArea(  // ✅ Agregar esto
      top: false,    // No necesitas padding arriba
      child: Obx(
        () => controller.isLoading.value
            ? Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        GerenaColors.primaryColor.withOpacity(0.5),
                        GerenaColors.accentColor.withOpacity(0.5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: GerenaColors.textLightColor,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Publicando...',
                          style: GerenaColors.buttonText.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : GerenaColors.widgetButton(
                  onPressed: controller.createPublication,
                  text: 'Crear Publicación',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 24,
                  ),
                ),
      ),
    ),
    );
  }
}