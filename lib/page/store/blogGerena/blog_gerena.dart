import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/widgets_gobal.dart';
import 'package:gerena/page/store/blogGerena/article_detail_screen.dart';
import 'package:gerena/page/store/blogGerena/blog_controller.dart';
import 'package:gerena/page/store/blogGerena/blog_social.dart';
import 'package:get/get.dart';
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
                  Padding(
  padding: EdgeInsets.symmetric(horizontal: _getResponsivePadding(context)),
  child: _buildArticleDetailContent(controller),
)
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
  double _getResponsivePadding(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth > 1200) return 300;
  if (screenWidth > 900) return 150;
  if (screenWidth > 600) return 80;
  return 20;
}
Widget _buildArticleDetailContent(BlogController controller) {
  if (controller.selectedArticle == null) return const SizedBox.shrink();
  
  final article = controller.selectedArticle!;
  final screenWidth = MediaQuery.of(Get.context!).size.width;
  final isTablet = screenWidth > 600;
  
  String content = article['content']!;
  List<String> sentences = content.split('. ');
  
  String part1 = sentences.take(2).join('. ') + '.';
  String part2 = sentences.length > 4 ? sentences[2] + '.' : sentences.take(3).join('. ');
  String part3 = sentences.skip(3).join('. ');

  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: isTablet ? 100 : 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 50 : 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12), 
            child: Image.asset(
              article['image']!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
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
          part1,
          style: GerenaColors.bodyLarge.copyWith(height: 1.6),
        ),
        
        const SizedBox(height: 24),
        
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                article['image']!,
                width: isTablet ? 120 : 100,
                height: isTablet ? 90 : 75,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                part2,
                style: GerenaColors.bodyLarge.copyWith(
                  height: 1.6,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        Text(
          part3,
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
  Widget _buildBlogGerenaContent(BlogController controller) {
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
  }

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