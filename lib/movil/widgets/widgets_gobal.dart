
import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/doctors/presentation/page/editperfildoctor/movil/perfil_controller.dart';
import 'package:gerena/features/publications/presentation/widget/videoItem.dart';
import 'package:get/get.dart';


Widget buildImageGallery(List<String> urls) {
  if (urls.isEmpty) return const SizedBox.shrink();

  if (urls.length == 1) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: _buildMediaItem(urls[0]),
      ),
    );
  }

  return SizedBox(
    height: 200,
    child: PageView.builder(
      itemCount: urls.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildMediaItem(urls[index]),
          ),
        );
      },
    ),
  );
}

Widget _buildMediaItem(String url) {
  if (_isVideo(url)) {
    return VideoItem(url: url);
  }
  
  return Image.network(
    url,
    fit: BoxFit.cover,
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Container(
        color: GerenaColors.backgroundColorFondo,
        child: Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
            valueColor: AlwaysStoppedAnimation<Color>(
              GerenaColors.primaryColor,
            ),
          ),
        ),
      );
    },
    errorBuilder: (context, error, stackTrace) {
      return Container(
        color: GerenaColors.backgroundColorFondo,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image_outlined,
                size: 48,
                color: GerenaColors.textSecondaryColor,
              ),
              SizedBox(height: 8),
              Text(
                'Error al cargar imagen',
                style: TextStyle(color: GerenaColors.textSecondaryColor),
              ),
            ],
          ),
        ),
      );
    },
  );
}

bool _isVideo(String url) {
  final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm', '.m4v'];
  final lowerUrl = url.toLowerCase();
  return videoExtensions.any((ext) => lowerUrl.endsWith(ext));
}