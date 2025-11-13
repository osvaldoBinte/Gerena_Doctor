import 'package:flutter/material.dart';
import 'package:gerena/common/controller/promotionController/promotion_controller.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/perfil/widgets_pefil.dart';
import 'package:gerena/common/widgets/shareProcedureWidget/promotion_preview_widget.dart';
import 'package:gerena/features/doctors/presentacion/page/editperfildoctor/prefil_dortor_controller.dart';
import 'package:gerena/page/dashboard/dashboard_controller.dart';
import 'package:gerena/page/dashboard/dashboard_page.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfileContent extends StatefulWidget {
  const UserProfileContent({Key? key}) : super(key: key);

  @override
  State<UserProfileContent> createState() => _UserProfileContentState();
}

class _UserProfileContentState extends State<UserProfileContent> {
     final PrefilDortorController controller= Get.find<PrefilDortorController>();

 @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1200;

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (controller.doctorProfile.value == null) {
        return Center(
          child: Text('No se pudo cargar el perfil'),
        );
      }

      return Container(
        color: GerenaColors.backgroundColorfondo,
        child: isSmallScreen
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    buildProfileSection(),
                    const SizedBox(height: 20),
                    _buildRightSections(),
                  ],
                ),
              )
            : Row(
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
        _buildConnectedAccountsSection(),
        const SizedBox(height: 20),
        _buildLinksSection(),
        const SizedBox(height: 20),
        _buildPromocionSection(),
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
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: GerenaColors.backgroundColorfondo,
                        boxShadow: [GerenaColors.mediumShadow],
                      ),
                      child: ClipRRect(
                        child: Image.network(
                          doctor.foto!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 80,
                              color: GerenaColors.primaryColor,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: GerenaColors.cardColor,
                          boxShadow: [GerenaColors.mediumShadow]),
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
                                '250 puntos',
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
                          color: GerenaColors.cardColor,
                          boxShadow: [GerenaColors.mediumShadow]),
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
                            'Carolina Fernández',
                            style: GoogleFonts.rubik(
                              fontSize: 13,
                              color: GerenaColors.textPrimaryColor,
                            ),
                          ),
                          Text(
                            'Lun. - Sáb. 9:00 a.m. a 6:00 p.m.',
                            style: GoogleFonts.rubik(
                              fontSize: 11,
                              color: GerenaColors.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GerenaColors.widgetButton(
                                onPressed: () {
                                  print('Botón contactar presionado');
                                },
                                text: 'CONTACTAR',
                                showShadow: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            MouseRegion(
              child: Column(
                children: [
                  buildProfileMenuItem('Historial de pedidos'),
                  buildProfileMenuItem('Membresía'),
                  buildProfileMenuItem('Facturación'),
                  buildProfileMenuItem('Cédula profesional',
                      icon: 'assets/icons/headset_mic.png'),
                  buildProfileMenuItem('Contáctanos'),
                  buildProfileMenuItem('Sugerencias'),
                  buildProfileMenuItem('Preguntas frecuentes'),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RoutesNames.loginPage);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          Text(
                            'Cerrar sesión',
                            style: GoogleFonts.rubik(
                              fontSize: 14,
                              color: GerenaColors.textTertiaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSettingsSection() {
  final doctor = controller.doctorProfile.value!;
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
                        child: GerenaColors.buildLabeledTextField(
                          'Nombre/s*',
                          doctor.nombre ?? '',
                          hintText: 'Juan Pedro',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: GerenaColors.buildLabeledTextField(
                        'Apellidos*',
                        doctor.apellidos?? '',
                        hintText: 'González Pérez',
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
                        doctor.especialidad,
                        hintText: 'Cirujano estético',
                      ),
                      const SizedBox(height: 15),
                      GerenaColors.buildLabeledTextField(
                        'Dirección',
                        doctor.direccion,
                        hintText: 'Col. Providencia, Av. Lorem ipsum #3050',
                      ),
                      const SizedBox(height: 15),
                      GerenaColors.buildLabeledTextField(
                        'Email',
                        doctor.email,
                        hintText: 'doctor@ejemplo.com',
                      ),
                      const SizedBox(height: 15),
                      GerenaColors.buildLabeledTextField(
                        'Teléfono',
                        doctor.telefono,
                        hintText: '33 1234 5678',
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
                          doctor.numeroLicencia,
                          hintText: '1234567',
                        ),
                      ),
                      const Spacer(),
                      
                      /*SizedBox(
                        width: 100,
                        child: GerenaColors.widgetButton(
                          onPressed: () {
                            print('Guardando configuración de cuenta');
                          },
                          text: 'GUARDAR',
                          borderRadius: 5,
                          showShadow: false,
                        ),
                      ),*/
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
}
  Widget _buildAcademicFormationSection() {
  final doctor = controller.doctorProfile.value!;

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
                      doctor.titulo ?? '',
                      hintText: 'Ej. Rinomodelación',
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
                      doctor.especialidad,
                      hintText: 'Ej. Medicina estética',
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
                      doctor.institucion ?? '',
                      hintText: 'Ej. Universidad de Guadalajara',
                    ),
                  ),
                  const SizedBox(width: 15),
                  
                  Flexible(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: SizedBox(
                          width: 100,
                          /*child: GerenaColors.widgetButton(
                            onPressed: () {
                              print('Guardando formación académica 1');
                              // Aquí puedes implementar la lógica de guardado
                            },
                            text: 'GUARDAR',
                            showShadow: false,
                            borderRadius: 5,
                          ),*/
                        ),
                      ),
                    ),
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
                      doctor.certificacion ?? '',
                      hintText: 'Ej. Certificación en Botox Avanzado',
                    ),
                  ),
                  const SizedBox(width: 15),
                  Flexible(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: SizedBox(
                          width: 100,
                         /* child: GerenaColors.widgetButton(
                            onPressed: () {
                              print('Guardando certificaciones');
                              // Aquí puedes implementar la lógica de guardado
                            },
                            text: 'GUARDAR',
                            showShadow: false,
                            borderRadius: 5,
                          ),*/
                        ),
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
Widget _buildAcademicFormationSectio2n() {
  final doctor = controller.doctorProfile.value!;

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
                      'Educación',
                      doctor.educacion,
                      hintText: 'Ej. Universidad de Guadalajara - Medicina',
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
                      'Especialidad',
                      doctor.especialidad,
                      hintText: 'Ej. Medicina estética',
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
                      'Experiencia (años)',
                      doctor.experienciaTiempo > 0 
                        ? doctor.experienciaTiempo.toString() 
                        : '',
                      hintText: 'Ej. 5',
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
                      'Biografía',
                      doctor.biografia,
                      hintText: 'Describe tu experiencia profesional',
                    ),
                  ),
                  const SizedBox(width: 15),
                  Flexible(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: SizedBox(
                          width: 100,
                          child: GerenaColors.widgetButton(
                            onPressed: () {
                              print('Guardando formación académica');
                            },
                            text: 'GUARDAR',
                            showShadow: false,
                            borderRadius: 5,
                          ),
                        ),
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
              icon: Icon(
                Icons.menu,
                size: 20,
                color: GerenaColors.textSecondaryColor,
              ),
              socialIcon: 'assets/linkedin.png',
              name: 'LinkedIn',
              isConnected: false,
            ),
            Divider(height: 2, color: GerenaColors.colorinput),
            _socialMediaConnectRow(
              icon: Icon(
                Icons.menu,
                size: 20,
                color: GerenaColors.textSecondaryColor,
              ),
              socialIcon: 'assets/facebook.png',
              name: 'Facebook',
              isConnected: false,
            ),
            Divider(height: 2, color: GerenaColors.colorinput),
            _socialMediaConnectRow(
              icon: Icon(
                Icons.menu,
                size: 20,
                color: GerenaColors.textSecondaryColor,
              ),
              socialIcon: 'assets/twitter.png',
              name: 'X',
              isConnected: false,
            ),
            Divider(height: 2, color: GerenaColors.colorinput),
            _socialMediaConnectRow(
              icon: Icon(
                Icons.menu,
                size: 20,
                color: GerenaColors.textSecondaryColor,
              ),
              socialIcon: 'assets/instagram.png',
              name: 'Instagram',
              isConnected: false,
            ),
          ],
        ),
      ),
    );
  }

  final PromotionController promotionController =
      Get.put(PromotionController());

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

  Widget _buildLinksSection() {
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
              'Vínculos',
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 2,
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                       
                        Expanded(
                          child: GerenaColors.buildLabeledTextField('URL', ''),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: GerenaColors.widgetButton(
                    onPressed: () {
                      print('Guardando vínculo');
                    },
                    text: 'GUARDAR',
                    borderRadius: 5,
                    showShadow: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _labeledDropdownField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.rubik(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: GerenaColors.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: GerenaColors.smallBorderRadius,
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: InputBorder.none,
            ),
            icon: Icon(
              Icons.arrow_drop_down,
              color: GerenaColors.primaryColor,
            ),
            onChanged: (String? newValue) {},
            items:
                <String>[value].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: GoogleFonts.rubik(
                    color: GerenaColors.textPrimaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _socialMediaConnectRow({
    required Widget icon,
    required String socialIcon,
    required String name,
    required bool isConnected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Image.asset(
            socialIcon,
            width: 20,
            height: 20,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 10),
          Text(
            name,
            style: GoogleFonts.rubik(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: GerenaColors.textPrimaryColor,
            ),
          ),
          const Spacer(),
          GerenaColors.widgetButton(
            onPressed: () {
              print('Conectando con $name');
            },
            text: 'Connect $name',
            backgroundColor: GerenaColors.colorback,
            textColor: GerenaColors.colorBotonNavbar,
            borderRadius: 50,
            showShadow: false,
          ),
        ],
      ),
    );
  }
}
