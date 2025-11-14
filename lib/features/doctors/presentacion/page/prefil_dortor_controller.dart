import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/doctors/domain/entities/doctor/doctor_entity.dart';
import 'package:gerena/features/doctors/domain/usecase/doctor_profile_usecase.dart';
import 'package:gerena/features/doctors/domain/usecase/update_doctor_profile_usecase.dart';
import 'package:gerena/features/doctors/domain/usecase/updatefoto_doctor_profile_usecase.dart';
import 'package:get/get.dart';

class PrefilDortorController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isUploadingPhoto = false.obs;
  final Rx<DoctorEntity?> doctorProfile = Rx<DoctorEntity?>(null);
  final Rx<File?> selectedImageFile = Rx<File?>(null);
  
  final DoctorProfileUsecase doctorProfileUsecase;
  final UpdateDoctorProfileUsecase updateDoctorProfileUsecase;
  final UpdatefotoDoctorProfileUsecase updatefotoDoctorProfileUsecase;
  
  late TextEditingController nombreController;
  late TextEditingController apellidosController;
  late TextEditingController especialidadController;
  late TextEditingController direccionController;
  late TextEditingController emailController;
  late TextEditingController telefonoController;
  late TextEditingController numeroLicenciaController;
  late TextEditingController tituloController;
  late TextEditingController disciplinaController;
  late TextEditingController institucionController;
  late TextEditingController certificacionController;
  
  PrefilDortorController({
    required this.doctorProfileUsecase,
    required this.updateDoctorProfileUsecase,
    required this.updatefotoDoctorProfileUsecase,
  });
  
  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    loadProfile();
  }
  
  void _initializeControllers() {
    nombreController = TextEditingController();
    apellidosController = TextEditingController();
    especialidadController = TextEditingController();
    direccionController = TextEditingController();
    emailController = TextEditingController();
    telefonoController = TextEditingController();
    numeroLicenciaController = TextEditingController();
    tituloController = TextEditingController();
    disciplinaController = TextEditingController();
    institucionController = TextEditingController();
    certificacionController = TextEditingController();
  }
  
  void _populateControllers() {
    if (doctorProfile.value != null) {
      final doctor = doctorProfile.value!;
      nombreController.text = doctor.nombre ?? '';
      apellidosController.text = doctor.apellidos ?? '';
      especialidadController.text = doctor.especialidad;
      direccionController.text = doctor.direccion;
      emailController.text = doctor.email ?? '';
      telefonoController.text = doctor.telefono;
      numeroLicenciaController.text = doctor.numeroLicencia;
      tituloController.text = doctor.titulo ?? '';
      disciplinaController.text = doctor.especialidad;
      institucionController.text = doctor.institucion ?? '';
      certificacionController.text = doctor.certificacion ?? '';
    }
  }
  
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final profile = await doctorProfileUsecase.execute();
      doctorProfile.value = profile;
      _populateControllers();
    } catch (e) {
      showErrorSnackbar('No se pudo cargar el perfil');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> pickAndUploadProfilePhoto() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      
      if (result != null && result.files.single.path != null) {
        selectedImageFile.value = File(result.files.single.path!);
        await uploadProfilePhoto(result.files.single.path!);
      }
    } catch (e) {
      showErrorSnackbar('No se pudo seleccionar la foto');
    }
  }
  
  Future<void> uploadProfilePhoto(String imagePath) async {
    try {
      isUploadingPhoto.value = true;
      await updatefotoDoctorProfileUsecase.execute(imagePath);
      await loadProfile();
      showSuccessSnackbar('Foto de perfil actualizada correctamente');
    } catch (e) {
      selectedImageFile.value = null;
      showErrorSnackbar('No se pudo actualizar la foto de perfil');
    } finally {
      isUploadingPhoto.value = false;
    }
  }
  
  Future<void> updateAccountSettings() async {
    try {
      isUpdating.value = true;
      
      final updatedDoctor = DoctorEntity(
        userId: doctorProfile.value?.userId,
        nombreCompleto: '${nombreController.text} ${apellidosController.text}',
        nombre: nombreController.text,
        apellidos: apellidosController.text,
        email: emailController.text,
        numeroLicencia: numeroLicenciaController.text,
        especialidad: especialidadController.text,
        experienciaTiempo: doctorProfile.value?.experienciaTiempo ?? 0,
        fechaNacimiento: doctorProfile.value?.fechaNacimiento ?? '',
        telefono: telefonoController.text,
        direccion: direccionController.text,
        biografia: doctorProfile.value?.biografia ?? '',
        educacion: doctorProfile.value?.educacion,
        foto: doctorProfile.value?.foto,
        titulo: doctorProfile.value?.titulo,
        institucion: doctorProfile.value?.institucion,
        certificacion: doctorProfile.value?.certificacion,
        institucionCertificacion: doctorProfile.value?.institucionCertificacion,
      );
      
      await updateDoctorProfileUsecase.execute(updatedDoctor);
      await loadProfile();
      showSuccessSnackbar('Configuración de cuenta actualizada correctamente');
    } catch (e) {
      showErrorSnackbar('No se pudo actualizar la configuración de cuenta');
    } finally {
      isUpdating.value = false;
    }
  }
  
  Future<void> updateAcademicFormation() async {
    try {
      isUpdating.value = true;
      
      final updatedDoctor = DoctorEntity(
        userId: doctorProfile.value?.userId,
        nombreCompleto: doctorProfile.value?.nombreCompleto ?? '',
        nombre: doctorProfile.value?.nombre,
        apellidos: doctorProfile.value?.apellidos,
        email: doctorProfile.value?.email,
        numeroLicencia: doctorProfile.value?.numeroLicencia ?? '',
        especialidad: disciplinaController.text,
        experienciaTiempo: doctorProfile.value?.experienciaTiempo ?? 0,
        fechaNacimiento: doctorProfile.value?.fechaNacimiento ?? '',
        telefono: doctorProfile.value?.telefono ?? '',
        direccion: doctorProfile.value?.direccion ?? '',
        biografia: doctorProfile.value?.biografia ?? '',
        educacion: doctorProfile.value?.educacion,
        foto: doctorProfile.value?.foto,
        titulo: tituloController.text,
        institucion: institucionController.text,
        certificacion: certificacionController.text,
        institucionCertificacion: doctorProfile.value?.institucionCertificacion,
      );
      
      await updateDoctorProfileUsecase.execute(updatedDoctor);
      await loadProfile();
      showSuccessSnackbar('Formación académica actualizada correctamente');
    } catch (e) {
      showErrorSnackbar('No se pudo actualizar la formación académica');
    } finally {
      isUpdating.value = false;
    }
  }
  
  @override
  void onClose() {
    nombreController.dispose();
    apellidosController.dispose();
    especialidadController.dispose();
    direccionController.dispose();
    emailController.dispose();
    telefonoController.dispose();
    numeroLicenciaController.dispose();
    tituloController.dispose();
    disciplinaController.dispose();
    institucionController.dispose();
    certificacionController.dispose();
    super.onClose();
  }
}