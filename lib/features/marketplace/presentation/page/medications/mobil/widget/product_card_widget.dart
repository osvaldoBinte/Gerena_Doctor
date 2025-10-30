import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/domain/entities/medications/medications_entity.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/image_placeholder_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCardWidget extends StatelessWidget {
  final MedicationsEntity medication;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final bool showFavoriteButton;
  final bool showSaveIcon;
  final double? imageHeight;
  final double? cardPadding;

  const ProductCardWidget({
    Key? key,
    required this.medication,
    this.onTap,
    this.onFavoritePressed,
    this.showFavoriteButton = true,
    this.showSaveIcon = true,
    this.imageHeight = 140,
    this.cardPadding = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Get.toNamed(
              RoutesNames.productDetail,
              arguments: {'id': medication.id},
            );
          },
      child: Container(
        padding: EdgeInsets.all(cardPadding!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImageSection(),
            const SizedBox(height: 8),
            _buildProductInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: imageHeight,
      child: Stack(
        children: [
          // Imagen de fondo decorativa
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage('assets/tienda-producto.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Imagen del producto
          Center(
            child: Hero(
              tag: 'product-${medication.id}',
              child: _buildProductImage(),
            ),
          ),

          // Icono de guardar (top right)
          if (showSaveIcon)
            Positioned(
              top: 5,
              right: 5,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/icons/guardar.png',
                  width: 16,
                  height: 16,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.bookmark_border,
                      size: 16,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),

          // Botón de favorito (bottom right)
          if (showFavoriteButton)
            Positioned(
              bottom: 5,
              right: 5,
              child: IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.grey),
                onPressed: onFavoritePressed ??
                    () {
                      Get.snackbar(
                        'Favoritos',
                        '${medication.name} agregado a favoritos',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                      );
                    },
                iconSize: 18,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),

          // Badge de stock agotado
          if (medication.stock <= 0)
            Positioned(
              top: 5,
              left: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Agotado',
                  style: GoogleFonts.rubik(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    if (medication.imagen != null && medication.imagen!.isNotEmpty) {
      return Image.network(
        medication.imagen!,
        height: 100,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: GerenaColors.primaryColor,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return ImagePlaceholderWidget(
            icon: Icons.broken_image_outlined,
            text: 'Imagen no disponible',
          );
        },
      );
    }

    return ImagePlaceholderWidget(
      icon: Icons.image_outlined,
      text: 'Sin imagen',
    );
  }

  Widget _buildProductInfo() {
    final bool hasDiscount = medication.previousprice != null &&
        medication.previousprice! > medication.price;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nombre del producto
        Text(
          medication.name,
          style: GoogleFonts.rubik(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: GerenaColors.textTertiaryColor,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 4),

        // Precios
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Precio actual
            Text(
              '\$${medication.price.toStringAsFixed(2)} MXN',
              style: GoogleFonts.rubik(
                fontSize: 14,
                color: GerenaColors.textTertiaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),

            // Precio anterior
            if (hasDiscount) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    '\$${medication.previousprice!.toStringAsFixed(2)} MXN',
                    style: GoogleFonts.rubik(
                      fontSize: 14,
                      color: GerenaColors.textpreviousprice,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: GerenaColors.textpreviousprice,
                      decorationThickness: 2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                //  _buildDiscountBadge(),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildDiscountBadge() {
    if (medication.previousprice == null ||
        medication.previousprice! <= medication.price) {
      return const SizedBox.shrink();
    }

    final discount = ((medication.previousprice! - medication.price) /
            medication.previousprice! *
            100)
        .round();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: GerenaColors.errorColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '-$discount%',
        style: GoogleFonts.rubik(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}