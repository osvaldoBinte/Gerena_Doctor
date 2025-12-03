import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/widgets_gobal.dart';
import 'package:gerena/features/banners/presentation/widgets/image_viewer_dialog.dart';
import 'package:gerena/features/blog/domain/entities/blog_gerena_entity.dart';
import 'package:gerena/features/blog/presentation/page/blogGerena/blog_controller.dart';
import 'package:gerena/features/blog/presentation/page/blogSocial/blog_social.dart';
import 'package:gerena/features/blog/presentation/widget/loading/blog_loading_widgets.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/image_placeholder_widget.dart';
import 'package:get/get.dart';

class BlogGerena extends StatelessWidget {
  const BlogGerena({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BlogController>();
    
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
            
Obx(() {
  if (controller.showArticleDetail.value && !controller.showBlogSocial.value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        Align(
          alignment: Alignment.centerLeft, 
          child: buildBackButton(controller),
        ),
        if (controller.isLoadingDetail.value)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (controller.selectedArticle.value != null)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _getResponsivePadding(context),
            ),
            child: _buildArticleDetailContent(controller),
          ),
      ],
    );
  } else if (controller.showBlogSocial.value) {
    return _buildBlogSocialContent();
  } else {
    return _buildBlogGerenaContent(controller);
  }
}),
          ],
        ),
      ),
    );
  }

  double _getResponsivePadding(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return 300;
    if (screenWidth > 900) return 150;
    if (screenWidth > 600) return 80;
    return 20;
  }Widget _buildArticleDetailContent(BlogController controller) {
  final article = controller.selectedArticle.value;
  if (article == null) return const SizedBox.shrink();
  
  final screenWidth = MediaQuery.of(Get.context!).size.width;
  final isTablet = screenWidth > 600;
  
  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: isTablet ? 100 : 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 50 : 0),
            child: GestureDetector(
              onTap: () {
                ImageViewerDialog.show(
                  Get.context!,
                  article.imageUrl!,
                );
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 9, 
                      child: NetworkImageWidget(
                        imageUrl: article.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.zoom_in,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        
        const SizedBox(height: 24),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              article.date ?? 'Hoy',
              style: GerenaColors.bodySmall.copyWith(
                color: GerenaColors.textTertiaryColor,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              'Blog Gerena',
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
          article.title ?? '',
          style: GerenaColors.headingLarge.copyWith(
            fontSize: 28,
            height: 1.3,
            color: GerenaColors.textTertiaryColor,
          ),
        ),
        
        const SizedBox(height: 24),
        
        Text(
          article.content ?? '',
          style: GerenaColors.bodyLarge.copyWith(height: 1.6),
        ),
        
        const SizedBox(height: 24),
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
        
        return Obx(() => Row(
          mainAxisAlignment: isSmallScreen 
              ? MainAxisAlignment.center 
              : MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => controller.showBlogGerenaSection(),
              child: Text(
                'Blog Gerena',
                style: GerenaColors.headingLarge.copyWith(
                  color: !controller.showBlogSocial.value
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
                  color: controller.showBlogSocial.value
                     ? GerenaColors.primaryColor
                     : GerenaColors.colorSubsCardDuration,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ],
        ));
      },
    );
  }

  Widget _buildBlogGerenaContent(BlogController controller) {
    return Obx(() {
      if (controller.isLoadingGerena.value) {
        return const BlogGerenaLoading();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          
          _buildArticlesGrid(controller),
        ],
      );
    });
  }

  Widget _buildBlogSocialContent() {
    return const BlogSocial();
  }
  
  Widget _buildBlogSections(BlogController controller) {
    return Obx(() {
      final articles = controller.blogGerenaList.take(2).toList();
      
      if (articles.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: Text('No hay artículos disponibles'),
          ),
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double cardMinWidth = 250.0;
          
          int crossAxisCount = (screenWidth / cardMinWidth).floor();
          crossAxisCount = crossAxisCount.clamp(1, 4);
          
          double crossAxisSpacing = crossAxisCount == 1 ? 0 : 
                                   crossAxisCount == 2 ? 20 : 
                                   crossAxisCount == 3 ? 40 : 60;
          
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
                title: article.title ?? '',
                content: article.content ?? '',
                date: article.date ?? 'Hoy',
                imagePath: article.imageUrl ?? '',

              isLoading: controller.isLoadingDetail.value,
                onReadMorePressed: () => controller.showArticleDetailView(article.id),
              );
            },
          );
        },
      );
    });
  }

  Widget _buildArticlesGrid(BlogController controller) {
  return Obx(() {
    final articles = controller.blogGerenaList;
    
    if (articles.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Text('No hay artículos recientes'),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double cardMinWidth = 250.0;
        
        int crossAxisCount = (screenWidth / cardMinWidth).floor();
        crossAxisCount = crossAxisCount.clamp(1, 4);
        
        double crossAxisSpacing = crossAxisCount == 1 ? 0 : 
                                 crossAxisCount == 2 ? 20 : 
                                 crossAxisCount == 3 ? 40 : 60;
        
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
              title: article.title ?? '',
              content: article.content ?? '',
              date: article.date ?? 'Hoy',
              imagePath: article.imageUrl ?? '',
              
              isLoading: controller.isLoadingDetail.value,
              onReadMorePressed: () => controller.showArticleDetailView(article.id),
            );
          },
        );
      },
    );
  });
}
}