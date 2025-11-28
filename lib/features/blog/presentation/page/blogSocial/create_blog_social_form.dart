import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/blog/presentation/page/blogGerena/blog_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateBlogSocialForm extends StatelessWidget {
  const CreateBlogSocialForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BlogController>();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 600 ? 100.0 : 20.0,
        vertical: 20.0,
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.create,
                  color: GerenaColors.primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Crear Publicación',
                  style: GerenaColors.headingLarge.copyWith(
                    color: GerenaColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Text(
              'Título *',
              style: GoogleFonts.rubik(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: GerenaColors.textTertiaryColor,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.titleController,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: 'Escribe el título de tu publicación',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: GerenaColors.primaryColor,
                    width: 2,
                  ),
                ),
                counterText: '',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El título es obligatorio';
                }
                if (value.trim().length < 10) {
                  return 'El título debe tener al menos 10 caracteres';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            Text(
              'Descripción *',
              style: GoogleFonts.rubik(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: GerenaColors.textTertiaryColor,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.descriptionController,
              maxLines: 6,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Escribe la descripción de tu publicación',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: GerenaColors.primaryColor,
                    width: 2,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La descripción es obligatoria';
                }
                if (value.trim().length < 20) {
                  return 'La descripción debe tener al menos 20 caracteres';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            Text(
              'Tipo de publicación *',
              style: GoogleFonts.rubik(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: GerenaColors.textTertiaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedQuestionType.value.isEmpty
                      ? null
                      : controller.selectedQuestionType.value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: GerenaColors.primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                  hint: const Text('Selecciona un tipo'),
                  items: ['pregunta', 'noticia'].map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type.capitalize!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedQuestionType.value = value;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Debes seleccionar un tipo de publicación';
                    }
                    return null;
                  },
                )),

            const SizedBox(height: 20),

            Text(
              'Imagen *',
              style: GoogleFonts.rubik(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: GerenaColors.textTertiaryColor,
              ),
            ),
            const SizedBox(height: 8),

            Obx(() {
              if (controller.selectedImagePath.value.isNotEmpty) {
                return Column(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(controller.selectedImagePath.value),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image, size: 50),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => controller.clearSelectedImage(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }

              return const SizedBox.shrink();
            }),

            GestureDetector(
              onTap: () => controller.pickImage(),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: GerenaColors.primaryColor.withOpacity(0.3),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: GerenaColors.primaryColor.withOpacity(0.05),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 48,
                      color: GerenaColors.primaryColor,
                    ),
                    const SizedBox(height: 12),
                    Obx(() => Text(
                          controller.selectedImagePath.value.isEmpty
                              ? 'Seleccionar imagen'
                              : 'Cambiar imagen',
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            color: GerenaColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                    const SizedBox(height: 4),
                    Text(
                      'JPG, PNG (Max 5MB)',
                      style: GoogleFonts.rubik(
                        fontSize: 12,
                        color: GerenaColors.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            Obx(() => Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: controller.isCreatingBlog.value
                            ? null
                            : () => controller.goBackToBlogSocial(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: GerenaColors.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'CANCELAR',
                          style: GoogleFonts.rubik(
                            color: GerenaColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: controller.isCreatingBlog.value
                            ? null
                            : () => controller.submitCreateBlogForm(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GerenaColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: controller.isCreatingBlog.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'PUBLICAR',
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
