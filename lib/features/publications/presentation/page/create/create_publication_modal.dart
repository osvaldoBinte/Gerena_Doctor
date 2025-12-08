import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/publications/presentation/page/create/create_publication_controller.dart';
import 'package:get/get.dart';

class CreatePublication extends StatelessWidget {
  const CreatePublication({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreatePublicationController>();

    return Scaffold(   
      backgroundColor: GerenaColors.colorFondo,
      body: Material(
        color: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: GerenaColors.colorFondo,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
          ),
          child: Column(
            children: [
              _buildModernHeader(controller),
              
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: Column(
                    children: [
                    _buildContentTypeSelector(controller),
                    const SizedBox(height: 28),
                    _buildStyledDescriptionField(controller),
                    const SizedBox(height: 28),

                    Obx(
                      () => AnimatedSize(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        child:
                            controller.isReview.value
                                ? Column(
                                  children: [
                                    _buildElegantDoctorSearch(controller),
                                    const SizedBox(height: 28),
                                    _buildPremiumRatingSection(controller),
                                    const SizedBox(height: 28),
                                  ],
                                )
                                : const SizedBox.shrink(),
                      ),
                    ),

                    _buildGallerySection(controller),
                    const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              
              _buildFloatingActionButton(controller),
            ],
          ),
        ),
      ),
    );
  }
  

  Widget _buildModernHeader(CreatePublicationController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        boxShadow: [
          BoxShadow(
            color: GerenaColors.primaryColor.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    GerenaColors.secondaryColor.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      GerenaColors.primaryColor.withOpacity(0.1),
                      GerenaColors.secondaryColor.withOpacity(0.1),
                    ],
                  ),
                ),
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: GerenaColors.primaryColor,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.isReview.value
                            ? 'Compartir Experiencia'
                            : 'Crear Publicación',
                        style: GerenaColors.headingMedium.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.isReview.value
                            ? 'Tu opinión es valiosa'
                            : 'Comparte con la comunidad',
                        style: GerenaColors.bodySmall.copyWith(
                          color: GerenaColors.textSecondaryColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentTypeSelector(CreatePublicationController controller) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: GerenaColors.backgroundColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: GerenaColors.primaryColor.withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Row(
            children: [
              Expanded(
                child: _buildSelectorOption(
                  icon: Icons.article_rounded,
                  title: 'Publicación',
                  subtitle: 'Contenido general',
                  isSelected: !controller.isReview.value,
                  onTap: () => controller.isReview.value = false,
                ),
              ),
              Container(
                width: 1,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      GerenaColors.dividerColor.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _buildSelectorOption(
                  icon: Icons.star_rounded,
                  title: 'Reseña',
                  subtitle: 'Evalúa un doctor',
                  isSelected: controller.isReview.value,
                  onTap: () => controller.isReview.value = true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectorOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            gradient:
                isSelected
                    ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        GerenaColors.primaryColor,
                        GerenaColors.accentColor,
                      ],
                    )
                    : null,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Colors.white.withOpacity(0.2)
                          : GerenaColors.primaryColor.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color:
                      isSelected
                          ? GerenaColors.textLightColor
                          : GerenaColors.primaryColor,
                  size: 26,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: GerenaColors.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color:
                      isSelected
                          ? GerenaColors.textLightColor
                          : GerenaColors.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GerenaColors.bodySmall.copyWith(
                  fontSize: 11,
                  color:
                      isSelected
                          ? GerenaColors.textLightColor.withOpacity(0.8)
                          : GerenaColors.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledDescriptionField(CreatePublicationController controller) {
    return Container(
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: GerenaColors.primaryColor.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: GerenaColors.primaryColor.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: GerenaColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    color: GerenaColors.textLightColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Escribe tu mensaje',
                  style: GerenaColors.headingSmall.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  GerenaColors.primaryColor.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          TextField(
            controller: controller.descriptionController,
            maxLines: 6,
            style: GerenaColors.bodyMedium.copyWith(
              fontSize: 15,
              height: 1.6,
              letterSpacing: 0.2,
            ),
            decoration: InputDecoration(
              hintText: '¿Qué quieres compartir con la comunidad?',
              hintStyle: GerenaColors.bodyMedium.copyWith(
                color: GerenaColors.textSecondaryColor.withOpacity(0.5),
                fontSize: 15,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElegantDoctorSearch(CreatePublicationController controller) {
    return Container(
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: GerenaColors.primaryColor.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: GerenaColors.accentColor.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  GerenaColors.primaryColor.withOpacity(0.03),
                  GerenaColors.secondaryColor.withOpacity(0.02),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: GerenaColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: GerenaColors.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.medical_services_rounded,
                    color: GerenaColors.textLightColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seleccionar Doctor',
                        style: GerenaColors.headingSmall.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Busca al profesional que quieres evaluar',
                        style: GerenaColors.bodySmall.copyWith(
                          color: GerenaColors.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: GerenaColors.backgroundColorFondo,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: GerenaColors.primaryColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: controller.doctorSearchController,
                    onChanged: controller.searchDoctors,
                    style: GerenaColors.bodyMedium.copyWith(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Escribe el nombre del doctor...',
                      hintStyle: GerenaColors.bodyMedium.copyWith(
                        color: GerenaColors.textSecondaryColor.withOpacity(0.5),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.search_rounded,
                          color: GerenaColors.primaryColor,
                          size: 24,
                        ),
                      ),
                      suffixIcon: Obx(
                        () =>
                            controller.isSearchingDoctor.value
                                ? Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: GerenaColors.primaryColor,
                                    ),
                                  ),
                                )
                                : const SizedBox.shrink(),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),

              /*  Obx(() {
                  if (controller.searchedDoctors.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      color: GerenaColors.backgroundColorFondo,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: GerenaColors.primaryColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.searchedDoctors.length,
                        separatorBuilder:
                            (_, __) => Divider(
                              height: 1,
                              color: GerenaColors.dividerColor.withOpacity(0.1),
                              indent: 80,
                            ),
                        itemBuilder: (context, index) {
                          final doctor = controller.searchedDoctors[index];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => controller.selectDoctor(doctor),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    Hero(
                                      tag: 'doctor_${doctor.fullName}',
                                      child: Container(
                                        width: 54,
                                        height: 54,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          gradient:
                                              doctor.profilePictureUrl == null
                                                  ? GerenaColors.primaryGradient
                                                  : null,
                                          boxShadow: [
                                            BoxShadow(
                                              color: GerenaColors.primaryColor
                                                  .withOpacity(0.2),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          child:
                                              doctor.profilePictureUrl != null
                                                  ? Image.network(
                                                    doctor.profilePictureUrl!,
                                                    fit: BoxFit.cover,
                                                  )
                                                  : Icon(
                                                    Icons.person_rounded,
                                                    color:
                                                        GerenaColors
                                                            .textLightColor,
                                                    size: 28,
                                                  ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            doctor.fullName,
                                            style: GerenaColors.bodyMedium
                                                .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: GerenaColors.secondaryColor
                                                  .withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              doctor.specialty ??
                                                  'Sin especialidad',
                                              style: GerenaColors.bodySmall
                                                  .copyWith(
                                                    color:
                                                        GerenaColors.accentColor,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: GerenaColors.textSecondaryColor,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),

                Obx(() {
                  final doctor = controller.selectedDoctor.value;
                  if (doctor == null) return const SizedBox.shrink();

                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          GerenaColors.successColor.withOpacity(0.08),
                          GerenaColors.accentColor.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: GerenaColors.successColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Hero(
                              tag: 'doctor_${doctor.fullName}',
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  gradient:
                                      doctor.profilePictureUrl == null
                                          ? GerenaColors.primaryGradient
                                          : null,
                                  boxShadow: [
                                    BoxShadow(
                                      color: GerenaColors.successColor
                                          .withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child:
                                      doctor.profilePictureUrl != null
                                          ? Image.network(
                                            doctor.profilePictureUrl!,
                                            fit: BoxFit.cover,
                                          )
                                          : Icon(
                                            Icons.person_rounded,
                                            color: GerenaColors.textLightColor,
                                            size: 32,
                                          ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: GerenaColors.successColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: GerenaColors.backgroundColor,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.check_rounded,
                                  color: GerenaColors.textLightColor,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctor.fullName,
                                style: GerenaColors.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: GerenaColors.backgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  doctor.specialty ?? 'Sin especialidad',
                                  style: GerenaColors.bodySmall.copyWith(
                                    color: GerenaColors.accentColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: GerenaColors.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () {
                              controller.selectedDoctor.value = null;
                              controller.doctorSearchController.clear();
                            },
                            icon: Icon(
                              Icons.close_rounded,
                              color: GerenaColors.errorColor,
                              size: 20,
                            ),
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                  );
                }),*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumRatingSection(CreatePublicationController controller) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            GerenaColors.warningColor.withOpacity(0.08),
            GerenaColors.warningColor.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: GerenaColors.warningColor.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: GerenaColors.warningColor.withOpacity(0.1),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: GerenaColors.backgroundColor.withOpacity(0.5),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: GerenaColors.warningColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: GerenaColors.warningColor.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.star_rounded,
                    color: GerenaColors.textLightColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  'Califica tu experiencia',
                  style: GerenaColors.headingSmall.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
            child: Column(
              children: [
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final isSelected = index < controller.rating.value;
                      return GestureDetector(
                        onTap:
                            () => controller.rating.value = (index + 1).toInt(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(6),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (isSelected)
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        GerenaColors.warningColor.withOpacity(
                                          0.3,
                                        ),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              Icon(
                                isSelected
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 44,
                                color:
                                    isSelected
                                        ? GerenaColors.warningColor
                                        : GerenaColors.textSecondaryColor
                                            .withOpacity(0.3),
                                shadows:
                                    isSelected
                                        ? [
                                          Shadow(
                                            color: GerenaColors.warningColor
                                                .withOpacity(0.5),
                                            blurRadius: 8,
                                          ),
                                        ]
                                        : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      key: ValueKey(controller.rating.value),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: GerenaColors.backgroundColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: GerenaColors.warningColor.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        controller.rating.value == 0
                            ? 'Selecciona las estrellas'
                            : _getRatingText(controller.rating.value.toInt()),
                        style: GerenaColors.bodyMedium.copyWith(
                          color: GerenaColors.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
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

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return '⭐ Muy insatisfecho';
      case 2:
        return '⭐⭐ Insatisfecho';
      case 3:
        return '⭐⭐⭐ Aceptable';
      case 4:
        return '⭐⭐⭐⭐ Muy bueno';
      case 5:
        return '⭐⭐⭐⭐⭐ ¡Excelente!';
      default:
        return '';
    }
  }

  Widget _buildGallerySection(CreatePublicationController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: GerenaColors.primaryColor.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: GerenaColors.primaryColor.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: GerenaColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: GerenaColors.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.photo_library_rounded,
                  color: GerenaColors.textLightColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Galería de Imágenes',
                      style: GerenaColors.headingSmall.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Añade hasta 5 fotos',
                      style: GerenaColors.bodySmall.copyWith(
                        color: GerenaColors.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient:
                        controller.selectedImages.length >= 5
                            ? LinearGradient(
                              colors: [
                                GerenaColors.errorColor,
                                GerenaColors.errorColor.withOpacity(0.8),
                              ],
                            )
                            : GerenaColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (controller.selectedImages.length >= 5
                                ? GerenaColors.errorColor
                                : GerenaColors.primaryColor)
                            .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    '${controller.selectedImages.length}/5',
                    style: GerenaColors.bodyMedium.copyWith(
                      color: GerenaColors.textLightColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(
            () => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount:
                  controller.selectedImages.length +
                  (controller.selectedImages.length < 5 ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.selectedImages.length) {
                 
                  return GestureDetector(
                    onTap: controller.showImageSourceOptions,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            GerenaColors.primaryColor.withOpacity(0.08),
                            GerenaColors.secondaryColor.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: GerenaColors.primaryColor.withOpacity(0.2),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: GerenaColors.primaryGradient,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add_rounded,
                              color: GerenaColors.textLightColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Agregar',
                            style: GerenaColors.bodySmall.copyWith(
                              color: GerenaColors.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final imageFile = controller.selectedImages[index];
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: GerenaColors.primaryColor.withOpacity(0.2),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: GerenaColors.primaryColor.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(
                          imageFile,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => controller.removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                GerenaColors.errorColor,
                                GerenaColors.errorColor.withOpacity(0.9),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: GerenaColors.textLightColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(CreatePublicationController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: GerenaColors.colorFondo,
        boxShadow: [
          BoxShadow(
            color: GerenaColors.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Obx(
        () =>
            controller.isLoading.value
                ? Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        GerenaColors.primaryColor.withOpacity(0.5),
                        GerenaColors.accentColor.withOpacity(0.5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: GerenaColors.textLightColor,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Publicando...',
                          style: GerenaColors.buttonText.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : GerenaColors.widgetButton(
                  onPressed: controller.createPublication,
                  text:
                      controller.isReview.value
                          ? 'Publicar Reseña'
                          : 'Crear Publicación',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 24,
                  ),
                ),
      ),
    );
  }
}
