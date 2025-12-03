import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/doctors/presentation/page/editperfildoctor/movil/procedure_Widget.dart';
import 'package:gerena/features/doctors/presentation/page/prefil_dortor_controller.dart';
import 'package:gerena/features/doctors/presentation/widget/share_and_procedures_widget.dart';
import 'package:gerena/features/review/presentation/page/reviews_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientViewPage extends StatefulWidget {
  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<PatientViewPage> {
  // ✅ AGREGAR: Obtener el controller
  final PrefilDortorController controller = Get.find<PrefilDortorController>();

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
        // ✅ AGREGAR: Observar cambios
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: GerenaColors.primaryColor,
            ),
          );
        }

        if (controller.doctorProfile.value == null) {
          return Center(
            child: Text(
              'No se pudo cargar el perfil del doctor',
              style: GerenaColors.bodyMedium,
            ),
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
              const SizedBox(height: GerenaColors.paddingMedium),

              /*  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'ESPECIALIDADES',
                  style: GerenaColors.subtitleLarge.copyWith(
                    color: GerenaColors.textSecondary,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              _buildSpecialtiesSection(),*/

              const SizedBox(height: GerenaColors.paddingMedium),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'CONOCE SUS PROCEDIMIENTOS',
                  style: GerenaColors.subtitleLarge.copyWith(
                    color: GerenaColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ShareAndProceduresWidget(
                    showShareSection: false), // ✅ CAMBIAR a false
              ),
              const SizedBox(height: GerenaColors.paddingMedium),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RESEÑAS DE SUS PACIENTES',
                      style: GerenaColors.subtitleLarge.copyWith(
                        color: GerenaColors.textSecondary,
                      ),
                    ),
                    ReviewsWidget(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
             
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   /* Text(
                      'PROMOCIONES Y DESCUENTOS',
                      style: GerenaColors.subtitleLarge.copyWith(
                        color: GerenaColors.textSecondary,
                      ),
                    ),
                    _buildPromotionsSection(),*/
                    const SizedBox(height: GerenaColors.paddingMedium),
                    _buildSocialLinksSection(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDoctorHeader() {
    final doctor = controller.doctorProfile.value!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: GerenaColors.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 13, right: 16),
                child: GestureDetector(
                  onTap: () {
                   Get.offAllNamed(RoutesNames.homePage);
                  },
                  child: Image.asset(
                    'assets/icons/close.png',
                    width: 15,
                    height: 15,
                    color: GerenaColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: doctor.foto != null && doctor.foto!.isNotEmpty
                            ? NetworkImage(doctor.foto!)
                            : const AssetImage(
                                    'assets/example/pharmacist-work.png')
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: GerenaColors.paddingExtraLarge),
                  GerenaColors.createStarRating(
                      rating: doctor.calificaion ?? 0),
                  const SizedBox(width: 4),
                  Row(
                    children: [
                      Text(
                        doctor.calificaion?.toStringAsFixed(1) ?? "0.0",
                        style: GoogleFonts.rubik(
                          fontSize: 12,
                          color: GerenaColors.primaryColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.nombreCompleto ??
                          'Dr. ${doctor.nombre ?? ''} ${doctor.apellidos ?? ''}',
                      style: GerenaColors.headingSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.especialidad ?? 'Especialidad no especificada',
                      style: GerenaColors.subtitleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ubicación: ',
                      style: GoogleFonts.rubik(
                        fontSize: 14,
                        color: GerenaColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: GerenaColors.paddingSmall),
                    Text(
                      doctor.direccion ?? 'Dirección no especificada',
                      style: GerenaColors.bodyMedium,
                    ),
                    SizedBox(height: GerenaColors.paddingLarge),
                    Align(
                      alignment: Alignment.center,
                      child: GerenaColors.widgetButton(
                        showShadow: false,
                        text: 'VER UBICACIÓN',
                        backgroundColor: GerenaColors.rowColorCalendar,
                        onPressed: () async {
                          final address = doctor.direccion;

                          if (address == null || address.isEmpty) {
                            showErrorSnackbar('No hay dirección disponible');
                            return;
                          }

                          // Codificar la dirección para URL
                          final encodedAddress = Uri.encodeComponent(address);

                          // URL para Google Maps
                          final googleMapsUrl = Uri.parse(
                              'https://www.google.com/maps/search/?api=1&query=$encodedAddress');

                          try {
                            if (await canLaunchUrl(googleMapsUrl)) {
                              await launchUrl(
                                googleMapsUrl,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              showErrorSnackbar('No se pudo abrir Google Maps');
                            }
                          } catch (e) {
                            print('Error al abrir Google Maps: $e');
                            showErrorSnackbar(
                                'Ocurrió un error al intentar abrir Google Maps');
                          }
                        },
                      ),
                    ),
                    SizedBox(height: GerenaColors.paddingSmall),
                    Text(
                      'Cédula: ${doctor.numeroLicencia ?? 'No especificada'}',
                      style: GerenaColors.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: GerenaColors.paddingMedium),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GerenaColors.widgetButton(
                  showShadow: false,
                  text: '   SEGUIR    ',
                  backgroundColor: GerenaColors.rowColorCalendar,
                ),
                GerenaColors.widgetButton(
                  showShadow: false,
                  text: 'AGENDAR CITA',
                    backgroundColor: GerenaColors.rowColorCalendar,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialtiesSection() {
    final doctor = controller.doctorProfile.value!;

    // ✅ Aquí podrías tener una lista de especialidades del doctor
    // Por ahora uso un ejemplo con la especialidad principal
    final specialties = [
      doctor.especialidad ?? 'Especialidad general',
      doctor.titulo ?? 'Título profesional',
      doctor.certificacion ?? 'Certificación',
    ].where((s) => s != 'Especialidad general').toList();

    if (specialties.isEmpty) {
      specialties.addAll([
        'Mamoplastia',
        'Otoplastia',
        'Aplicación de hialurónico',
        'Resección bolsas de Bichat',
        'Mastopexia',
        'Lifting facial'
      ]);
    }

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
                    fontWeight: FontWeight.w300,
                  );
                },
              ),
            ),
          )
          .toList(),
    );
  }

  void _showProcedureDialog(
    BuildContext context, {
    required String title,
    required String description,
    required String imagePath,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: GerenaColors.backgroundColor,
              borderRadius: GerenaColors.mediumBorderRadius,
            ),
            child: SingleChildScrollView(
              child: ProcedureWidget(
                title: title,
                description: description,
                authorName:
                    controller.doctorProfile.value?.nombreCompleto ?? 'Doctor',
                imagePath: imagePath,
                isFullView: true,
                onClose: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPromotionsSection() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: GerenaColors.backgroundColor,
              borderRadius: GerenaColors.mediumBorderRadius,
              boxShadow: [GerenaColors.lightShadow],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 10.0),
                  child: Image.asset(
                    'assets/example/promosion.png',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.center,
                    child: GerenaColors.widgetButton(
                      showShadow: false,
                      text: 'VER PROMOCIÓN',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinksSection() {
    final doctor = controller.doctorProfile.value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Redes sociales',
          style: GerenaColors.subtitleLarge.copyWith(
            color: GerenaColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 280,
            child: Column(
              children: [
                Row(
                  children: [
                    if (doctor.linkedIn != null && doctor.linkedIn!.isNotEmpty)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.openSocialMediaProfile(
                              'linkedin', doctor.linkedIn!),
                          child: _buildSocialButton(
                              'LinkedIn', 'assets/linkedin.png'),
                        ),
                      )
                    else
                      Expanded(child: SizedBox()),
                    const SizedBox(width: 12),
                    if (doctor.instagram != null &&
                        doctor.instagram!.isNotEmpty)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.openSocialMediaProfile(
                              'instagram', doctor.instagram!),
                          child: _buildSocialButton(
                              'Instagram', 'assets/instagram.png'),
                        ),
                      )
                    else
                      Expanded(child: SizedBox()),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (doctor.facebook != null && doctor.facebook!.isNotEmpty)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.openSocialMediaProfile(
                              'facebook', doctor.facebook!),
                          child: _buildSocialButton(
                              'Facebook', 'assets/facebook.png'),
                        ),
                      )
                    else
                      Expanded(child: SizedBox()),
                    const SizedBox(width: 12),
                    if (doctor.x != null && doctor.x!.isNotEmpty)
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              controller.openSocialMediaProfile('x', doctor.x!),
                          child: _buildSocialButton('X', 'assets/twitter.png'),
                        ),
                      )
                    else
                      Expanded(child: SizedBox()),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (doctor.whatsAppVendedor != null &&
            doctor.whatsAppVendedor!.isNotEmpty) ...[
          Text(
            'Contacto',
            style: GerenaColors.subtitleLarge.copyWith(
              color: GerenaColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: controller.openWhatsApp,
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/link.png',
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'WhatsApp: ${doctor.whatsAppVendedor}',
                  style: GoogleFonts.rubik(
                    fontSize: 14,
                    color: GerenaColors.primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: GerenaColors.largeRadius),
      ],
    );
  }

  Widget _buildSocialButton(String text, String imagePath) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imagePath.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(
                imagePath,
                width: 30,
                height: 30,
                color: GerenaColors.primaryColor,
              ),
            ),
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.rubik(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: GerenaColors.primaryColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
