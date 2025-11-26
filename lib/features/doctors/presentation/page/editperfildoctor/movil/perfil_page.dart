import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gerena/common/controller/promotionController/promotion_controller.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/perfil/widgets_pefil.dart';
import 'package:gerena/common/widgets/shareProcedureWidget/promotion_preview_widget.dart';
import 'package:gerena/common/widgets/shareProcedureWidget/share_procedure_widget.dart';
import 'package:gerena/features/doctors/presentation/page/editperfildoctor/movil/controller_perfil_configuration.dart';
import 'package:gerena/features/doctors/presentation/page/editperfildoctor/movil/perfil_edit_page.dart';
import 'package:gerena/features/doctors/presentation/page/prefil_dortor_controller.dart';
import 'package:gerena/features/doctors/presentation/widget/share_and_procedures_widget.dart';
import 'package:gerena/features/review/presentation/page/reviews_widget.dart';
import 'package:gerena/movil/home/start_controller.dart';
import 'package:gerena/features/doctors/presentation/page/editperfildoctor/movil/procedure_Widget.dart';
import 'package:gerena/movil/widgets/review_widget.dart';
import 'package:gerena/features/marketplace/presentation/page/getmylastpaidorder/estatusdepedido/estatus_de_pedido.dart';
import 'package:gerena/features/marketplace/presentation/page/getmylastpaidorder/widgets_status_pedido.dart';
import 'package:gerena/common/controller/mediacontroller/media_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorProfilePage extends StatefulWidget {
  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  final StartController controller = Get.find<StartController>();
  final MediaController mediaController = Get.put(MediaController());
  final PromotionController promotionController = Get.put(PromotionController());
  final PrefilDortorController doctorController = Get.find<PrefilDortorController>();
  final ControllerPerfilConfiguration perfilConfiguration = 
      Get.put(ControllerPerfilConfiguration(), tag: 'doctor');

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: GerenaColors.backgroundColorFondo,
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: AppBar(
        backgroundColor: GerenaColors.backgroundColorFondo,
        elevation: 4,
        shadowColor: GerenaColors.shadowColor,
      ),
    ),
    body: Obx(() {
      // Verificar si mostrar configuración
      if (perfilConfiguration.showConfiguration.value) {
        return ProfileConfiguration(); // O tu página de edición de perfil de doctor
      }

      // Vista normal del perfil
      if (doctorController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (doctorController.doctorProfile.value == null) {
        return const Center(
          child: Text('No se pudo cargar el perfil'),
        );
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildDoctorHeader(),
            ),
            const SizedBox(height: 16),
            Divider(height: 2, color: GerenaColors.dividerColor),
            const SizedBox(height: 16),
            _buildWishlistButton(),
            const SizedBox(height: 16),
            Divider(height: 2, color: GerenaColors.dividerColor),
            const SizedBox(height: 16),
            SizedBox(height: GerenaColors.paddingMedium),
            StatusCardWidget(),
            const SizedBox(height: 16),
            Divider(height: 2, color: GerenaColors.dividerColor),
            _buildRewardsSection(),
            const SizedBox(height: 16),
            Divider(height: 2, color: GerenaColors.dividerColor),
            const SizedBox(height: 16),
            _buildExecutiveSection(),
            const SizedBox(height: 16),
            Divider(height: 2, color: GerenaColors.dividerColor),
            const SizedBox(height: 16),
            Text(
              'PORTAFOLIO',
              style: GerenaColors.headingSmall,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ShareAndProceduresWidget(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RESEÑAS DE SUS PACIENTES',
                    style: GerenaColors.headingSmall,
                  ),
                  ReviewsWidget(),
                  const SizedBox(height: 16),
                /*  Text(
                    'PROMOCIONES Y DESCUENTOS ',
                    style: GerenaColors.headingSmall,
                  ),
                  const SizedBox(height: 16),
                  _buildPromocionSection(),*/
                ],
              ),
            ),
            const SizedBox(height: 16),
            Divider(height: 2, color: GerenaColors.dividerColor),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MouseRegion(
                    child: Column(
                      children: [
                        buildProfileMenuItem('Historial de pedidos'),
                        buildProfileMenuItem('Membresía'),
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
          ],
        ),
      );
    }),
  );
}

  // Widget para la sección de recompensas (dinámico)
  Widget _buildRewardsSection() {
    return Obx(() {
      final doctor = doctorController.doctorProfile.value;
      
      return Container(
        padding: const EdgeInsets.all(16),
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
                  '${doctor?.puntosDisponibles ?? "0"} puntos',
                  style: GoogleFonts.rubik(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // Widget para la sección de ejecutivo asignado (dinámico)
  Widget _buildExecutiveSection() {
    return Obx(() {
      final doctor = doctorController.doctorProfile.value;
      
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    doctor?.nombreVendedor ?? 'Sin ejecutivo asignado',
                    style: GoogleFonts.rubik(
                      fontSize: 13,
                      color: GerenaColors.textPrimaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (doctor?.correoVendedor != null && doctor!.correoVendedor!.isNotEmpty)
                    Text(
                      doctor.correoVendedor!,
                      style: GoogleFonts.rubik(
                        fontSize: 11,
                        color: GerenaColors.textPrimaryColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            GerenaColors.widgetButton(
              onPressed: () {
                doctorController.openWhatsApp();
              },
              text: 'CONTACTAR',
              showShadow: false,
              borderRadius: 20,
            ),
          ],
        ),
      );
    });
  }

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
            PromotionPreviewWidget(
              promotionController: promotionController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorHeader() {
    return Obx(() {
      final doctor = doctorController.doctorProfile.value;
      
      if (doctorController.isLoading.value) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: GerenaColors.cardDecoration,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      
      if (doctor == null) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: GerenaColors.cardDecoration,
          child: const Center(
            child: Text('No se pudo cargar la información del doctor'),
          ),
        );
      }
      
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: GerenaColors.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: GerenaColors.backgroundColorfondo,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: doctorController.selectedImageFile.value != null
                                ? Image.file(
                                    doctorController.selectedImageFile.value!,
                                    fit: BoxFit.cover,
                                  )
                                : doctor.foto != null && doctor.foto!.isNotEmpty
                                    ? Image.network(
                                        doctor.foto!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: GerenaColors.backgroundColorfondo,
                                            child: const Icon(
                                              Icons.person,
                                              size: 50,
                                              color: GerenaColors.primaryColor,
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        color: GerenaColors.backgroundColorfondo,
                                        child: const Icon(
                                          Icons.person,
                                          size: 50,
                                          color: GerenaColors.primaryColor,
                                        ),
                                      ),
                          ),
                        ),
                        // Botón para editar foto
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: doctorController.isUploadingPhoto.value
                              ? Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
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
                                    onTap: () => doctorController.pickAndUploadProfilePhoto(),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
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
                                      child: Image.asset(
                                        'assets/icons/edit.png',
                                        width: 16,
                                        height: 16,
                                        color: GerenaColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                    SizedBox(height: GerenaColors.paddingExtraLarge),
                    GerenaColors.createStarRating(rating: 5),
                    const SizedBox(width: 4),
                    Text(
                      '404 reseñas',
                      style: GoogleFonts.rubik(
                        fontSize: 12,
                        color: GerenaColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: GerenaColors.paddingSmall),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.nombreCompleto ?? '',
                          style: GoogleFonts.rubik(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: GerenaColors.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          doctor.especialidad ?? '',
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: GerenaColors.textDarkColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ubicación:  ',
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            color: GerenaColors.textTertiaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: GerenaColors.paddingSmall),
                        Text(
                          doctor.direccion ?? '',
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            color: GerenaColors.textTertiaryColor,
                          ),
                        ),
                        SizedBox(height: GerenaColors.paddingLarge),
                        SizedBox(height: GerenaColors.paddingSmall),
                        Text(
                          'Cédula: ${doctor.numeroLicencia ?? ""}',
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
            SizedBox(height: GerenaColors.paddingMedium),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GerenaColors.widgetButton(
                    showShadow: false,
                    text: 'VER COMO PACIENTE',
                    borderRadius: 30,
                  ),
                  GerenaColors.widgetButton(
                    showShadow: false,
                    text: 'EDITAR PERFIL',
                    borderRadius: 30,
                    onPressed: () {
          // Mostrar vista de configuración
          perfilConfiguration.showConfigurationView();
        },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildWishlistButton() {
    return InkWell(
      onTap: () {
        Get.toNamed(RoutesNames.calendar);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 13),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: GerenaColors.textLightColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/icons/calendar.png',
              height: 24,
              width: 24,
            ),
            Expanded(
              child: Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: GerenaColors.textPrimaryColor,
              ),
            ),
            Text(
              'CALENDARIO DE CITAS',
              style: GoogleFonts.rubik(
                color: GerenaColors.textPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialtiesSection() {
    final specialties = [
      'Mamoplastia',
      'Otoplastia',
      'Aplicación de hialurónico',
      'Resección bolsas de Bichat',
      'Mastopexia',
      'Lifting facial'
    ];

    List<List<String>> specialtyRows = [];
    for (int i = 0; i < specialties.length; i += 3) {
      specialtyRows.add(specialties.sublist(
          i, i + 3 > specialties.length ? specialties.length : i + 3));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: specialtyRows
          .map(
            (row) => Container(
              margin: const EdgeInsets.only(bottom: 17),
              height: 20,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: row.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return GerenaColors.widgetButton(
                    text: row[index],
                    textColor: GerenaColors.textSecondary,
                    backgroundColor: GerenaColors.cardColor,
                    borderColor: Color.fromARGB(255, 223, 220, 220),
                    showShadow: true,
                    customShadow: GerenaColors.lightShadow,
                    borderRadius: 20,
                    fontWeight: FontWeight.w300,
                  );
                },
              ),
            ),
          )
          .toList(),
    );
  }
}