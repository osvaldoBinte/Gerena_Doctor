import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/doctors/domain/entities/doctor/doctor_entity.dart';
import 'package:gerena/features/doctors/domain/usecase/doctor_profile_usecase.dart';
import 'package:gerena/features/doctors/domain/usecase/update_doctor_profile_usecase.dart';
import 'package:gerena/features/doctors/domain/usecase/updatefoto_doctor_profile_usecase.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PrefilDortorController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isUploadingPhoto = false.obs;
  final Rx<DoctorEntity?> doctorProfile = Rx<DoctorEntity?>(null);
  final Rx<File?> selectedImageFile = Rx<File?>(null);

  final DoctorProfileUsecase doctorProfileUsecase;
  final UpdateDoctorProfileUsecase updateDoctorProfileUsecase;
  final UpdatefotoDoctorProfileUsecase updatefotoDoctorProfileUsecase;

  // Controllers existentes
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
  
  // Nuevos controllers para redes sociales
  late TextEditingController linkedinController;
  late TextEditingController facebookController;
  late TextEditingController twitterController;
  late TextEditingController instagramController;

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
    // Controllers existentes
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
    
    // Nuevos controllers para redes sociales
    linkedinController = TextEditingController();
    facebookController = TextEditingController();
    twitterController = TextEditingController();
    instagramController = TextEditingController();
  }

  void _populateControllers() {
    if (doctorProfile.value != null) {
      final doctor = doctorProfile.value!;
      
      // Controllers existentes
      nombreController.text = doctor.nombre ?? '';
      apellidosController.text = doctor.apellidos ?? '';
      especialidadController.text = doctor.especialidad ?? '';
      direccionController.text = doctor.direccion ?? '';
      emailController.text = doctor.email ?? '';
      telefonoController.text = doctor.telefono ?? '';
      numeroLicenciaController.text = doctor.numeroLicencia ?? '';
      tituloController.text = doctor.titulo ?? '';
      disciplinaController.text = doctor.especialidad ?? '';
      institucionController.text = doctor.institucion ?? '';
      certificacionController.text = doctor.certificacion ?? '';
      
      // Nuevos controllers para redes sociales
      linkedinController.text = doctor.linkedIn ?? '';
      facebookController.text = doctor.facebook ?? '';
      twitterController.text = doctor.x ?? '';
      instagramController.text = doctor.instagram ?? '';
    }
  }
// Método para obtener el valor de redes sociales por clave
String? getValueForSocial(String socialKey) {
  if (doctorProfile.value == null) return null;
  
  switch (socialKey) {
    case 'linkedin':
      return doctorProfile.value!.linkedIn;
    case 'facebook':
      return doctorProfile.value!.facebook;
    case 'twitter':
      return doctorProfile.value!.x;
    case 'instagram':
      return doctorProfile.value!.instagram;
    default:
      return null;
  }
}

void openSocialMediaProfile(String platform, String username) async {
  if (username.isEmpty) return;

  String cleanUsername = username.replaceAll('@', '');

  String url;
  switch (platform.toLowerCase()) {
    case 'linkedin':
      url = 'https://www.linkedin.com/in/$cleanUsername';
      break;
    case 'facebook':
      url = 'https://www.facebook.com/$cleanUsername';
      break;
    case 'x':
      url = 'https://twitter.com/$cleanUsername';
      break;
    case 'instagram':
      url = 'https://www.instagram.com/$cleanUsername';
      break;
    default:
    showErrorSnackbar('Plataforma no reconocida',);
     
      return;
  }

  try {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
          showErrorSnackbar( 'No se pudo abrir el enlace',);

    
    }
  } catch (e) {
              showErrorSnackbar( 'URL inválida',);

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
        // Redes sociales
        linkedIn: linkedinController.text.isEmpty ? null : linkedinController.text,
        facebook: facebookController.text.isEmpty ? null : facebookController.text,
        x: twitterController.text.isEmpty ? null : twitterController.text,
        instagram: instagramController.text.isEmpty ? null : instagramController.text,
        // Mantener datos del vendedor
        nombreVendedor: doctorProfile.value?.nombreVendedor,
        whatsAppVendedor: doctorProfile.value?.whatsAppVendedor,
        correoVendedor: doctorProfile.value?.correoVendedor,
        puntosDisponibles: doctorProfile.value?.puntosDisponibles,
      );

      await updateDoctorProfileUsecase.execute(updatedDoctor);
      await loadProfile();
      showSuccessSnackbar('Configuración de cuenta actualizada correctamente');
    } catch (e) {
      print('Error al actualizar: $e');
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
        // Mantener redes sociales
        linkedIn: doctorProfile.value?.linkedIn,
        facebook: doctorProfile.value?.facebook,
        x: doctorProfile.value?.x,
        instagram: doctorProfile.value?.instagram,
        // Mantener datos del vendedor
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
void openWhatsApp() async {
  final phoneNumber = doctorProfile.value?.whatsAppVendedor;
  
  if (phoneNumber == null || phoneNumber.isEmpty) {
    showErrorSnackbar('No hay número de WhatsApp disponible');
    return;
  }

  String cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

  String message = '¡Hola! Me gustaría obtener más información.';

  final whatsappUrl = Uri.parse(
      'https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}');

  try {
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(
        whatsappUrl,
        mode: LaunchMode.externalApplication,
      );
    } else {
      showErrorSnackbar(
        'No se pudo abrir WhatsApp. Asegúrate de tenerlo instalado.',
      );
    }
  } catch (e) {
    print('Error al abrir WhatsApp: $e');
    showErrorSnackbar('Ocurrió un error al intentar abrir WhatsApp');
  }
}
  @override
  void onClose() {
    // Controllers existentes
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
    
    // Nuevos controllers de redes sociales
    linkedinController.dispose();
    facebookController.dispose();
    twitterController.dispose();
    instagramController.dispose();
    
    super.onClose();
  }
}