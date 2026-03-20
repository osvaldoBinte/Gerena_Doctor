import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/doctors/presentation/page/doctorProfilePage/review/widget/reviews_loading.dart';
import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/presentation/page/myposts/my_post_controller.dart';
import 'package:gerena/features/publications/presentation/widget/review_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyPublicationsWidget extends StatelessWidget {
  const MyPublicationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<MyPostController>(
      builder: (controller) {
        if (controller.isLoading.value) {
          return const ReviewsLoading();
        }

        if (controller.myPublications.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.article_outlined, color: Colors.grey[400], size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'No hay publicaciones disponibles',
                    style: GerenaColors.bodyMedium.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return _buildList(controller.myPublications, context, controller);
      },
    );
  }

  Widget _buildList(List<PublicationEntity> publications, BuildContext context, MyPostController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: publications.map((pub) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildCard(pub, context, controller),
        )).toList(),
      ),
    );
  }

  Widget _buildCard(PublicationEntity pub, BuildContext context, MyPostController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GerenaColors.colorSubsCardBackground,
        borderRadius: GerenaColors.smallBorderRadius,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge tipo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: GerenaColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.article, size: 14, color: GerenaColors.primaryColor),
                const SizedBox(width: 4),
                Text('Publicación',
                  style: GoogleFonts.rubik(
                    fontSize: 12,
                    color: GerenaColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  )),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Header autor
          Row(
  children: [
    CircleAvatar(
      radius: 20,
      backgroundColor: GerenaColors.primaryColor,
      child: Text(
        pub.author?.name?.isNotEmpty == true
            ? pub.author!.name![0].toUpperCase()
            : 'Y',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: Text(
        pub.author?.name ?? 'Yo',
        style: GoogleFonts.rubik(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ],
),
          const SizedBox(height: 12),

          // Descripción
          Text(pub.description,
            style: GerenaColors.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          // Imágenes
          if (pub.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pub.images.length,
                itemBuilder: (_, i) => Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: GerenaColors.smallBorderRadius,
                    color: GerenaColors.backgroundColorfondo,
                  ),
                  child: ClipRRect(
                    borderRadius: GerenaColors.smallBorderRadius,
                    child: Image.network(pub.images[i].imageUrl, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.broken_image, color: Colors.grey[400], size: 32),
                    ),
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),

         // Footer reacciones + fecha
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: [
        Icon(Icons.favorite, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text('${pub.reactions.total} reacciones',
          style: GerenaColors.bodySmall.copyWith(color: Colors.grey[600])),
      ],
    ),
    Text(controller.formatDate(pub.createdAt),
      style: GerenaColors.bodySmall.copyWith(color: Colors.grey[600])),
  ],
),

const SizedBox(height: 8),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    // Botón eliminar
    TextButton(
      onPressed: () => _confirmDelete(context, pub, controller),
      style: TextButton.styleFrom(
        foregroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.delete_outline, size: 14, color: Colors.red),
          const SizedBox(width: 4),
          Text(
            'Eliminar',
            style: GoogleFonts.rubik(
              color: Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),

    // Botón ver publicación
    TextButton(
      onPressed: () => _showPublicationModal(context, pub),
      style: TextButton.styleFrom(
        foregroundColor: GerenaColors.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Ver publicación',
            style: GoogleFonts.rubik(
              color: GerenaColors.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.arrow_forward_ios, size: 14, color: GerenaColors.primaryColor),
        ],
      ),
    ),
  ],
),
        ],
      ),
    );
  }void _confirmDelete(BuildContext context, PublicationEntity pub, MyPostController controller) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        '¿Eliminar publicación?',
        style: GoogleFonts.rubik(fontWeight: FontWeight.w600),
      ),
      content: Text(
        'Esta acción no se puede deshacer.',
        style: GoogleFonts.rubik(color: Colors.grey[600]),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancelar',
            style: GoogleFonts.rubik(color: Colors.grey[600]),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            controller.deletePost(pub.id);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Eliminar',
            style: GoogleFonts.rubik(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}void _showPublicationModal(BuildContext context, PublicationEntity publication) {
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
                    bottom: BorderSide(color: Colors.grey[300]!, width: 1),
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
                      icon: Icon(Icons.close, color: GerenaColors.textSecondary),
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

String _formatDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);
  if (difference.inDays == 0) {
    if (difference.inHours == 0) {
      if (difference.inMinutes == 0) return 'Hace un momento';
      return 'Hace ${difference.inMinutes}m';
    }
    return 'Hace ${difference.inHours}h';
  } else if (difference.inDays < 7) {
    return 'Hace ${difference.inDays}d';
  } else if (difference.inDays < 30) {
    return 'Hace ${(difference.inDays / 7).floor()}sem';
  } else if (difference.inDays < 365) {
    return 'Hace ${(difference.inDays / 30).floor()}m';
  } else {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
}