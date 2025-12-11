import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/publications/domain/entities/myposts/image_entity.dart';
import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/presentation/widget/review_widget.dart';
import 'package:gerena/features/review/presentation/page/review_controller.dart';
import 'package:gerena/features/review/presentation/widget/reviews_loading.dart';
import 'package:get/get.dart';
class ReviewsWidget extends StatelessWidget {
  const ReviewsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ReviewController>(
      builder: (controller) {
        if (controller.isLoading.value) {
          return const ReviewsLoading();
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red[300],
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    style: GerenaColors.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.refreshReviews,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GerenaColors.primaryColor,
                    ),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.reviews.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.rate_review_outlined,
                    color: Colors.grey[400],
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay reseñas disponibles',
                    style: GerenaColors.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return _buildReviewsList(controller.reviews, context);
      },
    );
  }

  Widget _buildReviewsList(List<PublicationEntity> reviews, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: reviews.map((review) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildReviewCard(review, context),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReviewCard(PublicationEntity review, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: GerenaColors.smallBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReviewHeader(review),
          const SizedBox(height: 12),
         
          Text(
            review.description,
            style: GerenaColors.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildReviewImages(review.images),
          ],
          const SizedBox(height: 12),
          _buildReviewFooter(review),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _showReviewModal(context, review),
              style: TextButton.styleFrom(
                foregroundColor: GerenaColors.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ver publicación',
                    style: GerenaColors.bodyMedium.copyWith(
                      color: GerenaColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: GerenaColors.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

void _showReviewModal(BuildContext context, PublicationEntity review) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: GerenaColors.backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header con botón cerrar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Publicación',
                      style: GerenaColors.headingSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: GerenaColors.textSecondary,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              // Contenido scrollable
              Flexible(
                child: SingleChildScrollView(
                  child: ReviewWidget(
                    postId: review.id,
                    userName: review.author?.name ?? 'Usuario',
                    date: _formatDate(review.createdAt),
                    title: review.taggedDoctor?.nombreCompleto ?? '',
                    content: review.description,
                    images: review.images.map((img) => img.imageUrl).toList(),
                    userRole: review.taggedDoctor?.especialidad ?? '',
                    rating: review.rating?.toDouble() ?? 0,
                    reactions: review.reactions.total,
                    avatarPath: review.author?.profilePhoto,
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(16),
                    showAgendarButton: true,
                    isReview: true,
                    userReaction: review.userreaction,
                    showDeleteButton: false,
                    doctorData: review.taggedDoctor != null
                        ? {
                            'id': review.taggedDoctor!.id,
                            'nombreCompleto': review.taggedDoctor!.nombreCompleto,
                            'especialidad': review.taggedDoctor!.especialidad,
                            'fotoPerfil': review.taggedDoctor!.fotoPerfil,
                          }
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
  Widget _buildReviewHeader(PublicationEntity review) {
    final author = review.author;
    final authorName = author?.name ?? 'Usuario';
    final authorPhoto = author?.profilePhoto;

    return Row(
      children: [
        // Avatar del autor
        CircleAvatar(
          radius: 20,
          backgroundColor: GerenaColors.primaryColor,
          backgroundImage: authorPhoto != null && authorPhoto.isNotEmpty
              ? NetworkImage(authorPhoto)
              : null,
          onBackgroundImageError: authorPhoto != null && authorPhoto.isNotEmpty
              ? (exception, stackTrace) {
                  // Error manejado con el child de fallback
                }
              : null,
          child: authorPhoto == null || authorPhoto.isEmpty
              ? Text(
                  authorName.isNotEmpty ? authorName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorName,
                style: GerenaColors.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildStarRating(review.rating?.toDouble() ?? 0),
                  const SizedBox(width: 8),
                  Text(
                    '${review.rating ?? 0}/5',
                    style: GerenaColors.bodySmall.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildReviewImages(List<ImageEntity> images) {
    // Ordenar imágenes por el campo order
    final sortedImages = List<ImageEntity>.from(images)
      ..sort((a, b) => a.order.compareTo(b.order));

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sortedImages.length,
        itemBuilder: (context, index) {
          final image = sortedImages[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: GerenaColors.smallBorderRadius,
              color: GerenaColors.backgroundColorfondo,
            ),
            child: ClipRRect(
              borderRadius: GerenaColors.smallBorderRadius,
              child: Image.network(
                image.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: GerenaColors.backgroundColorfondo,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: GerenaColors.backgroundColorfondo,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image,
                          color: Colors.grey[400],
                          size: 32,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Error al cargar',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewFooter(PublicationEntity review) {
    final reactions = review.reactions;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Reacciones totales
        Row(
          children: [
            Icon(
              Icons.favorite,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              '${reactions.total} reacciones',
              style: GerenaColors.bodySmall.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        // Fecha
        Text(
          _formatDate(review.createdAt),
          style: GerenaColors.bodySmall.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(
            Icons.star,
            color: GerenaColors.accentColor,
            size: 18,
          );
        } else if (index < rating) {
          return const Icon(
            Icons.star_half,
            color: GerenaColors.accentColor,
            size: 18,
          );
        } else {
          return const Icon(
            Icons.star_border,
            color: GerenaColors.accentColor,
            size: 18,
          );
        }
      }),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Hace un momento';
        }
        return 'Hace ${difference.inMinutes}m';
      }
      return 'Hace ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays}d';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Hace ${weeks}sem';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Hace ${months}m';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }
}