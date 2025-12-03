import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gerena/features/banners/presentation/widgets/image_viewer_dialog.dart';
import 'package:gerena/features/blog/presentation/page/blogGerena/blog_controller.dart';
import 'package:gerena/features/blog/presentation/page/blogSocial/preguntas.dart';
import 'package:gerena/features/blog/presentation/page/blogSocial/create_blog_social_form.dart';
import 'package:gerena/features/blog/presentation/widget/loading/blog_loading_widgets.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/image_placeholder_widget.dart';
import 'package:get/get.dart';

class BlogSocial extends StatelessWidget {
  const BlogSocial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BlogController>();
    
    return Obx(() {
      if (controller.showCreateBlogSocial.value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBackButton(controller),
          const SizedBox(height: 16),
          const CreateBlogSocialForm(),
        ],
      );
    }
      if (controller.showSocialArticleDetail.value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackButton(controller),
            if (controller.isLoadingDetail.value)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (controller.selectedSocialArticle.value != null)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _getResponsivePadding(context),
                ),
                child: _buildArticleDetailContent(controller, context),
              ),
          ],
        );
      } else if (controller.showQuestions.value) {
        return const DialogoAbierto();
      } else {
        return _buildBlogSocialContent(controller);
      }
    });
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
    return Obx(() {
      if (controller.isLoadingSocial.value) {
        return BlogGerenaLoading();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                  Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () => controller.showCreateBlogSocialForm(),
            icon: const Icon(Icons.add),
            label: const Text('CREAR PUBLICACIÓN'),
            style: ElevatedButton.styleFrom(
              backgroundColor: GerenaColors.primaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        

          _buildCarouselSection(controller),
          const SizedBox(height: 24),
          Divider(
            color: GerenaColors.primaryColor.withOpacity(0.3),
            thickness: 1,
          ),
          const SizedBox(height: 24),
          _buildSocialArticlesGrid(controller),
        ],
      );
    });
  }
