import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/image_placeholder_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCardWidget extends StatelessWidget {
  final Map<String, String> product;
  final VoidCallback onTap;
  final VoidCallback? onFavoritePressed;
  final bool showFavoriteButton;

  const ProductCardWidget({
    Key? key,
    required this.product,
    required this.onTap,
    this.onFavoritePressed,
    this.showFavoriteButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = product['hasDiscount'] == 'true';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: GerenaColors.cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildImageSection(hasDiscount),
            ),
            _buildProductInfo(hasDiscount),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(bool hasDiscount) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            image: DecorationImage(
              image: AssetImage('assets/tienda-producto.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Hero(
            tag: 'product-${product['id'] ?? product['name']}',
            child: _buildProductImage(),
          ),
        ),
        if (showFavoriteButton)
          Positioned(
            bottom: 5,
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
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProductImage() {
    if (product['image']?.isNotEmpty ?? false) {
      return Image.network(
        product['image']!,
        height: 120,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Container(
            height: 120,
            child: Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  color: GerenaColors.primaryColor,
                  strokeWidth: 3,
                ),
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

  Widget _buildProductInfo(bool hasDiscount) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  product['name'] ?? 'Sin nombre',
                  style: GoogleFonts.rubik(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.primaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showFavoriteButton)
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.grey),
                  onPressed: onFavoritePressed ?? () {},
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          if (hasDiscount) ...[
            Text(
              product['price'] ?? '\$0.00',
              style: GoogleFonts.rubik(
                fontSize: 12,
                color: GerenaColors.textDarkColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              product['oldPrice'] ?? '',
              style: GoogleFonts.rubik(
                fontSize: 10,
                color: GerenaColors.descuento,
                decoration: TextDecoration.lineThrough,
                decorationColor: GerenaColors.descuento,
              ),
            ),
          ] else ...[
            Text(
              product['price'] ?? '\$0.00',
              style: GoogleFonts.rubik(
                fontSize: 12,
                color: GerenaColors.textDarkColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: GerenaColors.buttoninformation,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  ' VER INFORMACIÓN ',
                  style: GoogleFonts.rubik(
                    color: GerenaColors.textLightColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}