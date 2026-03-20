import 'package:flutter/material.dart';
import 'package:gerena/common/errors/convert_message.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/publications/presentation/page/myposts/my_post_controller.dart';
import 'package:gerena/features/publications/presentation/page/publication_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:gerena/features/publications/domain/entities/create/create_publications_entity.dart';
import 'package:gerena/features/publications/domain/usecase/create_publication_usecase.dart';
import 'package:video_player/video_player.dart';

// Modelo para saber si es imagen o video
class MediaFile {
  final File file;
  final bool isVideo;
  VideoPlayerController? videoController;
  final RxBool videoInitialized = false.obs;

  MediaFile({required this.file, required this.isVideo}) {
    if (isVideo) _initVideoController();
  }

  Future<void> _initVideoController() async {
    videoController = VideoPlayerController.file(file);
    await videoController!.initialize();
    videoInitialized.value = true;
  }

  void dispose() {
    videoController?.dispose();
  }
}

class CreatePublicationController extends GetxController {
  final CreatePublicationUsecase createPublicationUsecase;

  CreatePublicationController({required this.createPublicationUsecase});
  final MyPostController myPostController = Get.find<MyPostController>();
     final PublicationController publicationController = Get.find<PublicationController>();


  final RxBool isLoading = false.obs;
  final TextEditingController descriptionController = TextEditingController();
  
  // Cambiamos de RxList<File> a RxList<MediaFile>
  final RxList<MediaFile> selectedImages = <MediaFile>[].obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onClose() {
    descriptionController.dispose();
    for (var media in selectedImages) {
      media.dispose();
    }
    super.onClose();
  }

  Future<void> pickImageFromGallery() async {
    if (selectedImages.length >= 5) {
      showErrorSnackbar('Solo puedes seleccionar hasta 5 archivos');
      return;
    }
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        selectedImages.add(MediaFile(file: File(image.path), isVideo: false));
      }
    } catch (e) {
      showErrorSnackbar('No se pudo seleccionar la imagen: $e');
    }
  }

  Future<void> pickMultipleImages() async {
    if (selectedImages.length >= 5) {
      showErrorSnackbar('Solo puedes seleccionar hasta 5 archivos');
      return;
    }
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (images.isNotEmpty) {
        final remaining = 5 - selectedImages.length;
        final imagesToAdd = images.take(remaining).toList();
        for (var image in imagesToAdd) {
          selectedImages.add(MediaFile(file: File(image.path), isVideo: false));
        }
        if (images.length > remaining) {
          showErrorSnackbar('Solo se agregaron ${imagesToAdd.length} archivos (límite: 5)');
        }
      }
    } catch (e) {
      showErrorSnackbar('No se pudieron seleccionar las imágenes: $e');
    }
  }

  Future<void> takePhoto() async {
    if (selectedImages.length >= 5) {
      showErrorSnackbar('Solo puedes seleccionar hasta 5 archivos');
      return;
    }
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (photo != null) {
        selectedImages.add(MediaFile(file: File(photo.path), isVideo: false));
      }
    } catch (e) {
      showErrorSnackbar('No se pudo tomar la foto: $e');
    }
  }

  // ✅ NUEVO: Seleccionar video de galería
  Future<void> pickVideoFromGallery() async {
    if (selectedImages.length >= 5) {
      showErrorSnackbar('Solo puedes seleccionar hasta 5 archivos');
      return;
    }
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 3),
      );
      if (video != null) {
        selectedImages.add(MediaFile(file: File(video.path), isVideo: true));
      }
    } catch (e) {
      showErrorSnackbar('No se pudo seleccionar el video: $e');
    }
  }

  // ✅ NUEVO: Grabar video con cámara
  Future<void> recordVideo() async {
    if (selectedImages.length >= 5) {
      showErrorSnackbar('Solo puedes seleccionar hasta 5 archivos');
      return;
    }
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 3),
      );
      if (video != null) {
        selectedImages.add(MediaFile(file: File(video.path), isVideo: true));
      }
    } catch (e) {
      showErrorSnackbar('No se pudo grabar el video: $e');
    }
  }

  void showImageSourceOptions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              // Imágenes
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.blue.shade600),
                title: const Text('Seleccionar imagen de galería'),
                onTap: () { Get.back(); pickImageFromGallery(); },
              ),
              ListTile(
                leading: Icon(Icons.photo_library_outlined, color: Colors.green.shade600),
                title: const Text('Seleccionar varias imágenes'),
                onTap: () { Get.back(); pickMultipleImages(); },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.purple.shade600),
                title: const Text('Tomar foto'),
                onTap: () { Get.back(); takePhoto(); },
              ),
              const Divider(),
              // Videos
              ListTile(
                leading: Icon(Icons.video_library, color: Colors.orange.shade600),
                title: const Text('Seleccionar video de galería'),
                onTap: () { Get.back(); pickVideoFromGallery(); },
              ),
              ListTile(
                leading: Icon(Icons.videocam, color: Colors.red.shade600),
                title: const Text('Grabar video'),
                onTap: () { Get.back(); recordVideo(); },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void removeImage(int index) {
    selectedImages[index].dispose();
    selectedImages.removeAt(index);
  }

  Future<void> createPublication() async {
    if (descriptionController.text.isEmpty) {
      showErrorSnackbar('Por favor escribe una descripción');
      return;
    }
    try {
      isLoading.value = true;
      final imagePaths = selectedImages.map((m) => m.file.path).toList();
      final entity = CreatePublicationsEntity(
        description: descriptionController.text,
        isReview: 'false',
        taggedDoctorId: null,
        ratings: 0,
        images: imagePaths,
      );
      await createPublicationUsecase.execute(entity);


      Get.back();
     
      myPostController.loadMyPosts();
      publicationController.loadFeedPosts();
      showSuccessSnackbar('Publicación creada exitosamente');
      _resetForm();
    } catch (e) {
      showErrorSnackbar(cleanExceptionMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  void _resetForm() {
    descriptionController.clear();
    for (var media in selectedImages) {
      media.dispose();
    }
    selectedImages.clear();
  }
}