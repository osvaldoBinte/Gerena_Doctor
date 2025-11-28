import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gerena/common/theme/App_Theme.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final bool showPlaceholderDecoration;
  final Color? placeholderBackgroundColor;
  final double? placeholderBorderRadius;

  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.showPlaceholderDecoration = true,
    this.placeholderBackgroundColor,
    this.placeholderBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay URL o está vacía, mostrar placeholder
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder(Icons.broken_image_outlined, 'Sin imagen');
    }

    return Image.network(
      imageUrl!,
      height: height,
      width: width,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        
        return _buildLoading();
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildPlaceholder(Icons.broken_image_outlined, 'Sin imagen');
      },
    );
  }

  Widget _buildLoading() {
    return Container(
      height: height ?? 120,
      width: width,
      decoration: showPlaceholderDecoration
          ? BoxDecoration(
              color: placeholderBackgroundColor ?? GerenaColors.backgroundColorfondo,
              borderRadius: BorderRadius.circular(placeholderBorderRadius ?? 8),
            )
          : null,
      child: Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            color: GerenaColors.primaryColor,
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(IconData icon, String text) {
    return Container(
      height: height ?? 120,
      width: width,
      decoration: showPlaceholderDecoration
          ? BoxDecoration(
              color: placeholderBackgroundColor ?? GerenaColors.backgroundColorfondo,
              borderRadius: BorderRadius.circular(placeholderBorderRadius ?? 8),
            )
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 50,
            color: GerenaColors.textTertiaryColor.withOpacity(0.4),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              color: GerenaColors.textTertiaryColor.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}