import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/doctors/presentation/page/doctorProfilePage/doctor_profilebyid_controller.dart';
import 'package:gerena/features/doctors/presentation/page/doctorProfilePage/prosedimiento/procedures_doctorbyid_widget.dart';
import 'package:gerena/features/doctors/presentation/page/doctorProfilePage/review/reviews_widget.dart';
import 'package:gerena/features/review/presentation/page/reviews_widget.dart';
import 'package:gerena/movil/home/start_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorProfileByidPage extends StatefulWidget {
  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfileByidPage> {
  final StartController controller = Get.find<StartController>();
  final DoctorProfilebyidController doctorController = Get.find<DoctorProfilebyidController>();

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
        // Mostrar loading si está cargando
        if (doctorController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: GerenaColors.primaryColor,
            ),
          );
        }

        // Mostrar error si hay
        if (doctorController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 60,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  doctorController.errorMessage.value,
                  style: GerenaColors.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => doctorController.retryLoad(),
                  child: Text('Reintentar'),
                ),
              ],
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
                child: ProceduresDoctorbyidWidget(),
              ),
              
              const SizedBox(height: GerenaColors.paddingMedium),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RESEÑAS DE SUS PACIENTES',
                      style: GerenaColors.subtitleLarge.copyWith(
                        color: GerenaColors.textSecondary,
                      ),
                    ),
                    ReviewsByDoctorWidget(),
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

  Widget _buildSocialLinksSection() {
    return Obx(() {
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
                      Expanded(
                        child: _buildSocialButton(
                          'LinkedIn',
                          'assets/linkedin.png',
                          doctorController.linkedInUrl,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSocialButton(
                          'Instagram',
                          'assets/instagram.png',
                          doctorController.instagramUrl,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSocialButton(
                          'Facebook',
                          'assets/facebook.png',
                          doctorController.facebookUrl,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSocialButton(
                          'X',
                          'assets/twitter.png',
                          doctorController.xUrl,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // WhatsApp Link
          if (doctorController.doctorPhone.isNotEmpty) ...[
            Text(
              'Contacto',
              style: GerenaColors.subtitleLarge.copyWith(
                color: GerenaColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: 8),
            
            GestureDetector(
              onTap: () => _openWhatsApp(doctorController.doctorPhone),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/whatsapp.png',
                    width: 24,
                    height: 24,
                    color: Color(0xFF25D366),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Enviar mensaje por WhatsApp',
                      style: GoogleFonts.rubik(
                        fontSize: 14,
                        color: GerenaColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: GerenaColors.largeRadius),
        ],
      );
    });
  }

  Widget _buildSocialButton(String text, String imagePath, String url) {
    final bool hasUrl = url.isNotEmpty;
    
    return GestureDetector(
      onTap: hasUrl ? () => _openSocialMedia(url) : null,
      child: Opacity(
        opacity: hasUrl ? 1.0 : 0.4,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
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
                    color: hasUrl ? GerenaColors.primaryColor : Colors.grey,
                  ),
                ),
              Flexible(
                child: Text(
                  text,
                  style: GoogleFonts.rubik(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: hasUrl ? GerenaColors.primaryColor : Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para abrir redes sociales
  Future<void> _openSocialMedia(String url) async {
    if (url.isEmpty) {
      showErrorSnackbar('Enlace no disponible');
      return;
    }
    
    try {
      // Asegurar que la URL tenga el protocolo correcto
      String formattedUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        formattedUrl = 'https://$url';
      }
      
      final uri = Uri.parse(formattedUrl);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        showErrorSnackbar('No se pudo abrir el enlace');
      }
    } catch (e) {
      print('Error al abrir red social: $e');
      showErrorSnackbar('Error al abrir el enlace');
    }
  }

  // Método para abrir WhatsApp
  Future<void> _openWhatsApp(String phone) async {
    if (phone.isEmpty) {
      showErrorSnackbar('Número de teléfono no disponible');
      return;
    }
    
    try {
      // Limpiar el número de teléfono (quitar espacios, guiones, etc.)
      String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
      
      // Si no tiene código de país, agregar +52 (México)
      if (!cleanPhone.startsWith('+')) {
        cleanPhone = '+52$cleanPhone';
      }
      
      final whatsappUrl = Uri.parse('https://wa.me/$cleanPhone');
      
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(
          whatsappUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        showErrorSnackbar('No se pudo abrir WhatsApp');
      }
    } catch (e) {
      print('Error al abrir WhatsApp: $e');
      showErrorSnackbar('Error al abrir WhatsApp');
    }
  }

  Widget _buildDoctorHeader() {
    return Obx(() => Container(
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
                    controller.hideDoctorProfilePage();
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
        color: Colors.grey[200], // fondo neutro si no hay imagen
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: doctorController.doctorProfileImage.isNotEmpty &&
                !doctorController.doctorProfileImage.startsWith('assets/')
            ? Image.network(
                doctorController.doctorProfileImage,
                fit: BoxFit.cover,
              )
            : doctorController.doctorProfileImage.isNotEmpty
                ? Image.asset(
                    doctorController.doctorProfileImage,
                    fit: BoxFit.cover,
                  )
                : Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey[600],
                  ),
      ),
    ),
    SizedBox(height: GerenaColors.paddingMedium),
    GerenaColors.createStarRating(rating: doctorController.doctorRating),
  ],
),

              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorController.doctorName,
                        style: GerenaColors.headingSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctorController.doctorSpecialty,
                        style: GerenaColors.subtitleMedium,
                      ),
                      const SizedBox(height: 12),
                      
                      // Experiencia
                      if (doctorController.doctorEntity.value?.experienciaTiempo != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(Icons.work_outline, size: 16, color: GerenaColors.textSecondary),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '${doctorController.doctorEntity.value!.experienciaTiempo} años de experiencia',
                                  style: GoogleFonts.rubik(
                                    fontSize: 13,
                                    color: GerenaColors.textSecondary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      Text(
                        'Ubicación: ',
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                          color: GerenaColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        doctorController.doctorLocation,
                        style: GerenaColors.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12),
                      Align(
                        alignment: Alignment.center,
                        child: GerenaColors.widgetButton(
                          showShadow: false,
                          text: 'VER UBICACIÓN',
                          onPressed: () async {
                            final address = doctorController.doctorLocation;

                            if (address.isEmpty) {
                              showErrorSnackbar('No hay dirección disponible');
                              return;
                            }

                            final encodedAddress = Uri.encodeComponent(address);
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
                              showErrorSnackbar('Ocurrió un error al intentar abrir Google Maps');
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 8),
                      
                      // Cédula
                      if (doctorController.doctorLicense.isNotEmpty)
                        Text(
                          'Cédula: ${doctorController.doctorLicense}',
                          style: GerenaColors.bodyMedium,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: GerenaColors.paddingMedium),
          
          // ESTADÍSTICAS
          _buildStatsSection(),
          SizedBox(height: GerenaColors.paddingMedium),

          // BOTONES DE ACCIÓN
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() {
                    final isFollowing = doctorController.isFollowing;
                    final isLoading = doctorController.isLoadingFollow;
                    
                    return GerenaColors.widgetButton(
                      showShadow: false,
                      text: isLoading 
                          ? 'CARGANDO...' 
                          : (isFollowing ? 'SIGUIENDO' : 'SEGUIR'),
                      backgroundColor: isFollowing 
                          ? GerenaColors.primaryColor 
                          : GerenaColors.backgroundColor,
                      textColor: isFollowing 
                          ? Colors.white 
                          : GerenaColors.primaryColor,
                      borderColor: GerenaColors.primaryColor,
                      onPressed: isLoading ? null : () => doctorController.toggleFollow(),
                    );
                  }),
                ),
                
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildStatsSection() {
    return Obx(() {
      final isLoading = doctorController.isLoadingFollow;
      final reviews = doctorController.reviews.length;
      final followers = doctorController.totalFollowers;
      final following = doctorController.totalFollowing;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn(
            'Reseñas',
            "$reviews ${reviews == 1 ? 'reseña' : 'reseñas'}",
            GerenaColors.primaryColor,
          ),

          _buildStatColumn(
            'Seguidores',
            isLoading
                ? '...'
                : "$followers ${followers == 1 ? 'seguidor' : 'seguidores'}",
            GerenaColors.primaryColor,
             onTap: () {
              final id = doctorController.doctorId;
              if (id != null) {
                Get.toNamed(
                  RoutesNames.followersFollowingGeneric,
                  arguments: {
                    'userId': id,
                    'userName': doctorController.doctorName,
                    'initialTab': 0,
                  },
                );
              }
            },
          ),

          _buildStatColumn(
            'Siguiendo',
            isLoading ? '...' : "$following seguidos",
            GerenaColors.primaryColor,
             onTap: () {
              final id = doctorController.doctorId;
              if (id != null) {
                Get.toNamed(
                  RoutesNames.followersFollowingGeneric,
                  arguments: {
                    'userId': id,
                    'userName': doctorController.doctorName,
                    'initialTab': 1,
                  },
                );
              }
            },
          ),
        ],
      );
    });
  }

  Widget _buildStatColumn(
    String label,
    String value,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Flexible(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: GerenaColors.textTertiary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}