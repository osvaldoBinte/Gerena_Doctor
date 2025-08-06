import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gerena/page/store/blogGerena/article_detail_screen.dart';
import 'package:gerena/page/store/blogGerena/blog_controller.dart';
import 'package:gerena/page/store/blogGerena/preguntas.dart';
import 'package:provider/provider.dart';

class BlogSocial extends StatelessWidget {
  const BlogSocial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BlogController>(
      builder: (context, controller, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Si está mostrando preguntas o detalle de artículo, agregar botón de regreso
            if ( controller.showSocialArticleDetail) 
              _buildBackButton(controller),
            
            // Contenido condicional
            if (controller.showSocialArticleDetail)
              _buildArticleDetailContent(controller)
            else if (controller.showQuestions)
              const DialogoAbierto() 
            else
              _buildBlogSocialContent(controller),
          ],
        );
      },
    );
  }

  Widget _buildBackButton(BlogController controller) {
    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: GerenaColors.secondaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child:IconButton(
            onPressed: () => controller.goBackToBlogSocial(),
            icon: Icon(
              Icons.arrow_back,
              color: GerenaColors.backgroundColor,
            ),
          ),
                    );
  }

  // Método para mostrar el detalle del artículo
  Widget _buildArticleDetailContent(BlogController controller) {
    if (controller.selectedSocialArticle == null) return const SizedBox.shrink();
    
    final article = controller.selectedSocialArticle!;
    
    return SingleChildScrollView(
  padding: const EdgeInsets.symmetric(horizontal: 100), // ← PADDING GLOBAL AQUÍ
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Imagen del artículo
    Padding(
  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
  child: Image.asset(
    article['image']!,
    width: double.infinity,
    fit: BoxFit.fitWidth,
  ),
),
      
      const SizedBox(height: 24),
      
      // Header con información del artículo
      Container(
        padding: const EdgeInsets.all(GerenaColors.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fecha y autor
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  article['date'] ?? 'Hoy',
                  style: GerenaColors.bodySmall.copyWith(
                    color: GerenaColors.textTertiaryColor,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  article['author'] ?? 'Blog Gerena',
                  style: GerenaColors.bodySmall.copyWith(
                    color: GerenaColors.textTertiaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Divider(
              color: GerenaColors.textTertiaryColor.withOpacity(0.6),
              thickness: 2,
            ),
            const SizedBox(height: 30),
            
            // Título del artículo
            Text(
              article['title']!,
              style: GerenaColors.headingLarge.copyWith(
                fontSize: 28,
                height: 1.3,
                color: GerenaColors.textTertiaryColor
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Contenido del artículo
            Text(
              article['content']!,
              style: GerenaColors.bodyLarge.copyWith(height: 1.6),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    ],
  ),
);
  }

  // Contenido específico del artículo se movió a ArticleContent widget

  

  Widget _buildCaseSection({
    required String caseNumber,
    required String caseTitle,
    required String caseContent,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: caseNumber,
                style: GerenaColors.headingMedium.copyWith(
                  color: GerenaColors.accentColor,
                ),
              ),
              TextSpan(
                text: " $caseTitle",
                style: GerenaColors.headingMedium,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        Text(
          caseContent,
          style: GerenaColors.bodyLarge.copyWith(height: 1.6),
        ),
      ],
    );
  }

  // Contenido principal del Blog Social (carrusel + artículos)
  Widget _buildBlogSocialContent(BlogController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: GerenaColors.accentColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => controller.carouselController.previousPage(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: GerenaColors.backgroundColor,
                  size: 18,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
            
            const SizedBox(width: 12),
            
            Expanded(
  child: LayoutBuilder(
    builder: (context, constraints) {
      double screenWidth = constraints.maxWidth;
      
      double cardMinWidth = 200.0; 
      int maxVisibleCards = (screenWidth / cardMinWidth).floor();
      
      maxVisibleCards = maxVisibleCards.clamp(1, 5);
      
      double viewportFraction = 1.0 / maxVisibleCards;
      
      return CarouselSlider(
        carouselController: controller.carouselController,
        options: CarouselOptions(
          height: 140,
          viewportFraction: viewportFraction,
          enableInfiniteScroll: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: false,
          scrollDirection: Axis.horizontal,
        ),
        items: controller.getCarouselQuestions().map((questionData) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildQuestionCardCustom(
                  title: questionData['title'],
                  commentsText: questionData['commentsText'],
                  onTap: () {
                    controller.showQuestionDetail(
                      questionData['title'],
                      questionData['answers'],
                    );
                  },
                ),
              );
            },
          );
        }).toList(),
      );
    },
  ),
),
            
            const SizedBox(width: 12),
            
            // Botón derecho
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: GerenaColors.accentColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => controller.carouselController.nextPage(),
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: GerenaColors.backgroundColor,
                  size: 18,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        Divider(
          color: GerenaColors.primaryColor.withOpacity(0.3),
          thickness: 1,
        ),
        const SizedBox(height: 24),
        
        // Grid de artículos sociales
        _buildSocialArticlesGrid(controller),
      ],
    );
  }

 
  Widget _buildQuestionCardCustom({
    required String title,
    required String commentsText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: GerenaColors.smallBorderRadius,
          boxShadow: [GerenaColors.lightShadow],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: GerenaColors.textPrimaryColor,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  commentsText,
                  style: TextStyle(
                    color: GerenaColors.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }Widget _buildSocialArticlesGrid(BlogController controller) {
  final socialArticles = controller.getSocialArticles();
  
  return LayoutBuilder(
    builder: (context, constraints) {
      // Obtener el ancho disponible
      double screenWidth = constraints.maxWidth;
      
      // Definir el ancho mínimo que necesita cada tarjeta de artículo
      double cardMinWidth = 250.0; // Ajusta según tu diseño de tarjeta
      
      // Calcular cuántas columnas pueden caber
      int crossAxisCount = (screenWidth / cardMinWidth).floor();
      
      // Limitar entre 1 y 4 columnas máximo (ajusta según prefieras)
      crossAxisCount = crossAxisCount.clamp(1, 4);
      
      // Ajustar el espaciado según el número de columnas
      double crossAxisSpacing = crossAxisCount == 1 ? 0 : 
                               crossAxisCount == 2 ? 20 : 
                               crossAxisCount == 3 ? 40 : 60;
      
      // Ajustar el aspect ratio según el número de columnas
      double childAspectRatio = crossAxisCount == 1 ? 0.9 : 
                               crossAxisCount == 2 ? 1.0 : 
                               0.8;
      
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: 16,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: socialArticles.length,
        itemBuilder: (context, index) {
          final article = socialArticles[index];
          
          return GerenaColors.createArticleCard(
            title: article['title']!,
            content: article['content']!,
            date: article['date']!,
            imagePath: article['image']!,
            onReadMorePressed: () {
              controller.showSocialArticleDetails(article);
            },
          );
        },
      );
    },
  );
}

}