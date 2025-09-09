import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/shareProcedureWidget/share_procedure_widget.dart';
import 'package:gerena/page/dashboard/widget/appbar/gerena_app_bar_controller.dart';
import 'package:gerena/common/controller/mediacontroller/media_controller.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class DoctorProfileContent extends StatefulWidget {
  const DoctorProfileContent({Key? key}) : super(key: key);

  @override
  State<DoctorProfileContent> createState() => _DoctorProfileContentState();
}

class _DoctorProfileContentState extends State<DoctorProfileContent> {
  final TextEditingController _reviewController = TextEditingController();
  final appBarController = Get.put(GerenaAppBarController());

    final MediaController mediaController = Get.put(MediaController());

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color:  GerenaColors.backgroundColorfondo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDoctorInfoCard(),
          const SizedBox(height: 16),
           Text(
            'Compartir tus procedimientos',
            style: GerenaColors.headingSmall,
          ),
          ShareProcedureWidget(mediaController: mediaController,),
          const SizedBox(height: 16),
          _buildBeforeAfterSection(),
          const SizedBox(height: 16),
           Text(
            'Reseñas de tus pacientes',
            style: GerenaColors.headingSmall,
          ),
          const SizedBox(height: 16),

          _buildPatientReviewsSection(),
        ],
      ),
    );
  }

  Widget _buildDoctorInfoCard() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: GerenaColors.cardDecoration,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: GerenaColors.backgroundColorfondo,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/perfil.png',
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
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Juan Pedro González Pérez',
                          style: GerenaColors.headingMedium.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                     
                    GestureDetector(
                      onTap: () {
                        print('Editando perfil');
                        appBarController.navigateToProfile(); 
                      },
                        child: Image.asset(
                        'assets/icons/edit.png',
                        width: 30,
                        height: 30,
                        color: GerenaColors.accentColor,
                        fit: BoxFit.contain,
                        ),
                    ),

                    ],
                  ),
                  
                  const SizedBox(height: 6),
                  
                  Text(
                    'Cirujano estético',
                    style: GerenaColors.subtitleMedium.copyWith(
                      color: GerenaColors.colorSubsCardSecondaryText,
                      fontSize: 14,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Clínica estética Gerena. Col. Providencia, Av. Lorem ipsum #3050, Guadalajara, Jalisco, México.',
                    style: GerenaColors.bodySmall.copyWith(
                      fontSize: 12,
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Cédula: 010101 10101 0101041',
                    style: GerenaColors.bodySmall.copyWith(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      _buildStarRating(5.0), 
                      const SizedBox(width: 8),
                      Text(
                        '404 Reseñas',
                        style: GerenaColors.bodySmall.copyWith(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        
      ],
    ),
  );
}

  Widget _buildBeforeAfterSection() {
    return Row(
      children: [
        Expanded(
          child: _buildBeforeAfterCard(
            'Inyecciones y Rellenos Orales Rellenos Orale Rellenos Orale',
            'Procedimientos de reducción de arrugas mediante inyecciones de ácido hialurónico y otros productos especializados que mejoran el contorno y dan volumen al rostro...',
            ['assets/before/before_after_1.png', 'assets/before/before_after.png'],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildBeforeAfterCard(
            'Promociones y Resultados de Casos de Pacientes',
            'Historias exitosas de transformación de nuestros pacientes que han recibido diferentes tipos de tratamientos de cirugía estética y reconstructiva...',
            ['assets/before/before_after_1.png', 'assets/before/before_after.png'],
          ),
        ),
      ],
    );
  }

 Widget _buildBeforeAfterCard(String title, String description, List<String> images) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: GerenaColors.cardDecoration,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Expanded(
              child: Text(
              title,
              style: GerenaColors.headingSmall.copyWith(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              ),
            ),
            Image.asset(
              'assets/icons/edit.png',
              color: GerenaColors.accentColor,
              width: 30,
              height: 30,
                 fit: BoxFit.contain,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: GerenaColors.bodySmall,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
  
Row(
  children: images.map((imagePath) {
    return Container(
      width: 120, 
      height: 100,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: GerenaColors.smallBorderRadius,
        color: GerenaColors.backgroundColorfondo,
      ),
      child: ClipRRect(
        borderRadius: GerenaColors.smallBorderRadius,
        child: Image.asset(
          imagePath,
          width: 120,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Error cargando imagen: $imagePath - $error');
            return Container(
              color: GerenaColors.backgroundColorfondo,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image,
                    color: Colors.grey[400],
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Imagen no encontrada',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }).toList(),
)
      ],
    ),
  );
}

  Widget _buildPatientReviewsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          _buildExistingReview(
            '¡Excelente para el Botox!',
            'Me encanta super bien hecho el tratamiento, excelente bailan los finales. me estilista y muy profesional de cuidado, alta recomendación para todos.',
            5,
            '01/04/2024',
            ['assets/before/before_after_1.png', 'assets/before/before_after.png'],
          ),
          const SizedBox(height: 16),
          _buildExistingReview(
            'Botox a domicilio',
            'Servicio de Botox excelente por las recomendaciones de la app 1he. Muy buen trato y fui de visita al consultorio del doctor en el cual me realizó y hubo un antes y después impresionante. Lo recomiendo 100%.',
            5,
            '31/03/2024',
           ['assets/before/before_after_1.png', 'assets/before/before_after.png'],
          ),
        ],
      ),
    );
  }

 

  Widget _buildExistingReview(String title, String content, int rating, String date, List<String> images) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: GerenaColors.smallBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: GerenaColors.primaryColor,
                child: Icon(Icons.person, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildStarRating(rating.toDouble()),
                        const Spacer(),
                         Text(
            'Cita verificada',
             style: GerenaColors.bodyMedium.copyWith(
                  color: GerenaColors.accentColor,
                ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(width: 8),
                        IconButton(
                          icon: Image.asset(
                          'assets/icons/push-pin.png',
                          width: 16,
                          height: 16,
                          ),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GerenaColors.headingSmall.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: GerenaColors.bodySmall,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
Row(
  children: images.map((imagePath) {
    return Container(
      width: 120,
      height: 100,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: GerenaColors.smallBorderRadius,
        color: GerenaColors.backgroundColorfondo,
      ),
      child: ClipRRect(
        borderRadius: GerenaColors.smallBorderRadius,
        child: Image.asset(
          imagePath,
          width: 120,
          height: 100,
          fit: BoxFit.cover, 
          errorBuilder: (context, error, stackTrace) {
            print('Error cargando imagen: $imagePath - $error');
            return Container(
              color: GerenaColors.backgroundColorfondo,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image,
                    color: Colors.grey[400],
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Imagen no encontrada',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }).toList(),
),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                date,
                style: GerenaColors.bodySmall
              ),
              const SizedBox(width: 8),
              Text(
                '120 Reacciones',
                style:GerenaColors.bodySmall
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: GerenaColors.accentColor, size: 16);
        } else if (index < rating) {
          return const Icon(Icons.star_half, color: GerenaColors.accentColor, size: 16);
        } else {
          return const Icon(Icons.star_border, color: GerenaColors.accentColor, size: 16);
        }
      }),
    );
  }

 

}