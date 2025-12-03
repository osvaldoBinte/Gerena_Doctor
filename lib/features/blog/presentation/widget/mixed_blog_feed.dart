import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/blog/presentation/page/blogGerena/blog_controller.dart';
import 'package:gerena/features/blog/presentation/widget/loading/mixed_blog_feed_loading.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/image_placeholder_widget.dart';
import 'package:get/get.dart';

class MixedBlogFeed extends StatefulWidget {
  const MixedBlogFeed({Key? key}) : super(key: key);

  @override
  State<MixedBlogFeed> createState() => _MixedBlogFeedState();
}

class _MixedBlogFeedState extends State<MixedBlogFeed> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<BlogController>();
    
    if (controller.blogGerenaList.isEmpty) {
      controller.loadBlogGerenaArticles();
    }
    if (controller.blogSocialList.isEmpty) {
      controller.loadBlogSocialArticles();
    }
  }

  void _navigateToForum(BlogController controller, int articleId, bool isGerena) {
 
    if (isGerena) {
      controller.showArticleDetailView(articleId);
    } else {
      controller.showSocialArticleDetails(articleId);
    }
    
    Get.find<ShopNavigationController>().navigateToBlogGerena();
    Get.to(() => GlobalShopInterface());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BlogController>();

    return Obx(() {
      if (controller.isLoadingGerena.value || controller.isLoadingSocial.value) {
               return const MixedBlogFeedLoading();

      }

      final mixedList = _buildMixedList(controller);

      if (mixedList.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Text(
              'No hay contenido disponible',
              style: GerenaColors.bodyMedium.copyWith(
                color: GerenaColors.textSecondaryColor,
              ),
            ),
          ),
        );
      }

      return Column(
        children: [
         
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mixedList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = mixedList[index];

              if (item['type'] == 'gerena') {
                final article = item['data'];
                return GerenaColors.createArticleCard(
                  title: article.title ?? '',
                  content: article.content ?? '',
                  date: 'Blog Gerena | ${article.date ?? 'Hoy'}',
                  imagePath: article.imageUrl ?? '',
                  onReadMorePressed: () {
                    _navigateToForum(controller, article.id, true);
                  },
                );
              } else if (item['type'] == 'pregunta') {
                final article = item['data'];
                return _buildQuestionCard(article, controller);
              } else if (item['type'] == 'noticia') {
                final article = item['data'];
                return GerenaColors.createArticleCard(
                  title: article.titulo ?? '',
                  content: article.descripcion ?? '',
                  
                  date: 'Blog Social | ${_formatDate(article.creadoEn)}',
                  imagePath: article.imagenUrl ?? '',
                  onReadMorePressed: () {
                    _navigateToForum(controller, article.id, false);
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      );
    });
  }

  Widget _buildBadge(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

List<Map<String, dynamic>> _buildMixedList(BlogController controller) {
  final List<Map<String, dynamic>> mixedList = [];

  final gerenaArticles = controller.blogGerenaList.toList()
    ..sort((a, b) {
      final dateA = a.date != null ? _parseDate(a.date!) : DateTime(1970);
      final dateB = b.date != null ? _parseDate(b.date!) : DateTime(1970);
      return dateB.compareTo(dateA); 
    });

  final preguntas = controller.blogSocialList
      .where((article) => article.tipoPregunta?.toLowerCase() == 'pregunta')
      .toList()
    ..sort((a, b) {
      final dateA = a.creadoEn != null ? DateTime.parse(a.creadoEn!) : DateTime(1970);
      final dateB = b.creadoEn != null ? DateTime.parse(b.creadoEn!) : DateTime(1970);
      return dateB.compareTo(dateA); 
    });

  final noticias = controller.blogSocialList
      .where((article) => article.tipoPregunta?.toLowerCase() == 'noticia')
      .toList()
    ..sort((a, b) {
      final dateA = a.creadoEn != null ? DateTime.parse(a.creadoEn!) : DateTime(1970);
      final dateB = b.creadoEn != null ? DateTime.parse(b.creadoEn!) : DateTime(1970);
      return dateB.compareTo(dateA);
    });

  if (gerenaArticles.isNotEmpty) {
    mixedList.add({
      'type': 'gerena',
      'data': gerenaArticles.first,
    });
  }

  if (preguntas.isNotEmpty) {
    mixedList.add({
      'type': 'pregunta',
      'data': preguntas.first, 
    });
  }

  if (noticias.isNotEmpty) {
    mixedList.add({
      'type': 'noticia',
      'data': noticias.first, 
    });
  }

  return mixedList;
}

DateTime _parseDate(String dateString) {
  try {
    return DateTime.parse(dateString);
  } catch (e) {
    try {
      return DateTime(1970);
    } catch (e) {
      return DateTime(1970);
    }
  }
}
 Widget _buildQuestionCard(dynamic article, BlogController controller) {
  return GestureDetector(
    onTap: () => _navigateToForum(controller, article.id, false),
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
            article.titulo ?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: GerenaColors.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'ver comentarios',
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

  String _formatDate(String? dateString) {
  if (dateString == null || dateString.isEmpty) return 'Hoy';
  
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
      final months = [
        'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
        'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
      ];
      return '${date.day} de ${months[date.month - 1]}';
    }
  } catch (e) {
    return dateString; 
  }
}
}