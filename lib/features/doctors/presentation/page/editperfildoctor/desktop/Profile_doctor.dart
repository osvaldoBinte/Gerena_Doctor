import 'package:flutter/material.dart';
import 'package:gerena/common/controller/promotionController/promotion_controller.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/perfil/widgets_pefil.dart';
import 'package:gerena/common/widgets/shareProcedureWidget/promotion_preview_widget.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/doctors/presentation/page/prefil_dortor_controller.dart';
import 'package:gerena/features/doctors/presentation/widget/loading/doctor_profile_loading.dart';
import 'package:gerena/features/doctors/presentation/widget/social_networks_widget.dart';
import 'package:gerena/features/home/dashboard/dashboard_controller.dart';
import 'package:gerena/features/home/dashboard/dashboard_page.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileContent extends StatefulWidget {
  const UserProfileContent({Key? key}) : super(key: key);

  @override
  State<UserProfileContent> createState() => _UserProfileContentState();
}

class _UserProfileContentState extends State<UserProfileContent> {
  final PrefilDortorController controller = Get.find<PrefilDortorController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: DoctorProfileLoading(),
        );
      }

      if (controller.doctorProfile.value == null) {
        return Center(
          child: Text('No se pudo cargar el perfil'),
        );
      }

      return Container(
        color: GerenaColors.backgroundColorfondo,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 350,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: buildProfileSection(),
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildRightSections(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

Widget _buildRightSections() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildAccountSettingsSection(),
      const SizedBox(height: 20),
      _buildAcademicFormationSection(),
      const SizedBox(height: 20),
      SocialNetworksWidget(), // ← Llamada simple sin parámetros
      const SizedBox(height: 20),
    ],
  );
}

  Widget buildProfileSection() {
    final doctor = controller.doctorProfile.value!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      color: GerenaColors.backgroundColorfondo,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(() => Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 300,
                              decoration: BoxDecoration(
                                color: GerenaColors.backgroundColorfondo,
                                boxShadow: [GerenaColors.mediumShadow],
                              ),
                              child: ClipRRect(
                                child: controller.selectedImageFile.value != null
                                    ? Image.file(
                                        controller.selectedImageFile.value!,
                                        fit: BoxFit.cover,
                                      )
                                    : controller.doctorProfile.value?.foto != null
                                        ? Image.network(
                                            controller.doctorProfile.value!.foto!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Icon(
                                                Icons.person,
                                                size: 80,
                                                color: GerenaColors.primaryColor,
                                              );
                                            },
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                          loadingProgress.expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                          )
                                        : Icon(
                                            Icons.person,
                                            size: 80,
                                            color: GerenaColors.primaryColor,
                                          ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: controller.isUploadingPhoto.value
                                  ? Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
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
                                  : Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => controller.pickAndUploadProfilePhoto(),
                                        borderRadius: BorderRadius.circular(25),
                                        child: Container(
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Image.asset(
                                            'assets/icons/edit.png',
                                            width: 20,
                                            height: 20,
                                            color: GerenaColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        )),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: GerenaColors.cardColor, boxShadow: [GerenaColors.mediumShadow]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recompensas:',
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '${doctor.puntosDisponibles ?? "0"} puntos',
                                style: GoogleFonts.rubik(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: GerenaColors.cardColor, boxShadow: [GerenaColors.mediumShadow]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ejecutivo asignado:',
                            style: GoogleFonts.rubik(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: GerenaColors.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            doctor.nombreVendedor ?? 'Sin ejecutivo asignado',
                            style: GoogleFonts.rubik(
                              fontSize: 13,
                              color: GerenaColors.textPrimaryColor,
                            ),
                          ),
                          if (doctor.correoVendedor != null && doctor.correoVendedor!.isNotEmpty)
                            Text(
                              doctor.correoVendedor!,
                              style: GoogleFonts.rubik(
                                fontSize: 11,
                                color: GerenaColors.textSecondaryColor,
                              ),
                            ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GerenaColors.widgetButton(
                                onPressed: () {
                                  controller.openWhatsApp();
                                },
                                text: 'CONTACTAR',
                                showShadow: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        buildProfileMenuItem('Historial de pedidos'),
                        buildProfileMenuItem('Membresía'),
                      
                        buildProfileMenuItem('Preguntas frecuentes'),
                        buildProfileMenuItem('Cerrar sesión'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget _buildAccountSettingsSection() {
  return Obx(() {
    final doctor = controller.doctorProfile.value;

    if (doctor == null || controller.isLoading.value) {
      return SizedBox.shrink();
    }
      return Card(
        elevation: GerenaColors.elevationSmall,
        shape: RoundedRectangleBorder(
          borderRadius: GerenaColors.mediumBorderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configuración de la cuenta',
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: GerenaColors.textPrimaryColor,
                ),
              ),
              Text(
                '*Campo obligatorio',
                style: GoogleFonts.rubik(
                  fontSize: 12,
                  color: GerenaColors.textSecondaryColor,
                ),
              ),
              Text(
                'La información presentada en los siguientes apartados será mostrada según sea llenada en la aplicación para clientes de Gerena.',
                style: GoogleFonts.rubik(
                  fontSize: 14,
                  color: GerenaColors.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: 0.8,
                            child:GerenaColors.buildLabeledTextField(
                            'Nombre/s*',
                            doctor.nombre ?? '', 
                            hintText: 'Juan Pedro',
                            controller: controller.nombreController,
                            readOnly: true,
                          ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: FractionallySizedBox(
                          widthFactor: 0.8,
                          child:  GerenaColors.buildLabeledTextField(
                          'Apellidos*',
                          doctor.apellidos ?? '',
                          hintText: 'González Pérez',
                          controller: controller.apellidosController,
                          readOnly: true,
                        ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.64,
                      child: Column(
                        children: [
                          GerenaColors.buildLabeledTextField(
                            'Profesión*',
                            controller.especialidadController.text,
                            hintText: 'Cirujano estético',
                            controller: controller.especialidadController,
                          ),
                          const SizedBox(height: 15),
                          GerenaColors.buildLabeledTextField(
                            'Dirección',
                            controller.direccionController.text,
                            hintText: 'Col. Providencia, Av. Lorem ipsum #3050',
                            controller: controller.direccionController,
                          ),
                          const SizedBox(height: 15),
                          GerenaColors.buildLabeledTextField(
                            'Email',
                            controller.emailController.text,
                            hintText: 'doctor@ejemplo.com',
                            controller: controller.emailController,
                          ),
                          const SizedBox(height: 15),
                          GerenaColors.buildLabeledTextField(
                            'Teléfono',
                            controller.telefonoController.text,
                            hintText: '33 1234 5678',
                            controller: controller.telefonoController,
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: constraints.maxWidth * 0.64,
                            child: GerenaColors.buildLabeledTextField(
                              'Licencia Profesional',
                              controller.numeroLicenciaController.text,
                              hintText: '1234567',
                              controller: controller.numeroLicenciaController,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 100,
                            child: GerenaColors.widgetButton(
                              onPressed: () => controller.updateAccountSettings(),
                              text: 'GUARDAR',
                              borderRadius: 5,
                              showShadow: false,
                              isLoading: controller.isUpdating.value,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAcademicFormationSection() {
    return Card(
      elevation: GerenaColors.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: GerenaColors.mediumBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Formación académica',
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: GerenaColors.textPrimaryColor,
              ),
            ),
            Text(
              'La información presentada en los siguientes apartados será mostrada según sea llenada en la aplicación para clientes de Gerena.',
              style: GoogleFonts.rubik(
                fontSize: 14,
                color: GerenaColors.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 5,
                      child: GerenaColors.buildLabeledTextField(
                        'Título',
                        controller.tituloController.text,
                        hintText: 'Ej. Rinomodelación',
                        controller: controller.tituloController,
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Container(),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Flexible(
                      flex: 5,
                      child: GerenaColors.buildLabeledTextField(
                        'Disciplina académica',
                        controller.disciplinaController.text,
                        hintText: 'Ej. Medicina estética',
                        controller: controller.disciplinaController,
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Container(),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      flex: 5,
                      child: GerenaColors.buildLabeledTextField(
                        'Institución',
                        controller.institucionController.text,
                        hintText: 'Ej. Universidad de Guadalajara',
                        controller: controller.institucionController,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Flexible(
                      flex: 3,
                      child: Container(),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      flex: 5,
                      child: GerenaColors.buildLabeledTextField(
                        'Certificaciones',
                        controller.certificacionController.text,
                        hintText: 'Ej. Certificación en Botox Avanzado',
                        controller: controller.certificacionController,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Flexible(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Obx(() => SizedBox(
                                width: 100,
                                child: GerenaColors.widgetButton(
                                  onPressed: () => controller.updateAcademicFormation(),
                                  text: 'GUARDAR',
                                  showShadow: false,
                                  borderRadius: 5,
                                  isLoading: controller.isUpdating.value,
                                ),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectedAccountsSection() {
    return Card(
      elevation: GerenaColors.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: GerenaColors.mediumBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WEB',
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: GerenaColors.textPrimaryColor,
              ),
            ),
            Text(
              'La información presentada en los siguientes apartados será mostrada según sea llenada en la aplicación para clientes de Gerena.',
              style: GoogleFonts.rubik(
                fontSize: 14,
                color: GerenaColors.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Image.asset(
                  'assets/icons/link.png',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Cuentas conectadas',
                  style: GoogleFonts.rubik(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              'Genera confianza en tu red conectando tus perfiles de redes sociales',
              style: GoogleFonts.rubik(
                fontSize: 14,
                color: GerenaColors.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 15),
            Divider(height: 2, color: GerenaColors.colorinput),
            _socialMediaConnectRow(
              socialIcon: 'assets/linkedin.png',
              name: 'LinkedIn',
              textcontroller: controller.linkedinController,
              socialKey: 'linkedin',
            ),
            Divider(height: 2, color: GerenaColors.colorinput),
            _socialMediaConnectRow(
              socialIcon: 'assets/facebook.png',
              name: 'Facebook',
              textcontroller: controller.facebookController,
              socialKey: 'facebook',
            ),
            Divider(height: 2, color: GerenaColors.colorinput),
            _socialMediaConnectRow(
              socialIcon: 'assets/twitter.png',
              name: 'X',
              textcontroller: controller.twitterController,
              socialKey: 'twitter',
            ),
            Divider(height: 2, color: GerenaColors.colorinput),
            _socialMediaConnectRow(
              socialIcon: 'assets/instagram.png',
              name: 'Instagram',
              textcontroller: controller.instagramController,
              socialKey: 'instagram',
            ),
            Divider(height: 2, color: GerenaColors.colorinput),
          ],
        ),
      ),
    );
  }

  final RxMap<String, bool> _editingModes = <String, bool>{
    'linkedin': false,
    'facebook': false,
    'twitter': false,
    'instagram': false,
  }.obs;

  Widget _socialMediaConnectRow({
    required String socialIcon,
    required String name,
    required TextEditingController textcontroller,
    required String socialKey,
  }) {
    return Obx(() {
      final isEditing = _editingModes[socialKey] ?? false;
      final hasValue = textcontroller.text.isNotEmpty;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    hasValue ? Icons.open_in_new : Icons.link_off,
                    color: hasValue ? GerenaColors.primaryColor : Colors.grey[400],
                    size: 20,
                  ),
                  onPressed: hasValue ? () => controller.openSocialMediaProfile(name, textcontroller.text) : null,
                  tooltip: hasValue ? 'Abrir perfil' : 'No conectado',
                ),
                const SizedBox(width: 10),
                Image.asset(
                  socialIcon,
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    name,
                    style: GoogleFonts.rubik(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: GerenaColors.textPrimaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (!isEditing)
                  GerenaColors.widgetButton(
                    onPressed: () {
                      _editingModes[socialKey] = true;
                    },
                    text: hasValue ? 'Editar' : 'Connect $name',
                    backgroundColor: GerenaColors.colorback,
                    textColor: GerenaColors.colorBotonNavbar,
                    borderRadius: 50,
                    showShadow: false,
                  ),
              ],
            ),
            if (isEditing) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GerenaColors.buildLabeledTextField(
                      'Usuario de $name',
                      textcontroller.text,
                      controller: textcontroller,
                      hintText: '@tu-usuario',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: GerenaColors.widgetButton(
                      onPressed: () async {
                        if (textcontroller.text.isEmpty) {
                          showErrorSnackbar('Por favor ingresa tu nombre de usuario');
                          return;
                        }

                        await this.controller.updateAccountSettings();
                        _editingModes[socialKey] = false;
                      },
                      text: 'GUARDAR',
                      borderRadius: 5,
                      showShadow: false,
                      isLoading: this.controller.isUpdating.value,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey[600],
                      ),
                      onPressed: this.controller.isUpdating.value
                          ? null
                          : () {
                              if (hasValue) {
                                textcontroller.text = this.controller.getValueForSocial(socialKey) ?? '';
                              } else {
                                textcontroller.clear();
                              }
                              _editingModes[socialKey] = false;
                            },
                      tooltip: 'Cancelar',
                    ),
                  ),
                ],
              ),
            ],
            if (!isEditing && hasValue) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Text(
                  textcontroller.text,
                  style: GoogleFonts.rubik(
                    fontSize: 13,
                    color: GerenaColors.textSecondaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  final PromotionController promotionController = Get.put(PromotionController());

  Widget _buildPromocionSection() {
    return Card(
      elevation: GerenaColors.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: GerenaColors.mediumBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Anuncio/Publicidad',
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: GerenaColors.textPrimaryColor,
              ),
            ),
            Text(
              'Comparte con tus pacientes las imagenes de tus promociones',
              style: GoogleFonts.rubik(
                fontSize: 14,
                color: GerenaColors.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 20),
            PromotionPreviewWidget(
              promotionController: promotionController,
            ),
          ],
        ),
      ),
    );
  }
}