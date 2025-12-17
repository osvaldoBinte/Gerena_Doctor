import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/doctors/presentation/page/doctorProfilePage/doctor_profilebyid_controller.dart';
import 'package:gerena/features/publications/domain/entities/myposts/image_entity.dart';
import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/presentation/widget/review_widget.dart';
import 'package:gerena/features/review/presentation/widget/reviews_loading.dart';
import 'package:get/get.dart';

class ReviewsByDoctorWidget extends StatelessWidget {
  const ReviewsByDoctorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<DoctorProfilebyidController>(
      builder: (controller) {
        if (controller.isLoadingAllPublications.value) {
          return const ReviewsLoading();
        }

        if (controller.errorMessageAllPublications.value.isNotEmpty) {
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
                    controller.errorMessageAllPublications.value,
                    style: GerenaColors.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.refreshAllPublications,
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

        if (controller.allPublications.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.library_books_outlined,
                    color: Colors.grey[400],
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay publicaciones ni reseñas disponibles',
                    style: GerenaColors.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return _buildPublicationsList(controller.allPublications, context);
      },
    );
  }

  Widget _buildPublicationsList(List<PublicationEntity> publications, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: publications.map((publication) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildPublicationCard(publication, context),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPublicationCard(PublicationEntity publication, BuildContext context) {
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
          // Badge para identificar el tipo
          _buildPublicationTypeBadge(publication),
          const SizedBox(height: 8),
          _buildPublicationHeader(publication),
          const SizedBox(height: 12),
          Text(
            publication.description,
            style: GerenaColors.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (publication.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildPublicationImages(publication.images),
          ],
          const SizedBox(height: 12),
          _buildPublicationFooter(publication),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _showPublicationModal(context, publication),
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

  // NUEVO: Badge para identificar si es reseña o publicación
  Widget _buildPublicationTypeBadge(PublicationEntity publication) {
    final isReview = publication.isReview;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isReview 
            ? GerenaColors.accentColor.withOpacity(0.1)
            : GerenaColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isReview ? Icons.star : Icons.article,
            size: 14,
            color: isReview ? GerenaColors.accentColor : GerenaColors.primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            isReview ? 'Reseña' : 'Publicación',
            style: GerenaColors.bodySmall.copyWith(
              color: isReview ? GerenaColors.accentColor : GerenaColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showPublicationModal(BuildContext context, PublicationEntity publication) {
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
                        publication.isReview ? 'Reseña' : 'Publicación',
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
                Flexible(
                  child: SingleChildScrollView(
                    child: ReviewWidget(
                      postId: publication.id,
                      userName: publication.author?.name ?? 'Usuario',
                      date: _formatDate(publication.createdAt),
                      title: publication.taggedDoctor?.nombreCompleto ?? '',
                      content: publication.description,
                      images: publication.images.map((img) => img.imageUrl).toList(),
                      userRole: publication.taggedDoctor?.especialidad ?? '',
                      rating: publication.rating?.toDouble() ?? 0,
                      reactions: publication.reactions.total,
                      avatarPath: publication.author?.profilePhoto,
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.all(16),
                      showAgendarButton: true,
                      isReview: publication.isReview,
                      userReaction: publication.userreaction,
                      showDeleteButton: false,
                      doctorData: publication.taggedDoctor != null
                          ? {
                              'id': publication.taggedDoctor!.id,
                              'nombreCompleto': publication.taggedDoctor!.nombreCompleto,
                              'especialidad': publication.taggedDoctor!.especialidad,
                              'fotoPerfil': publication.taggedDoctor!.fotoPerfil,
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

  Widget _buildPublicationHeader(PublicationEntity publication) {
    final author = publication.author;
    final authorName = author?.name ?? 'Usuario';
    final authorPhoto = author?.profilePhoto;

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: GerenaColors.primaryColor,
          backgroundImage: authorPhoto != null && authorPhoto.isNotEmpty
              ? NetworkImage(authorPhoto)
              : null,
          onBackgroundImageError: authorPhoto != null && authorPhoto.isNotEmpty
              ? (exception, stackTrace) {}
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
              if (publication.isReview) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildStarRating(publication.rating?.toDouble() ?? 0),
                    const SizedBox(width: 8),
                    Text(
                      '${publication.rating ?? 0}/5',
                      style: GerenaColors.bodySmall.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPublicationImages(List<ImageEntity> images) {
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
              color: GerenaColors.backgroundColor,
            ),
            child: ClipRRect(
              borderRadius: GerenaColors.smallBorderRadius,
              child: Image.network(
                image.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: GerenaColors.backgroundColor,
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
                    color: GerenaColors.backgroundColor,
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

  Widget _buildPublicationFooter(PublicationEntity publication) {
    final reactions = publication.reactions;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
        Text(
          _formatDate(publication.createdAt),
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