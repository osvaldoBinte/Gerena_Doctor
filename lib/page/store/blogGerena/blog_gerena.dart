import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/widgets_gobal.dart';
import 'package:gerena/page/store/blogGerena/article_detail_screen.dart';
import 'package:gerena/page/store/blogGerena/blog_controller.dart';
import 'package:gerena/page/store/blogGerena/blog_social.dart';
import 'package:provider/provider.dart';

class BlogGerena extends StatelessWidget {
  const BlogGerena({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BlogController(),
      child: const _BlogGerenaContent(),
    );
  }
}

class _BlogGerenaContent extends StatelessWidget {
  const _BlogGerenaContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<BlogController>(
      builder: (context, controller, child) {
        return Scaffold(
        
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: AppBar(
              backgroundColor: GerenaColors.backgroundColorFondo, 
              elevation: 0,
            ),
          ),
          backgroundColor: GerenaColors.backgroundColorfondo,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(GerenaColors.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(controller),
                
                const SizedBox(height: 10),
                Divider(
                  color: GerenaColors.primaryColor.withOpacity(0.3),
                  thickness: 1,
                ),
                const SizedBox(height: 10),
                
                if (controller.showArticleDetail && !controller.showBlogSocial) 
                  buildBackButton(controller),

                if (controller.showArticleDetail && !controller.showBlogSocial)
                  _buildArticleDetailContent(controller)
                else if (controller.showBlogSocial) 
                  _buildBlogSocialContent()
                else 
                  _buildBlogGerenaContent(controller),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildArticleDetailContent(BlogController controller) {
    if (controller.selectedArticle == null) return const SizedBox.shrink();
    
    final article = controller.selectedArticle!;
    
    return SingleChildScrollView(
  padding: const EdgeInsets.symmetric(horizontal: 100), 
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
   Padding(
  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
  child: Image.asset(
    article['image']!,
    width: double.infinity,
    fit: BoxFit.fitHeight,
   
  ),
),
      
      const SizedBox(height: 24),
      
      Container(
        padding: const EdgeInsets.all(GerenaColors.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            
            Text(
              article['title']!,
              style: GerenaColors.headingLarge.copyWith(
                fontSize: 28,
                height: 1.3,
                color: GerenaColors.textTertiaryColor
              ),
            ),
            
            const SizedBox(height: 24),
            
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
Widget _buildHeader(BlogController controller) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double fontSize = (constraints.maxWidth * 0.03).clamp(16.0, 32.0);
      double spacing = (constraints.maxWidth * 0.08).clamp(20.0, 90.0);
      
      bool isSmallScreen = constraints.maxWidth < 768; 
      
      return Row(
        mainAxisAlignment: isSmallScreen 
            ? MainAxisAlignment.center 
            : MainAxisAlignment.start, 
        children: [
          GestureDetector(
            onTap: () => controller.showBlogGerenaSection(),
            child: Text(
              'Blog Gerena',
              style: GerenaColors.headingLarge.copyWith(
                color: !controller.showBlogSocial
                   ? GerenaColors.primaryColor
                   : GerenaColors.colorSubsCardDuration,
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          
          SizedBox(width: spacing),
          
          GestureDetector(
            onTap: () => controller.showBlogSocialSection(),
            child: Text(
              'Blog Social',
              style: GerenaColors.headingLarge.copyWith(
                color: controller.showBlogSocial
                   ? GerenaColors.primaryColor
                   : GerenaColors.colorSubsCardDuration,
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ],
      );
    },
  );
}
  // Contenido del Blog Gerena (vista principal)
  Widget _buildBlogGerenaContent(BlogController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Secciones principales del blog
        _buildBlogSections(controller),
        
        const SizedBox(height: 24),
        
        Divider(
          color: GerenaColors.primaryColor.withOpacity(0.3),
          thickness: 1,
        ),
        
        const SizedBox(height: 24),

        Text(
          'Artículos recientes',
          style: GerenaColors.headingLarge,
        ),
        
        const SizedBox(height: 16),
        
        // Grid de artículos
        _buildArticlesGrid(controller),
      ],
    );
  }

  // Contenido del Blog Social (clase BlogSocial)
  Widget _buildBlogSocialContent() {
    return const BlogSocial();
  }
  
  
  Widget _buildBlogSections(BlogController controller) {
  final articles = controller.getBlogSectionArticles();
  
  return LayoutBuilder(
    builder: (context, constraints) {
     
      double screenWidth = constraints.maxWidth;
      
      double cardMinWidth = 250.0; 
      
      int crossAxisCount = (screenWidth / cardMinWidth).floor();
      
      crossAxisCount = crossAxisCount.clamp(1, 4);
      
      double crossAxisSpacing = crossAxisCount == 1 ? 0 : 
                               crossAxisCount == 2 ? 20 : 
                               crossAxisCount == 3 ? 40 : 60;
      
      double childAspectRatio = crossAxisCount == 1 ? 0.9  : 
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
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          
          return GerenaColors.createArticleCard(
            title: article['title']!,
            content: article['content']!,
            date: article['date']!,
            imagePath: article['image']!,
            onReadMorePressed: () => controller.showArticleDetailView(article),
          );
        },
      );
    },
  );
}
Widget _buildArticlesGrid(BlogController controller) {
  final articles = controller.getRecentArticles();
  
  return LayoutBuilder(
    builder: (context, constraints) {
      // Obtener el ancho disponible
      double screenWidth = constraints.maxWidth;
      
      // Definir el ancho mínimo que necesita cada tarjeta de artículo
      double cardMinWidth = 250.0; // Ajusta según tu diseño
      
      // Calcular cuántas columnas pueden caber
      int crossAxisCount = (screenWidth / cardMinWidth).floor();
      
      // Limitar entre 1 y 4 columnas máximo
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
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          
          return GerenaColors.createArticleCard(
            title: article['title']!,
            content: article['content']!,
            date: article['date']!,
            imagePath: article['image']!,
            onReadMorePressed: () => controller.showArticleDetailView(article),
          );
        },
      );
    },
  );
}
}