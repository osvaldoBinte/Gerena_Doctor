import 'package:flutter/material.dart';
import 'package:gerena/features/banners/domain/entity/banners_entity.dart';
import 'package:gerena/features/banners/presentation/controller/banner_controller.dart';
import 'package:gerena/features/banners/presentation/page/banners/banners_list_widget.dart';
import 'package:gerena/features/banners/presentation/page/noticias/wigget/feed_widget.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
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
    final BannerController controller = Get.find<BannerController>();
    
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshBanners(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        );
      }

      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
            BannersListWidget(
                      height: 200,
                      maxBanners: 2, // Mostrar máximo 2 banners
                      onBannerTap: () {
                        print('Banner tapped');
                        // Navegar a donde necesites
                      },
                    ),
          
          GerenaColors.createArticleCard(
            title: 'Revoluciona tus aplicaciones de tóxina botulínica siguiendo los consejos del Dr. Juan Pérez',
            content: 'Aplicar toxina botulínica no es solo una técnica, es un arte que se perfecciona con conocimiento, práctica y paciencia. Sigue estos consejos del Dr. Juan Pérez y podrás dar un paso más en la excelencia de tus tratamientos y ofrecer...',
            date: 'Blog Gerena | Lun 31 de Marzo',
            imagePath: 'https://www.esheformacion.com/assets/base/img/uploads/64353608f4215Facotres.jpg',
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
            imagePath: 'https://www.esheformacion.com/assets/base/img/uploads/643532b3621beMedicoMexico.jpg',
            onReadMorePressed: () {
              _navigateToForum();
            },
          ),
        ],
      );
    });
  }

  Widget _buildCompactNewsFeed() {
    final BannerController controller = Get.find<BannerController>();
    
    return Obx(() {
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
            
            if (controller.isLoading.value)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (controller.banners.isEmpty)
              buildCompactNewsCard(
                'BLOG',
                'Aplicaciones de tóxina botulínica',
                'Dr. Juan Pérez',
                onTap: () {
                  _navigateToForum();
                },
              )
            else
              ...controller.banners.take(2).map((banner) => Column(
                children: [
                  buildCompactNewsCard(
                    'PROMO',
                    banner.nombre ?? 'Promoción especial',
                    'Ver detalles',
                    onTap: () {
                      _navigateToForum();
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              )),
            
            const SizedBox(height: 8),
            buildCompactNewsCard(
              'BLOG',
              'Aplicaciones de tóxina botulínica',
              'Dr. Juan Pérez',
              onTap: () {
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
    });
  }

  void _navigateToForum() {
    Get.find<ShopNavigationController>().navigateToBlogGerena();
    Get.to(() => GlobalShopInterface());
  }

}