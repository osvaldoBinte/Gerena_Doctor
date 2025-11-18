import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/marketplace/domain/entities/medications/medications_entity.dart';
import 'package:gerena/features/marketplace/presentation/page/shopping/shopping_cart_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/carousel_indicators_widget.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/image_placeholder_widget.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/product_card_widget.dart';
import 'package:gerena/features/marketplace/presentation/page/wishlist/wishlist_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/get_medications_by_id_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/get_medications_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;

  const ProductDetailPage({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailController = Get.find<GetMedicationsByIdController>();
    final relatedController = Get.find<GetMedicationsController>();

    detailController.loadMedicationById(productId);

    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorfondo,
      body: Obx(() {
        if (detailController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: GerenaColors.primaryColor,
            ),
          );
        }

        if (detailController.medication.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: GerenaColors.errorColor,
                ),
                SizedBox(height: 16),
                Text(
                  'No se pudo cargar el producto',
                  style: GoogleFonts.rubik(
                    fontSize: 18,
                    color: GerenaColors.textTertiaryColor,
                  ),
                ),
              ],
            ),
          );
        }

        final medication = detailController.medication.value!;
        
        if (medication.category != null && medication.category!.isNotEmpty) {
          relatedController.fetchMedicationsByCategory(medication.category!);
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: ProductImageSection(medication: medication),
                    ),
                    Expanded(
                      flex: 2,
                      child: ProductInfoSection(medication: medication),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: GerenaColors.primaryColor.withOpacity(0.3),
                      thickness: 1,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.sync_alt, color: GerenaColors.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'PRODUCTOS RELACIONADOS',
                          style: TextStyle(
                            color: GerenaColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              RelatedProductsCarousel(currentProductId: productId.toString()),
            ],
          ),
        );
      }),
    );
  }
}

class ProductImageSection extends StatelessWidget {
  final MedicationsEntity medication;

