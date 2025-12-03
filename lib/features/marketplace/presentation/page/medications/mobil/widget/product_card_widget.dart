import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/domain/entities/medications/medications_entity.dart';
import 'package:gerena/features/marketplace/presentation/page/shopping/shopping_cart_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/image_placeholder_widget.dart';
import 'package:gerena/features/marketplace/presentation/page/wishlist/wishlist_controller.dart';
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
    final wishlistController = Get.find<WishlistController>();
    final cartController = Get.find<ShoppingCartController>(); // ⭐ Obtener controller

    return GestureDetector(
      onTap: onTap ??
          () {
           // ✅ CORRECTO - Pasando un Map con los datos necesarios
Get.toNamed(
  RoutesNames.productDetail,
  arguments: {
    'id': medication.id,
    'categoryName': medication.category ?? '', // O el nombre de categoría apropiado
    // Puedes pasar el objeto completo si lo necesitas:
    // 'medication': medication,
  },
);
          },
      child: Container(
        padding: EdgeInsets.all(cardPadding!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImageSection(wishlistController, cartController), // ⭐ Pasar controller
            const SizedBox(height: 8),
            _buildProductInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(
    WishlistController wishlistController,
    ShoppingCartController cartController, // ⭐ Recibir controller
  ) {
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

          // ⭐ Icono de agregar al carrito (top right)
          if (showSaveIcon)
            Positioned(
              top: 5,
              right: 5,
              child: Obx(() {
                final isInCart = cartController.isInCart(medication.id);
                final quantity = cartController.getProductQuantity(medication.id);
                
                return InkWell(
                  onTap: () async {
                    if ((medication.stock ?? 0) <= 0) {
                      Get.snackbar(
                        'Producto agotado',
                        'Este producto no está disponible',
                        backgroundColor: Colors.red.withOpacity(0.8),
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP,
                        duration: Duration(seconds: 2),
                      );
                      return;
                    }
                    
                    await cartController.addToCart(
                      medicamentoId: medication.id,
                      precio: medication.price ?? 0.0,
                      cantidad: 1,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isInCart 
                          ? GerenaColors.primaryColor.withOpacity(0.9)
                          : Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/icons/guardar.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          color: isInCart ? Colors.white : null,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              isInCart ? Icons.shopping_cart : Icons.add_shopping_cart,
                              size: 20,
                              color: isInCart ? Colors.white : GerenaColors.primaryColor,
                            );
                          },
                        ),
                        // ⭐ Badge con cantidad si está en el carrito
                        if (isInCart && quantity > 0)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Center(
                                child: Text(
                                  quantity.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),

          // Botón de favorito (bottom right)
          if (showFavoriteButton)
            Positioned(
              bottom: 5,
              right: 5,
              child: Obx(() {
                final isInWishlist = wishlistController.isInWishlist(medication.id);
                
                return IconButton(
                  icon: Icon(
                    isInWishlist ? Icons.favorite : Icons.favorite_border,
                    color: isInWishlist ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    wishlistController.toggleWishlist(
                      medicamentoId: medication.id,
                      precio: medication.price ?? 0.0,
                    );
                    
                    if (onFavoritePressed != null) {
                      onFavoritePressed!();
                    }
                  },
                  iconSize: 18,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                );
              }),
            ),

          // Badge de descuento (top left)
          if (_hasDiscount())
            Positioned(
              top: 5,
              left: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: GerenaColors.errorColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'OFERTA',
                  style: GoogleFonts.rubik(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Badge de stock agotado
          if ((medication.stock ?? 0) <= 0)
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
  final imageUrl = medication.images?.isNotEmpty == true 
      ? medication.images!.first 
      : null;

  return NetworkImageWidget(
    imageUrl: imageUrl,
    height: 100,
      showPlaceholderDecoration: false,

  );
}

  Widget _buildProductInfo() {
    final bool hasDiscount = _hasDiscount();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          medication.name ?? 'Sin nombre',
          style: GoogleFonts.rubik(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: GerenaColors.textTertiaryColor,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$${(medication.price ?? 0.0).toStringAsFixed(2)} MXN',
              style: GoogleFonts.rubik(
                fontSize: 14,
                color: GerenaColors.textTertiaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (hasDiscount) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    '\$${medication.previousPrice!.toStringAsFixed(2)} MXN',
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
                  _buildDiscountBadge(),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }

  bool _hasDiscount() {
    return medication.previousPrice != null &&
        medication.previousPrice! > (medication.price ?? 0);
  }

  Widget _buildDiscountBadge() {
    if (!_hasDiscount()) {
      return const SizedBox.shrink();
    }

    final discount = ((medication.previousPrice! - (medication.price ?? 0)) /
            medication.previousPrice! *
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