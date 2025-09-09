import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gerena/common/controller/promotionController/promotion_controller.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/perfil/widgets_pefil.dart';
import 'package:gerena/common/widgets/shareProcedureWidget/promotion_preview_widget.dart';
import 'package:gerena/common/widgets/shareProcedureWidget/share_procedure_widget.dart';
import 'package:gerena/movil/home/start_controller.dart';
import 'package:gerena/movil/perfil/procedure_Widget.dart';
import 'package:gerena/movil/widgets/review_widget.dart';
import 'package:gerena/page/dashboard/widget/estatusdepedido/estatus_de_pedido.dart';
import 'package:gerena/page/dashboard/widget/estatusdepedido/widgets_status_pedido.dart';
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
  final PromotionController promotionController =
      Get.put(PromotionController());

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
      body: SingleChildScrollView(
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
            Container(
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
                        '250 puntos',
                        style: GoogleFonts.rubik(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Divider(height: 2, color: GerenaColors.dividerColor),
            const SizedBox(height: 16),
            Container(
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
                          'Carolina Fernández',
                          style: GoogleFonts.rubik(
                            fontSize: 13,
                            color: GerenaColors.textPrimaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Lun. - Sáb. 9:00 a.m. a 6:00 p.m.',
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
                      print('Botón contactar presionado');
                    },
                    text: 'CONTACTAR',
                    showShadow: false,
                    borderRadius: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Divider(height: 2, color: GerenaColors.dividerColor),
            const SizedBox(height: 16),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: GerenaColors.buildLabeledTextField(
                          'ESPECIALIDADES',
                          'Ej. Aplicación de ácido hialurónico'),
                    ),
                    const SizedBox(width: 16),
                    GerenaColors.widgetButton(
                      onPressed: () {
                        print('Botón agregar presionado');
                      },
                      text: 'AGREGAR',
                      showShadow: false,
                      borderRadius: 20,
                    ),
                  ],
                )),
            _buildSpecialtiesSection(),
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
              child: _buildProceduresSection(),
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
                  _buildReviewsSection(),
                  const SizedBox(height: 16),
                  Text(
                    'PROMOCIONES Y DESCUENTOS ',
                    style: GerenaColors.headingSmall,
                  ),
                  const SizedBox(height: 16),
                  _buildPromocionSection(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Divider(height: 2, color: GerenaColors.dividerColor),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, 
                children: [
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
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      children: [
        _buildReviewCard(
          [
            'assets/before/before_after_1.png',
            'assets/before/before_after.png',
            'assets/example/posh.png',
            'assets/example/promosion.png',
            'assets/before/before_after_1.png',
          ],
          'Flor Morales',
          '04/04/2025',
          'Encantada con el doctor. Te explica súper bien todo el tratamiento, resuelve las dudas que tengas y es muy productivo. Me encantaron los resultados.',
          'assets/example/perfil.png',
          70,
        ),
        const SizedBox(height: 12),
        _buildReviewCard(
          [
            'assets/before/before_after_1.png',
            'assets/before/before_after.png',
            'assets/example/posh.png',
            'assets/example/promosion.png',
            'assets/before/before_after_1.png',
          ],
          'Dulce Armenda',
          '02/03/2025',
          'Conocí al doctor gracias a las recomendaciones de la app de Gerena y por fin me animé a hacerme mi cita y no podía estar más feliz con mis resultados, mi nariz quedó...',
          'assets/example/perfil.png',
          120,
        ),
      ],
    );
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
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage('assets/perfil.png'),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
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
                        'Dr. Juan González',
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: GerenaColors.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cirujano estético',
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: GerenaColors.textDarkColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ubicación: ',
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                          color: GerenaColors.textTertiaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: GerenaColors.paddingSmall),
                      Text(
                        'Clínica estética Gerena, Col. Providencia, Av. Atenas #3050, Guadalajara, Jalisco, México.',
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                          color: GerenaColors.textTertiaryColor,
                        ),
                      ),
                      SizedBox(height: GerenaColors.paddingLarge),
                      SizedBox(height: GerenaColors.paddingSmall),
                      Text(
                        'Cédula: 010101 10101 0101041',
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistButton() {
    return Container(
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
    );
  }

  _buildProceduresSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ShareProcedureWidget(
                mediaController: mediaController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildProcedureCard(
                'Prevención y Suavización de Líneas de Expresión',
                'En este procedimiento, utilizamos Kiara Reju, un innovador tratamiento de bioestimulación dérmica, para mejorar la calidad de la piel, proporcionando hidratación profunda y un efecto rejuvenecedor visible. Beneficios del tratamiento: Hidratación intensa y mejora de la elasticidad cutánea. Reducción de líneas finas y signos de envejecimiento. Estimulación de la regeneración celular para una piel más luminosa y uniforme. Gracias a su combinación de polinucleótidos y ácido hialurónico, Kiara Reju es una solución eficaz para revitalizar la piel y restaurar su frescura de manera natural.',
                'assets/before/beforeAndAfter.jpg',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProcedureCard(
      String title, String description, String imagePath) {
    return ProcedureWidget(
      title: title,
      description: description,
      imagePath: imagePath,
      isFullView: false,
      onContinueReading: () {
        _showProcedureDialog(
          context,
          title: title,
          description: description,
          imagePath: imagePath,
        );
      },
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
                authorName: 'Juan González',
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

  Widget _buildReviewCard(
    List<String> images,
    String name,
    String date,
    String review,
    String avatarPath,
    int reactions,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: GerenaColors.mediumBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: GerenaColors.backgroundColorFondo,
            backgroundImage: avatarPath != null && avatarPath.isNotEmpty
                ? AssetImage(avatarPath)
                : null,
            child: (avatarPath == null || avatarPath.isEmpty)
                ? Icon(
                    Icons.person,
                    color: GerenaColors.primaryColor,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.rubik(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      date,
                      style: GoogleFonts.rubik(
                        color: GerenaColors.primaryColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final textPainter = TextPainter(
                      text: TextSpan(
                        text: review,
                        style: GoogleFonts.rubik(
                          color: GerenaColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      maxLines: null,
                      textDirection: TextDirection.ltr,
                    )..layout(maxWidth: constraints.maxWidth);

                    final buttonTextPainter = TextPainter(
                      text: TextSpan(
                        text: 'Ver publicación',
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                          color: GerenaColors.seepublication,
                          fontWeight: FontWeight.w200,
                          decoration: TextDecoration.underline,
                          decorationColor: GerenaColors.seepublication,
                          decorationThickness: 1.0,
                        ),
                      ),
                      textDirection: TextDirection.ltr,
                    )..layout();

                    double lastLineWidth =
                        textPainter.computeLineMetrics().last.width;
                    double availableWidth = constraints.maxWidth;
                    double buttonWidth = buttonTextPainter.width;

                    if (lastLineWidth + buttonWidth + 8 <= availableWidth) {
                      double spacerWidth =
                          availableWidth - lastLineWidth - buttonWidth - 8;

                      return RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: review,
                              style: GoogleFonts.rubik(
                                color: GerenaColors.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            WidgetSpan(
                              child: SizedBox(width: spacerWidth),
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  _showReviewDialog(
                                    context,
                                    userName: name,
                                    avatarPath: avatarPath,
                                    date: date,
                                    title: "Encantada con el doctor",
                                    content: review,
                                    images: images,
                                    userRole: "Paciente",
                                    rating: 5.0,
                                    reactions: reactions,
                                  );
                                },
                                child: Text(
                                  'Ver publicación',
                                  style: GoogleFonts.rubik(
                                    fontSize: 14,
                                    color: GerenaColors.seepublication,
                                    fontWeight: FontWeight.w200,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        GerenaColors.seepublication,
                                    decorationThickness: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review,
                            style: GoogleFonts.rubik(
                              color: GerenaColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                _showReviewDialog(
                                  context,
                                  userName: name,
                                  avatarPath: avatarPath,
                                  date: date,
                                  title: "Encantada con el doctor",
                                  content: review,
                                  images: images,
                                  userRole: "Paciente",
                                  rating: 5.0,
                                  reactions: reactions,
                                );
                              },
                              child: Text(
                                'Ver publicación',
                                style: GoogleFonts.rubik(
                                  fontSize: 14,
                                  color: GerenaColors.seepublication,
                                  fontWeight: FontWeight.w200,
                                  decoration: TextDecoration.underline,
                                  decorationColor: GerenaColors.seepublication,
                                  decorationThickness: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: images != null && images.isNotEmpty
                      ? images.take(2).map<Widget>((imgPath) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: GerenaColors.backgroundColorFondo,
                                borderRadius: GerenaColors.smallBorderRadius,
                                image: imgPath != null && imgPath.isNotEmpty
                                    ? DecorationImage(
                                        image: AssetImage(imgPath),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: (imgPath == null || imgPath.isEmpty)
                                  ? Icon(
                                      Icons.image,
                                      color: GerenaColors.primaryColor
                                          .withOpacity(0.5),
                                    )
                                  : null,
                            ),
                          );
                        }).toList()
                      : [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: GerenaColors.backgroundColorFondo,
                              borderRadius: GerenaColors.smallBorderRadius,
                            ),
                            child: Icon(
                              Icons.image,
                              color: GerenaColors.primaryColor.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: GerenaColors.backgroundColorFondo,
                              borderRadius: GerenaColors.smallBorderRadius,
                            ),
                            child: Icon(
                              Icons.image,
                              color: GerenaColors.primaryColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '$reactions reacciones',
                      style: GoogleFonts.rubik(
                          fontSize: 12,
                          color: GerenaColors.primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(
                      'Valoración',
                      style: GoogleFonts.rubik(
                          fontSize: 12,
                          color: GerenaColors.primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    GerenaColors.createStarRating(rating: 5, size: 14),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReviewDialog(
    BuildContext context, {
    required String userName,
    required String date,
    required String title,
    required String content,
    required List<String> images,
    required String userRole,
    required double rating,
    required int reactions,
    required String avatarPath,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Image.asset(
                          'assets/icons/close.png',
                          width: 20,
                          height: 20,
                          color: GerenaColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: ReviewWidget(
                      userName: userName,
                      date: date,
                      title: title,
                      content: content,
                      images: images,
                      userRole: userRole,
                      avatarPath: avatarPath,
                      rating: rating,
                      reactions: reactions,
                      margin: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
