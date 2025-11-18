import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/review/domain/entities/my_review_entity.dart';
import 'package:gerena/features/review/presentation/page/review_controller.dart';
import 'package:get/get.dart';

class ReviewsWidget extends StatelessWidget {
  const ReviewsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ReviewController>(
      builder: (controller) {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: GerenaColors.primaryColor,
            ),
          );
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

        final reviewsList = controller.reviews
            .map((entity) => ReviewData.fromEntity(entity))
            .toList();

        return _buildReviewsList(reviewsList);
      },
    );
  }

  Widget _buildReviewsList(List<ReviewData> reviewsList) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: reviewsList
            .map((review) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildReviewCard(review),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildReviewCard(ReviewData review) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: GerenaColors.smallBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReviewHeader(review),
          const SizedBox(height: 8),
          Text(
            review.title,
            style: GerenaColors.headingSmall.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            review.content,
            style: GerenaColors.bodySmall,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildReviewImages(review.images),
          ],
          const SizedBox(height: 8),
          _buildReviewFooter(review),
        ],
      ),
    );
  }

  Widget _buildReviewHeader(ReviewData review) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: GerenaColors.primaryColor,
          child: Text(
            review.clientInitial,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              _buildStarRating(review.rating.toDouble()),
            /*  const Spacer(),
              Text(
                'Cita verificada',
                style: GerenaColors.bodyMedium.copyWith(
                  color: GerenaColors.accentColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Image.asset(
                  'assets/icons/push-pin.png',
                  width: 16,
                  height: 16,
                ),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              */
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewImages(List<String> images) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: images.map((imagePath) {
          return Container(
            width: 120,
            height: 100,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: GerenaColors.smallBorderRadius,
              color: GerenaColors.backgroundColorfondo,
            ),
            child: ClipRRect(
              borderRadius: GerenaColors.smallBorderRadius,
              child: Image.asset(
                imagePath,
                width: 120,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: GerenaColors.backgroundColorfondo,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image,
                          color: Colors.grey[400],
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Imagen no encontrada',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 8,
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
        }).toList(),
      ),
    );
  }

  Widget _buildReviewFooter(ReviewData review) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          review.date,
          style: GerenaColors.bodySmall,
        ),
        const SizedBox(width: 8),
        Text(
          '${review.reactions} Reacciones',
          style: GerenaColors.bodySmall,
        ),
      ],
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: GerenaColors.accentColor, size: 16);
        } else if (index < rating) {
          return const Icon(Icons.star_half, color: GerenaColors.accentColor, size: 16);
        } else {
          return const Icon(Icons.star_border, color: GerenaColors.accentColor, size: 16);
        }
      }),
    );
  }
}

class ReviewData {
  final String title;
  final String content;
  final int rating;
  final String date;
  final List<String> images;
  final int reactions;
  final String clientName;

  ReviewData({
    required this.title,
    required this.content,
    required this.rating,
    required this.date,
    this.images = const [],
    this.reactions = 0,
    this.clientName = 'Usuario',
  });

  // Obtener la inicial del cliente
  String get clientInitial {
    if (clientName.isEmpty) return 'U';
    return clientName[0].toUpperCase();
  }

  // Converter desde Entity
  factory ReviewData.fromEntity(MyReviewEntity entity) {
    return ReviewData(
      title: entity.doctorName ?? 'Sin título',
      content: entity.comment ?? 'Sin comentario',
      rating: entity.rating ?? 0,
      date: _formatDate(entity.creationDate),
      clientName: entity.clientName ?? 'Usuario',
      reactions: 0,
      images: [],
    );
  }

  // Formatear fecha
  static String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'Sin fecha';
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}';
    } catch (e) {
      return date;
    }
  }
}