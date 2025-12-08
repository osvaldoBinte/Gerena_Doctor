import 'package:flutter/material.dart';
import 'package:gerena/common/errors/convert_message.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:gerena/features/publications/domain/entities/create/create_publications_entity.dart';
import 'package:gerena/features/publications/domain/usecase/create_publication_usecase.dart';

class CreatePublicationController extends GetxController {
  final CreatePublicationUsecase createPublicationUsecase;
  //final GetDoctorUsecase getDoctorUsecase;

  CreatePublicationController({
    required this.createPublicationUsecase,
   // required this.getDoctorUsecase,
  });

  final RxBool isReview = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearchingDoctor = false.obs;

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController doctorSearchController = TextEditingController();

  final RxInt rating = 0.obs;
  final RxList<File> selectedImages = <File>[].obs;
  //final RxList<FindDoctorsEntity> searchedDoctors = <FindDoctorsEntity>[].obs;
 // final Rxn<FindDoctorsEntity> selectedDoctor = Rxn<FindDoctorsEntity>();

  final ImagePicker _picker = ImagePicker();

  @override
  void onClose() {
    descriptionController.dispose();
    doctorSearchController.dispose();
    super.onClose();
  }

  void toggleReviewMode(bool value) {
    isReview.value = value;
    if (!value) {
   //   selectedDoctor.value = null;
      doctorSearchController.clear();
    //  searchedDoctors.clear();
      rating.value = 0;
    }
  }

  Future<void> searchDoctors(String query) async {
    if (query.isEmpty) {
    //  searchedDoctors.clear();
      return;
    }

    try {
      isSearchingDoctor.value = true;
   //   final result = await getDoctorUsecase.execute('', query);
    //  searchedDoctors.value = result;
    } catch (e) {
      showErrorSnackbar('No se pudieron buscar doctores: $e');
    } finally {
      isSearchingDoctor.value = false;
    }
  }

 // void selectDoctor(FindDoctorsEntity doctor) {
  //  selectedDoctor.value = doctor;
  //  doctorSearchController.text = doctor.fullName;
 //   searchedDoctors.clear();
 // }

  Future<void> pickImageFromGallery() async {
    if (selectedImages.length >= 5) {
      showErrorSnackbar('Solo puedes seleccionar hasta 5 imágenes');

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
        selectedImages.add(File(image.path));
      }
    } catch (e) {
      showErrorSnackbar('No se pudo seleccionar la imagen: $e');
    }
  }

  Future<void> pickMultipleImages() async {
    if (selectedImages.length >= 5) {
      showErrorSnackbar('Solo puedes seleccionar hasta 5 imágenes');

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
          selectedImages.add(File(image.path));
        }

        if (images.length > remaining) {
          showErrorSnackbar(
            'Solo se agregaron ${imagesToAdd.length} imágenes (límite: 5)',
          );
        }
      }
    } catch (e) {
      showErrorSnackbar('No se pudieron seleccionar las imágenes: $e');
    }
  }

  Future<void> takePhoto() async {
    if (selectedImages.length >= 5) {
      showErrorSnackbar('Solo puedes seleccionar hasta 5 imágenes');

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
        selectedImages.add(File(photo.path));
      }
    } catch (e) {
      showErrorSnackbar('No se pudo tomar la foto: $e');
    }
  }

  void showImageSourceOptions() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.blue.shade600),
                title: Text('Seleccionar de la galería'),
                onTap: () {
                  Get.back();
                  pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library_outlined,
                  color: Colors.green.shade600,
                ),
                title: Text('Seleccionar varias imágenes'),
                onTap: () {
                  Get.back();
                  pickMultipleImages();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.purple.shade600),
                title: Text('Tomar foto'),
                onTap: () {
                  Get.back();
                  takePhoto();
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> createPublication() async {
    if (descriptionController.text.isEmpty) {
      showErrorSnackbar('Por favor escribe una descripción');
      return;
    }

  //  if (isReview.value && selectedDoctor.value == null) {
  //    showErrorSnackbar('Por favor selecciona un doctor para la reseña');
  ///    return;
  //  }

    if (isReview.value && rating.value == 0) {
      showErrorSnackbar('Por favor califica al doctor');
      return;
    }

    try {
      isLoading.value = true;

      final imagePaths = selectedImages.map((file) => file.path).toList();

      final entity = CreatePublicationsEntity(
        description: descriptionController.text,
        isReview: isReview.value.toString(),
        taggedDoctorId: isReview.value ? null /*selectedDoctor.value!.id*/ : null,
        ratings:
            isReview.value ? rating.value : 0,
        images: imagePaths,
      );

      await createPublicationUsecase.execute(entity);

      Get.back();
      showSuccessSnackbar(
        isReview.value
            ? 'Reseña creada exitosamente'
            : 'Publicación creada exitosamente',
      );

      _resetForm();
    } catch (e) {
      print(cleanExceptionMessage(e));
      showErrorSnackbar(cleanExceptionMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  void _resetForm() {
    descriptionController.clear();
    doctorSearchController.clear();
    isReview.value = false;
    rating.value = 0;
    selectedImages.clear();
  //  selectedDoctor.value = null;
   // searchedDoctors.clear();
  }
}
