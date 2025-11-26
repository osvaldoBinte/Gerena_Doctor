import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/doctors/presentation/page/editperfildoctor/movil/controller_perfil_configuration.dart';
import 'package:gerena/features/doctors/presentation/page/prefil_dortor_controller.dart';
import 'package:gerena/features/doctors/presentation/widget/social_networks_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileConfiguration extends StatefulWidget {
  @override
  _MedicalProfileFormState createState() => _MedicalProfileFormState();
}

class _MedicalProfileFormState extends State<ProfileConfiguration> {
  final ControllerPerfilConfiguration perfilConfig = 
      Get.find<ControllerPerfilConfiguration>(tag: 'doctor');
  final PrefilDortorController doctorController = Get.find<PrefilDortorController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorfondo,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: GerenaColors.backgroundColorfondo,
          elevation: 4,
          shadowColor: GerenaColors.shadowColor,
        ),
      ),
      body: Obx(() {
        if (doctorController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/close.png',
                      width: 20,
                      height: 20,
                    ),
                    onPressed: () {
                      perfilConfig.hideConfigurationView();
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Center(
                child: Stack(
                  children: [
                    GerenaColors.createStoryRing(
                      child: ClipOval(
                        child: doctorController.selectedImageFile.value != null
                            ? Image.file(
                                doctorController.selectedImageFile.value!,
                                fit: BoxFit.cover,
                                width: 170,
                                height: 170,
                              )
                            : doctorController.doctorProfile.value?.foto != null &&
                                    doctorController.doctorProfile.value!.foto!.isNotEmpty
                                ? Image.network(
                                    doctorController.doctorProfile.value!.foto!,
                                    fit: BoxFit.cover,
                                    width: 170,
                                    height: 170,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 170,
                                        height: 170,
                                        color: GerenaColors.backgroundColorfondo,
                                        child: const Icon(
                                          Icons.person,
                                          size: 80,
                                          color: GerenaColors.primaryColor,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    width: 170,
                                    height: 170,
                                    color: GerenaColors.backgroundColorfondo,
                                    child: const Icon(
                                      Icons.person,
                                      size: 80,
                                      color: GerenaColors.primaryColor,
                                    ),
                                  ),
                      ),
                      hasStory: false,
                      size: 170,
                    ),
                    Positioned(
                      top: 0,
                      right: 15,
                      child: doctorController.isUploadingPhoto.value
                          ? Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      GerenaColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () => doctorController.pickAndUploadProfilePhoto(),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/camera_alt.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  'La información proporcionada será visible en tu perfil público y será utilizada para las citas con tus pacientes.',
                  style: GoogleFonts.rubik(
                    color: GerenaColors.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: GerenaColors.cardColor,
                  borderRadius: GerenaColors.mediumBorderRadius,
                  boxShadow: [GerenaColors.lightShadow],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INFORMACIÓN PERSONAL',
                      style: GoogleFonts.rubik(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: GerenaColors.textPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 16),
                    GerenaColors.buildLabeledTextField(
                      'Nombre/s*',
                      '',
                      controller: doctorController.nombreController,
                      readOnly:true
                    ),
                    SizedBox(height: 16),
                    GerenaColors.buildLabeledTextField(
                      'Apellidos*',
                      '',
                      controller: doctorController.apellidosController,
                      readOnly:true
                    ),
                    SizedBox(height: 16),
                    GerenaColors.buildLabeledTextField(
                      'Especialidad*',
                      '',
                      controller: doctorController.especialidadController,
                    ),
                    SizedBox(height: 16),
                    GerenaColors.buildLabeledTextField(
                      'Cédula profesional',
                      '',
                      controller: doctorController.numeroLicenciaController,
                    ),
                    SizedBox(height: 20),
                    Divider(color: GerenaColors.dividerColor),
                    SizedBox(height: 20),
                    Text(
                      'INFORMACIÓN DE CONTACTO',
                      style: GoogleFonts.rubik(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: GerenaColors.textPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 16),
                    GerenaColors.buildLabeledTextField(
                      'Correo electrónico',
                      '',
                      controller: doctorController.emailController,
                    ),
                    SizedBox(height: 16),
                    GerenaColors.buildLabeledTextField(
                      'Teléfono',
                      '',
                      controller: doctorController.telefonoController,
                    ),
                    SizedBox(height: 16),
                    GerenaColors.buildLabeledTextField(
                      'Dirección',
                      '',
                      controller: doctorController.direccionController,
                    ),
                    SizedBox(height: 20),
                    Divider(color: GerenaColors.dividerColor),
                    SizedBox(height: 20),
                    Text(
                      'FORMACIÓN ACADÉMICA',
                      style: GoogleFonts.rubik(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: GerenaColors.textPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 16),
                    GerenaColors.buildLabeledTextField(
                      'Título',
                      '',
                      controller: doctorController.tituloController,
                    ),
                    SizedBox(height: 16),
                    GerenaColors.buildLabeledTextField(
                      'Institución',
                      '',
                      controller: doctorController.institucionController,
                    ),
                    SizedBox(height: 16),
                    GerenaColors.buildLabeledTextField(
                      'Certificación',
                      '',
                      controller: doctorController.certificacionController,
                    ),
                    SizedBox(height: 20),
                    Divider(color: GerenaColors.dividerColor),
            SocialNetworksWidget(),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GerenaColors.widgetButton(
                          onPressed: () {
                            perfilConfig.hideConfigurationView();
                          },
                          text: 'CANCELAR',
                          borderRadius: 5,
                          backgroundColor: GerenaColors.cardColor,
                          textColor: GerenaColors.textSecondaryColor,
                          showShadow: false,
                        ),
                        SizedBox(width: 16),
                        Obx(() {
                          return doctorController.isUpdating.value
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        GerenaColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                )
                              : GerenaColors.widgetButton(
                                  onPressed: () async {
                                    await doctorController.updateAccountSettings();
                                    perfilConfig.hideConfigurationView();
                                  },
                                  text: 'GUARDAR',
                                  borderRadius: 5,
                                );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }
}