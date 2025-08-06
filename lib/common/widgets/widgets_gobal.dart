
  import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/page/store/blogGerena/blog_controller.dart';

Widget buildBackButton(BlogController controller) {
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
            onPressed: () => controller.goBackFromArticleDetail(),
            icon: Icon(
              Icons.arrow_back,
              color: GerenaColors.backgroundColor,
            ),
          ),
                    );
  }


  Widget buildArticleDetailContent(BlogController controller) {
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
  child: Container(
    height: 350,
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(article['image']!),
        fit: BoxFit.contain, // ← CAMBIO AQUÍ: de cover a contain
      ),
    ),
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