Widget _buildArticleDetailContent(BlogController controller, BuildContext context) {
  final article = controller.selectedSocialArticle.value;
  if (article == null) return const SizedBox.shrink();

  return SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (article.imagenUrl != null && article.imagenUrl!.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _getResponsivePadding(context) * 0.3,
            ),
            child: GestureDetector(
              onTap: () {
                ImageViewerDialog.show(
                  context,
                  article.imagenUrl!,
                );
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 9, 
                      child: NetworkImageWidget(
                        imageUrl: article.imagenUrl,
                        
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
        const SizedBox(height: 20),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              article.creadoEn != null 
                  ? _formatDate(article.creadoEn!)
                  : 'Hoy',
              style: GerenaColors.bodySmall.copyWith(
                color: GerenaColors.textTertiaryColor,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              'Blog Social',
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
          article.titulo ?? '',
          style: GerenaColors.headingLarge.copyWith(
            fontSize: 28,
            height: 1.3,
            color: GerenaColors.textTertiaryColor,
          ),
        ),
        const SizedBox(height: 16),
        
        Text(
          article.descripcion ?? '',
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 24),
        
        Align(
          alignment: Alignment.centerRight,
          child: GerenaColors.createPrimaryButton(
            text: "RESPONDER",
            onPressed: () => _showResponseDialog(context, article.id),
            height: 40,
          ),
        ),
        
        const SizedBox(height: 24),
        
        if (article.respuestas != null && article.respuestas!.isNotEmpty) ...[
          Divider(
            color: GerenaColors.primaryColor.withOpacity(0.3),
            thickness: 1,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 20,
                color: GerenaColors.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Respuestas (${article.respuestasCount ?? article.respuestas!.length})',
                style: GerenaColors.headingMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...article.respuestas!.map((respuesta) => _buildAnswerCard(respuesta)),
        ] else ...[
          Divider(
            color: GerenaColors.primaryColor.withOpacity(0.3),
            thickness: 1,
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 40,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  'Aún no hay respuestas',
                  style: GerenaColors.bodyMedium.copyWith(
                    color: GerenaColors.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '¡Sé el primero en responder!',
                  style: GerenaColors.bodySmall.copyWith(
                    color: GerenaColors.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    ),
  );
}

  Widget _buildAnswerCard(dynamic respuesta) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: GerenaColors.smallBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: GerenaColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.person,
              color: GerenaColors.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      respuesta.usuarioNombre??'',
                      style: GerenaColors.headingSmall.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (respuesta.actualizadoEn != null)
                      Text(
                        _formatDate(respuesta.actualizadoEn!),
                        style: GerenaColors.bodySmall.copyWith(
                          color: GerenaColors.textSecondaryColor,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  respuesta.contenido ?? '',
                  style: GerenaColors.bodyMedium.copyWith(
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

String _formatDate(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  } catch (e) {
    return dateString;
  }
}

  void _showResponseDialog(BuildContext context, int questionId) async {
    final controller = Get.find<BlogController>();
    final responseController = TextEditingController();
    
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                color: GerenaColors.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Responder',
                style: GerenaColors.headingMedium,
              ),
            ],
          ),
          content: SizedBox(
            width: 700,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Escribe tu respuesta:',
                      style: GerenaColors.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: responseController,
                      maxLines: 5,
                      maxLength: 280,
                      decoration: InputDecoration(
                        hintText: 'Comparte tu opinión o experiencia...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: GerenaColors.primaryColor,
                            width: 2,
                          ),
                        ),
                        counterText: '',
                      ),
                      onChanged: (value) {
                       
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${responseController.text.length}/280',
                        style: GerenaColors.bodySmall.copyWith(
                          color: responseController.text.length > 280
                              ? Colors.red
                              : GerenaColors.textSecondaryColor,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'CANCELAR',
                style: TextStyle(color: GerenaColors.textSecondaryColor),
              ),
            ),
           Obx(() => controller.isLoadingDetail.value
    ? const Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      )
    : GerenaColors.createPrimaryButton(
        text: "ENVIAR",
        onPressed: () async {
          await controller.sendAnswer(
            questionId: questionId,
            answer: responseController.text.trim(),
          
          );
        },
        height: 40,
      ),
),
          ],
        );
      },
    );
  }

  Widget _buildCarouselSection(BlogController controller) {
    return Obx(() {
      final questions = controller.getQuestions();

      if (questions.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Row(
              children: [
                Icon(
                  Icons.question_answer,
                  color: GerenaColors.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Preguntas Abiertas',
                  style: GerenaColors.headingMedium.copyWith(
                    color: GerenaColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
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
                        height: 160,
                        viewportFraction: viewportFraction,
                        enableInfiniteScroll: questions.length > maxVisibleCards,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: false,
                        scrollDirection: Axis.horizontal,
                      ),
                      items: questions.map((question) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: _buildQuestionCardCustom(
                                title: question.titulo ?? '',
                                tipoPregunta: question.tipoPregunta ?? '',
                                commentsCount: question.respuestasCount ?? 0,
                                onTap: () {
                                  controller.showSocialArticleDetails(question.id);
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
        ],
      );
    });
  }

  Widget _buildQuestionCardCustom({
    required String title,
    required String tipoPregunta,
    required int commentsCount,
    required VoidCallback onTap,
  }) {
    Color getTipoPreguntaColor() {
      switch (tipoPregunta.toLowerCase()) {
        case 'general':
          return Colors.blue;
        case 'técnica':
        case 'tecnica':
          return Colors.purple;
        case 'experiencia':
          return Colors.green;
        case 'recomendación':
        case 'recomendacion':
          return Colors.orange;
        default:
          return GerenaColors.primaryColor;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: GerenaColors.smallBorderRadius,
          boxShadow: [GerenaColors.lightShadow],
          border: Border.all(
            color: getTipoPreguntaColor().withOpacity(0.3),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: getTipoPreguntaColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tipoPregunta.toUpperCase(),
                style: TextStyle(
                  color: getTipoPreguntaColor(),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: GerenaColors.textPrimaryColor,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  color: GerenaColors.textSecondaryColor,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Ver respuestas',
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
  return Obx(() {
    final socialArticles = controller.blogSocialList
        .where((article) => article.tipoPregunta?.toLowerCase() == 'noticia')
        .toList();

    if (socialArticles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Icon(
                Icons.newspaper_outlined,
                size: 60,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No hay noticias disponibles',
                style: GerenaColors.bodyMedium.copyWith(
                  color: GerenaColors.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double cardMinWidth = 280.0;

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
            ? 1.1
            : crossAxisCount == 2
                ? 0.85
                : 0.75;

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
              title: article.titulo ?? '',
              content: article.descripcion ?? '',
              date: article.creadoEn != null 
                  ? _formatDate(article.creadoEn!) 
                  : '',
              imagePath: article.imagenUrl ?? '',
              // ✅ Pasamos el estado de loading
              isLoading: controller.isLoadingDetail.value,
              onReadMorePressed: () {
                controller.showSocialArticleDetails(article.id);
              },
            );
          },
        );
      },
    );
  });

}
}