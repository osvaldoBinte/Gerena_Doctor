import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gerena/page/store/blogGerena/article_detail_screen.dart';
import 'package:gerena/page/store/blogGerena/blog_controller.dart';
import 'package:gerena/page/store/blogGerena/preguntas.dart';
import 'package:get/get.dart';
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
            if (controller.showSocialArticleDetail)
              _buildBackButton(controller),

            if (controller.showSocialArticleDetail)
            Padding(
  padding: EdgeInsets.symmetric(horizontal: _getResponsivePadding(context)),
  child: _buildArticleDetailContent(controller),
)
            else if (controller.showQuestions)
              const DialogoAbierto()
            else
              _buildBlogSocialContent(controller),
          ],
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
      child: IconButton(
        onPressed: () => controller.goBackToBlogSocial(),
        icon: Icon(
          Icons.arrow_back,
          color: GerenaColors.backgroundColor,
        ),
      ),
    );
  }

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
                    items:
                        controller.getCarouselQuestions().map((questionData) {
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
        _buildSocialArticlesGrid(controller),
      ],
    );
  }



  Widget _buildArticleDetailContent(BlogController controller) {
  if (controller.selectedSocialArticle == null) return const SizedBox.shrink();

  final article = controller.selectedSocialArticle!;
  
  String content = article['content']!;
  List<String> sentences = content.split('. ');
  
  String part1 = sentences.take(2).join('. ') + '.';
  String part2 = sentences.length > 4 ? sentences[2] + '.' : sentences.take(3).join('. ');
  String part3 = sentences.skip(3).join('. ');

  return SingleChildScrollView(
    padding: EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Image.asset(article['image']!, fit: BoxFit.cover),
        Padding(padding: EdgeInsets.symmetric(horizontal: 50)
 ,
      child:         Image.network(article['image']!, fit: BoxFit.cover),
       ),
        SizedBox(height: 20),

        
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
        SizedBox(height: 16),
        
        Text(part1, style: TextStyle(fontSize: 16, height: 1.5)),
        SizedBox(height: 16),
        
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(article['image']!, width:  120 , height:  60, fit: BoxFit.cover),
            SizedBox(width: 12),
            Expanded(child: Text(part2, style: TextStyle(fontSize: 14, height: 1.5))),
          ],
        ),
        SizedBox(height: 16),
        
        Text(part3, style: TextStyle(fontSize: 16, height: 1.5)),
      ],
    ),
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
  }

  Widget _buildSocialArticlesGrid(BlogController controller) {
    final socialArticles = controller.getSocialArticles();

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        double cardMinWidth = 250.0;

        int crossAxisCount = (screenWidth / cardMinWidth).floor();

        crossAxisCount = crossAxisCount.clamp(1, 4);

        double crossAxisSpacing = crossAxisCount == 1
            ? 0
            : crossAxisCount == 2
                ? 20
                : crossAxisCount == 3
                    ? 40
                    : 60;

        double childAspectRatio = crossAxisCount == 1
            ? 0.9
            : crossAxisCount == 2
                ? 1.0
                : 0.8;

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
