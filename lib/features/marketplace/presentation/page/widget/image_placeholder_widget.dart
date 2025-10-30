import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:google_fonts/google_fonts.dart';

class ImagePlaceholderWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final double? height;
  final double? width;
  final double? iconSize;
  final double? fontSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  const ImagePlaceholderWidget({
    Key? key,
    required this.icon,
    required this.text,
    this.height,
    this.width,
    this.iconSize = 50,
    this.fontSize = 10,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
     
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: iconColor ?? GerenaColors.textTertiaryColor.withOpacity(0.4),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: GoogleFonts.rubik(
              fontSize: fontSize,
              color: textColor ?? GerenaColors.textTertiaryColor.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Variante predefinida para "Sin imagen"
class NoImagePlaceholder extends StatelessWidget {
  final double? height;
  final double? width;

  const NoImagePlaceholder({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImagePlaceholderWidget(
      icon: Icons.image_outlined,
      text: 'Sin imagen',
      height: height ?? 120,
      width: width,
    );
  }
}

// Variante predefinida para "Imagen no disponible"
class BrokenImagePlaceholder extends StatelessWidget {
  final double? height;
  final double? width;

  const BrokenImagePlaceholder({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImagePlaceholderWidget(
      icon: Icons.broken_image_outlined,
      text: 'Imagen no disponible',
      height: height ?? 120,
      width: width,
    );
  }
}

// Variante predefinida para "Cargando..."
class LoadingImagePlaceholder extends StatelessWidget {
  final double? height;
  final double? width;

  const LoadingImagePlaceholder({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 120,
      width: width,
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColorfondo,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: GerenaColors.primaryColor,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