  const ProductImageSection({
    Key? key,
    required this.medication,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> productImages = medication.images ?? [];

    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ProductCarouselWidget(
          images: productImages.isNotEmpty ? productImages : [],
          indicatorStyle: IndicatorStyle.dots,
          height: 600,
          containerWidth: 470,
          containerHeight: 600,
          showNavigationButtons: productImages.length > 1,
          autoPlay: false,
          backgroundImage: 'assets/tienda-producto.png',
          imagePadding: 60,
          activeIndicatorColor: GerenaColors.secondaryColor,
          inactiveIndicatorColor: Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }
}

class ProductInfoSection extends StatefulWidget {
  final MedicationsEntity medication;

  const ProductInfoSection({
    Key? key,
    required this.medication,
  }) : super(key: key);

  @override
  State<ProductInfoSection> createState() => _ProductInfoSectionState();
}

class _ProductInfoSectionState extends State<ProductInfoSection> {
  bool isDescriptionExpanded = false;
  bool isCharacteristicsExpanded = false;
  ShoppingCartController get cartController => Get.find<ShoppingCartController>();
  WishlistController get wishlistController => Get.find<WishlistController>();

Future<void> _openUrl(String url, ) async {
  try {
    if (url.isEmpty) {
      showErrorSnackbar('URL no disponible $url');
      return;
    }
    
    print('Abriendo documento: $url');
    
    final uri = Uri.parse(url);
    
    final bool launched = await launchUrl(
      uri,
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true,
        enableDomStorage: true,
      ),
    );
    
    if (!launched) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    
  } catch (e) {
    print('Error al abrir documento: $e');
    showErrorSnackbar('No se pudo abrir el documento');
  }
}

  @override
  Widget build(BuildContext context) {
    final medicamentoId = widget.medication.id;
    final precio = widget.medication.price ?? 0.0;

    return Container(
      height: 600,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.medication.name ?? 'Sin nombre',
                    style: GoogleFonts.rubik(
                      color: GerenaColors.textTertiaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Row(
                  children: [
                    Obx(() {
                      final isInWishlist = wishlistController.isInWishlist(medicamentoId);
                      
                      return InkWell(
                        onTap: () {
                          wishlistController.toggleWishlist(
                            medicamentoId: medicamentoId,
                            precio: precio,
                          );
                        },
                        child: Icon(
                          isInWishlist ? Icons.favorite : Icons.favorite_border,
                          color: isInWishlist ? Colors.red : GerenaColors.textTertiaryColor,
                          size: 30,
                        ),
                      );
                    }),
                    SizedBox(width: 8),
                    Obx(() {
                      final isInWishlist = wishlistController.isInWishlist(medicamentoId);
                      
                      return InkWell(
                        onTap: ()async {
                          if (medicamentoId > 0 && precio > 0) {
                          await cartController.addToCart(
                            medicamentoId: medicamentoId,
                            precio: precio,
                            cantidad: 1,
                          );
                        }
                        },
                        child: Image.asset(
                          'assets/icons/guardar.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                          color: isInWishlist ? GerenaColors.primaryColor : null,
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
            Text(
              '\$${precio.toStringAsFixed(2)} MXN',
              style: GoogleFonts.rubik(
                color: GerenaColors.textTertiaryColor,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (widget.medication.previousPrice != null && 
                widget.medication.previousPrice! > precio) ...[
              const SizedBox(height: 4),
              Text(
                '\$${widget.medication.previousPrice!.toStringAsFixed(2)} MXN',
                style: GoogleFonts.rubik(
                  color: Colors.grey,
                  fontSize: 16,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
            const SizedBox(height: 4),
            const SizedBox(height: 16),
            Divider(),
            const SizedBox(height: 8),
            _buildExpandableSection(
              title: 'Descripción:',
              content: widget.medication.description ?? 'No hay descripción disponible',
              isExpanded: isDescriptionExpanded,
            ),
            const SizedBox(height: 16),
            if (widget.medication.features != null && widget.medication.features!.isNotEmpty)
              _buildExpandableSection(
                title: 'Características:',
                content: widget.medication.features!.join('\n'),
                isExpanded: isCharacteristicsExpanded,
              ),
            const SizedBox(height: 16),
            Divider(height: 1, color: GerenaColors.textTertiary),
            const SizedBox(height: 8),
            
           if (widget.medication.termsUrl != null && widget.medication.termsUrl!.isNotEmpty)
  InkWell(
    onTap: () => _openUrl(widget.medication.termsUrl!),
    child: Row(
      children: [
        Icon(Icons.arrow_forward_ios,
            size: 16, color: GerenaColors.textTertiaryColor),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            'Consulta términos y condiciones de la venta',
            style: GoogleFonts.rubik(
              color: GerenaColors.textTertiaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w200,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  ),
const SizedBox(height: 8),

if (widget.medication.technicalSheetUrl != null && widget.medication.technicalSheetUrl!.isNotEmpty)
  InkWell(
    onTap: () => _openUrl(widget.medication.technicalSheetUrl!),
    child: Row(
      children: [
        Icon(Icons.arrow_forward_ios,
            size: 16, color: GerenaColors.textTertiaryColor),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            'Descargar Ficha Técnica',
            style: GoogleFonts.rubik(
              color: GerenaColors.textTertiaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w200,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  ),
            const SizedBox(height: 24),
            
            Column(
              children: [
                Obx(() {
                  if (cartController.isBuyNowModeActive.value) {
                    return GerenaColors.widgetButton(
                      text: 'VOLVER AL CARRITO',
                      onPressed: () async {
                        await cartController.clearBuyNow();
                        cartController.isBuyNowModeActive.value = false;
                        await cartController.loadCartFromPreferences();
                      },
                      backgroundColor: Colors.grey,
                      textColor: GerenaColors.textLightColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      borderRadius: 25,
                      showShadow: false,
                    );
                  } else {
                    return GerenaColors.widgetButton(
                      text: 'AGREGAR AL CARRITO',
                      onPressed: () async {
                        if (medicamentoId > 0 && precio > 0) {
                          await cartController.addToCart(
                            medicamentoId: medicamentoId,
                            precio: precio,
                            cantidad: 1,
                          );
                        }
                      },
                      backgroundColor: GerenaColors.secondaryColor,
                      textColor: GerenaColors.textLightColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      borderRadius: 25,
                      showShadow: false,
                    );
                  }
                }),
                const SizedBox(height: 12),
                GerenaColors.widgetButton(
                  text: 'COMPRAR AHORA',
                  onPressed: () async {
                    if (medicamentoId > 0 && precio > 0) {
                      await cartController.buyNow(
                        medicamentoId: medicamentoId,
                        precio: precio,
                        cantidad: 1,
                      );
                      
                      final navigationController = Get.find<ShopNavigationController>();
                      navigationController.navigateToCart();
                      Get.to(() => GlobalShopInterface());
                    }
                  },
                  backgroundColor: GerenaColors.primaryColor,
                  textColor: GerenaColors.textLightColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  borderRadius: 25,
                  showShadow: false,
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  Widget _buildExpandableSection({
    required String title,
    required String content,
    required bool isExpanded,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.rubik(
                        fontSize: 14,
                        color: GerenaColors.textTertiaryColor,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      content,
                      style: GoogleFonts.rubik(
                        fontSize: 16,
                        color: GerenaColors.textTertiaryColor,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
class RelatedProductsCarousel extends StatelessWidget {
  final String currentProductId;

  const RelatedProductsCarousel({
    Key? key,
    required this.currentProductId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GetMedicationsController>();
    final relatedCarouselController = CarouselSliderController();
    final currentRelatedPage = 0.obs;
    final navigationController = Get.find<ShopNavigationController>();

    return Container(
      height: 250,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        final relatedProducts = controller.medications
            .where((med) => med.id.toString() != currentProductId)
            .take(6)
            .toList();

        if (relatedProducts.isEmpty) {
          return Center(
            child: Text(
              'No hay productos relacionados',
              style: GoogleFonts.rubik(
                color: GerenaColors.textTertiaryColor,
              ),
            ),
          );
        }

        final pages = <List<MedicationsEntity>>[];
        for (var i = 0; i < relatedProducts.length; i += 3) {
          final endIndex =
              (i + 3 < relatedProducts.length) ? i + 3 : relatedProducts.length;
          final pageProducts = relatedProducts.sublist(i, endIndex);
          pages.add(pageProducts);
        }

        return Stack(
          children: [
            CarouselSlider(
              carouselController: relatedCarouselController,
              options: CarouselOptions(
                height: 250,
                viewportFraction: 1.0,
                enableInfiniteScroll: pages.length > 1,
                autoPlay: false,
                onPageChanged: (index, reason) {
                  currentRelatedPage.value = index;
                },
              ),
              items: pages.map((pageItems) {
                return Builder(
                  builder: (BuildContext context) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: pageItems.map((medication) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: ProductCardWidget(
                              product: _medicationToMap(medication),
                               onTap: () => navigationController
                                  .navigateToProductDetail(medication.id),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              }).toList(),
            ),
            if (pages.length > 1) ...[
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: IconButton(
                  icon: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: GerenaColors.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: GerenaColors.surfaceColor,
                      size: 16,
                    ),
                  ),
                  onPressed: () => relatedCarouselController.previousPage(),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: IconButton(
                  icon: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: GerenaColors.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: GerenaColors.surfaceColor,
                      size: 16,
                    ),
                  ),
                  onPressed: () => relatedCarouselController.nextPage(),
                ),
              ),
            ],
          ],
        );
      }),
    );
  }

  Map<String, String> _medicationToMap(MedicationsEntity medication) {
    final bool hasDiscount = medication.onSale == true && medication.previousPrice != null;
    
    return {
      'id': medication.id.toString(),
      'name': medication.name ?? 'Sin nombre',
      'image': (medication.images != null && medication.images!.isNotEmpty) 
          ? medication.images!.first 
          : '',
      'price': 'MXN \$${medication.price?.toStringAsFixed(2) ?? '0.00'}',
      'hasDiscount': hasDiscount.toString(),
      'oldPrice': hasDiscount 
          ? 'MXN \$${medication.previousPrice?.toStringAsFixed(2) ?? '0.00'}' 
          : '',
    };
  }
}

class RelatedProductCard extends StatelessWidget {
  final MedicationsEntity medication;
  final VoidCallback onTap;

  const RelatedProductCard({
    Key? key,
    required this.medication,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.find<WishlistController>();
    final hasDiscount = medication.previousPrice != null && 
                        medication.previousPrice! > (medication.price ?? 0);
    final isAvailable = (medication.stock ?? 0) > 0;

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: GerenaColors.backgroundColorfondo,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: medication.images != null && 
                           medication.images!.isNotEmpty
                        ? Image.network(
                            medication.images!.first,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Obx(() {
                    final isInWishlist = wishlistController.isInWishlist(medication.id);
                    
                    return InkWell(
                      onTap: () {
                        wishlistController.toggleWishlist(
                          medicamentoId: medication.id,
                          precio: medication.price ?? 0.0,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          isInWishlist ? Icons.favorite : Icons.favorite_border,
                          color: isInWishlist ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                      ),
                    );
                  }),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: GerenaColors.errorColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'OFERTA',
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        medication.name ?? 'Sin nombre',
                        style: GoogleFonts.rubik(
                          color: GerenaColors.textTertiaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasDiscount) ...[
                          Text(
                            '\$${medication.previousPrice!.toStringAsFixed(2)}',
                            style: GoogleFonts.rubik(
                              color: Colors.grey,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                        Text(
                          '\$${(medication.price ?? 0.0).toStringAsFixed(2)} MXN',
                          style: GoogleFonts.rubik(
                            color: GerenaColors.textTertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isAvailable 
                            ? GerenaColors.successColor.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isAvailable ? 'DISPONIBLE' : 'AGOTADO',
                        style: GoogleFonts.rubik(
                          color: isAvailable 
                              ? GerenaColors.successColor
                              : Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}