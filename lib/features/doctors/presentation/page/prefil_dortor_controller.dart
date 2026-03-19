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

  final RxMap<String, bool> editingModes = <String, bool>{
    'linkedin': false,
    'facebook': false,
    'twitter': false,
    'instagram': false,
  }.obs;

  final DoctorProfileUsecase doctorProfileUsecase;
  final UpdateDoctorProfileUsecase updateDoctorProfileUsecase;
  final UpdatefotoDoctorProfileUsecase updatefotoDoctorProfileUsecase;

  late final TextEditingController nombreController;
  late final TextEditingController apellidosController;
  late final TextEditingController especialidadController;
  late final TextEditingController direccionController;
  late final TextEditingController emailController;
  late final TextEditingController telefonoController;
  late final TextEditingController numeroLicenciaController;
  late final TextEditingController tituloController;
  late final TextEditingController disciplinaController;
  late final TextEditingController institucionController;
  late final TextEditingController certificacionController;
  late final TextEditingController fechaNacimientoController;
  late final TextEditingController linkedinController;
  late final TextEditingController facebookController;
  late final TextEditingController twitterController;
  late final TextEditingController instagramController;

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
    fechaNacimientoController = TextEditingController();

    linkedinController = TextEditingController();
    facebookController = TextEditingController();
    twitterController = TextEditingController();
    instagramController = TextEditingController();
  }

  void _populateControllers() {
    if (doctorProfile.value == null) return;

    final doctor = doctorProfile.value!;

    try {
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
      fechaNacimientoController.text =
          formatFechaNacimiento(doctor.fechaNacimiento);

      linkedinController.text = doctor.linkedIn ?? '';
      facebookController.text = doctor.facebook ?? '';
      twitterController.text = doctor.x ?? '';
      instagramController.text = doctor.instagram ?? '';
    } catch (e) {
      print('Error al poblar controllers: $e');
    }
  }

  String formatFechaNacimiento(String? fecha) {
    if (fecha == null || fecha.isEmpty) return '';
    try {
      final parsed = DateTime.parse(fecha);
      return "${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year}";
    } catch (_) {
      return fecha;
    }
  }

Future<void> selectFechaNacimiento(BuildContext context) async {
  final DateTime maxDate = DateTime(
    DateTime.now().year - 18,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime initialDate = maxDate;

  final textoActual = fechaNacimientoController.text;
  if (textoActual.isNotEmpty) {
    try {
      DateTime? parsed;

      if (textoActual.contains('/')) {
        // Formato dd/MM/yyyy (viene de formatFechaNacimiento)
        final parts = textoActual.split('/');
        if (parts.length == 3) {
          parsed = DateTime(
            int.parse(parts[2]), // año
            int.parse(parts[1]), // mes
            int.parse(parts[0]), // día
          );
        }
      } else {
        // Formato ISO: yyyy-MM-dd o yyyy-MM-ddTHH:mm:ss
        parsed = DateTime.parse(textoActual);
      }

      if (parsed != null && parsed.isBefore(maxDate)) {
        initialDate = parsed;
      }
    } catch (_) {}
  }

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(1920),
    lastDate: maxDate,
    locale: const Locale('es', 'MX'),
  );

  if (picked != null) {
    // Guarda en ISO para enviar al servidor
    fechaNacimientoController.text =
        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
  }
}
String? _toIso8601(String? fecha) {
  if (fecha == null || fecha.isEmpty) return null;
  try {
    // Intenta parsear formato yyyy-MM-dd (lo que guarda el DatePicker)
    final parsed = DateTime.parse(fecha);
    return parsed.toIso8601String(); // "2008-01-22T00:00:00.000"
  } catch (_) {
    return null;
  }
}
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
        showErrorSnackbar('Plataforma no reconocida');
        return;
    }

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        showErrorSnackbar('No se pudo abrir el enlace');
      }
    } catch (e) {
      showErrorSnackbar('URL inválida');
    }
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final profile = await doctorProfileUsecase.execute();
      doctorProfile.value = profile;
      _populateControllers();
    } catch (e) {
    //  showErrorSnackbar('No se pudo cargar el perfil');
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
DoctorEntity _buildUpdatedDoctor() {
  return DoctorEntity(
    userId: doctorProfile.value?.userId,
    nombreCompleto: '${nombreController.text} ${apellidosController.text}',
    nombre: nombreController.text,
    apellidos: apellidosController.text,
    email: emailController.text,
    numeroLicencia: numeroLicenciaController.text,
    especialidad: especialidadController.text,
    experienciaTiempo: doctorProfile.value?.experienciaTiempo ?? 0,
    fechaNacimiento: _toIso8601(
      fechaNacimientoController.text.isEmpty
          ? doctorProfile.value?.fechaNacimiento
          : fechaNacimientoController.text,
    ),
    telefono: telefonoController.text,
    direccion: direccionController.text,
    biografia: doctorProfile.value?.biografia ?? '',
    educacion: doctorProfile.value?.educacion,
    foto: doctorProfile.value?.foto,
    // Campos académicos
    titulo: tituloController.text,
    institucion: institucionController.text,
    certificacion: certificacionController.text,
    institucionCertificacion: doctorProfile.value?.institucionCertificacion,
    // Redes sociales
    linkedIn: linkedinController.text.isEmpty ? null : linkedinController.text,
    facebook: facebookController.text.isEmpty ? null : facebookController.text,
    x: twitterController.text.isEmpty ? null : twitterController.text,
    instagram: instagramController.text.isEmpty ? null : instagramController.text,
    // Vendedor (solo lectura)
    nombreVendedor: doctorProfile.value?.nombreVendedor,
    whatsAppVendedor: doctorProfile.value?.whatsAppVendedor,
    correoVendedor: doctorProfile.value?.correoVendedor,
    puntosDisponibles: doctorProfile.value?.puntosDisponibles,
  );
}

Future<void> updateAccountSettings() async {
  // Validar teléfono antes de continuar
  final errorTel = _validarTelefono(telefonoController.text);
  if (errorTel != null) {
    showErrorSnackbar(errorTel);
    return;
  }

  try {
    isUpdating.value = true;
    await updateDoctorProfileUsecase.execute(_buildUpdatedDoctor());
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
    await updateDoctorProfileUsecase.execute(_buildUpdatedDoctor());
    await loadProfile();
    showSuccessSnackbar('Formación académica actualizada correctamente');
  } catch (e) {
    showErrorSnackbar('No se pudo actualizar la formación académica');
  } finally {
    isUpdating.value = false;
  }
}
String? _validarTelefono(String telefono) {
  if (telefono.isEmpty) return null; 

  final soloDigitos = telefono.replaceAll(RegExp(r'\D'), '');

  if (soloDigitos.length != 10) {
    return 'El teléfono debe tener exactamente 10 dígitos\nEj: 9611234567';
  }

  return null; // válido
}
  void openWhatsApp() async {
    final phoneNumber = doctorProfile.value?.whatsAppVendedor;

    if (phoneNumber == null || phoneNumber.isEmpty) {
      showErrorSnackbar('No hay número de WhatsApp disponible');
      return;
    }

    String cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    if (!cleanPhone.startsWith('+')) {
      cleanPhone = '+52$cleanPhone';
    }

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
  @override
  void onClose() {
    super.onClose();
  }
}
