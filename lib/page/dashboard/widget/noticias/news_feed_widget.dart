import 'package:flutter/material.dart';
import 'package:gerena/page/dashboard/widget/noticias/wigget/feed_widget.dart';
import 'package:gerena/page/store/cartPage/GlobalShopInterface.dart';
import 'package:get/get.dart'; 
import 'package:gerena/common/theme/App_Theme.dart';

class NewsFeedWidget extends StatelessWidget {
  final bool isCompact;
  
  const NewsFeedWidget({
    Key? key,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactNewsFeed();
    } else {
      return _buildFullNewsFeed();
    }
  }

  Widget _buildFullNewsFeed() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        buildWebinarCard(),
        const SizedBox(height: 16),
        buildPromoCard(),
        const SizedBox(height: 16),
        GerenaColors.createArticleCard(
          title: 'Revoluciona tus aplicaciones de tóxina botulínica siguiendo los consejos del Dr. Juan Pérez',
          content: 'Aplicar toxina botulínica no es solo una técnica, es un arte que se perfecciona con conocimiento, práctica y paciencia. Sigue estos consejos del Dr. Juan Pérez y podrás dar un paso más en la excelencia de tus tratamientos y ofrecer...',
          date: 'Blog Gerena | Lun 31 de Marzo',
          imagePath: 'assets/Webinar.png',
          onReadMorePressed: () {
            _navigateToForum();
          },
        ),
        const SizedBox(height: 16),
        buildQuestionCard(),
        const SizedBox(height: 16),
        GerenaColors.createArticleCard(
          title: 'Casos reales: cómo fidelicé a mis pacientes con educación y transparencia',
          content: 'En un entorno donde muchos pacientes llegan con dudas, miedo o expectativas irreales, descubrí que la ética en consulta estética definitiva no está solo en los resultados estéticos, sino en cómo los acompañó desde el primer contacto.',
          date: 'Blog Social | Lun 31 de Marzo',
          imagePath: 'assets/Webinar.png',
          onReadMorePressed: () {
            _navigateToForum();
          },
        ),
      ],
    );
  }

  Widget _buildCompactNewsFeed() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Row(
              children: [
                Text(
                  'NOTICIAS',
                  style: TextStyle(
                    color: GerenaColors.textLightColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          buildCompactNewsCard(
            'WEBINAR',
            'Aplicaciones clínicas de la toxina botulínica',
            '25 de Abril',
            onTap: () {
              // Navegación para webinar - puedes personalizar esto
              _navigateToForum();
            },
          ),
          const SizedBox(height: 8),
        buildCompactNewsCard(
            'PROMO',
            'LINETOX 1 en \$1,500 / 3 en \$4,100',
            'Oferta especial',
            onTap: () {
              // Navegación para promociones - puedes personalizar esto
              _navigateToForum();
            },
          ),
          const SizedBox(height: 8),
          buildCompactNewsCard(
            'BLOG',
            'Aplicaciones de tóxina botulínica',
            'Dr. Juan Pérez',
            onTap: () {
              // Navegación para blog
              _navigateToForum();
            },
          ),
          const SizedBox(height: 8),
          buildCompactNewsCard(
            'FORO',
            '¿Recomendación de marcas para ácido hialurónico?',
            '82 comentarios',
            onTap: () {
              _navigateToForum();
            },
          ),
          const SizedBox(height: 8),
          buildCompactNewsCard(
            'BLOG',
            'Casos reales: cómo fidelicé a mis pacientes',
            'Blog Social',
            onTap: () {
              _navigateToForum();
            },
          ),
        ],
      ),
    );
  }

  void _navigateToForum() {
    Get.find<ShopNavigationController>().navigateToBlogGerena();
      Get.to(() => GlobalShopInterface());
  }

  Widget buildWebinarCard() {
    return ClipRRect(
    borderRadius: GerenaColors.smallBorderRadius,
    child: Image.asset(
      'assets/Webinar.png',
      fit: BoxFit.cover,
      width: double.infinity,
    ),
  );
  }
Widget buildPromoCard() {
  return ClipRRect(
    borderRadius: GerenaColors.smallBorderRadius,
    child: Image.asset(
      'assets/example/promocion.png',
      fit: BoxFit.cover,
      width: double.infinity,
    ),
  );
}

}