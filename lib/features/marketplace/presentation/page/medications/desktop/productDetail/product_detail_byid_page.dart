import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/presentation/page/cartPage/shopping_cart_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/carousel_indicators_widget.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/image_placeholder_widget.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/product_card_widget.dart';
import 'package:gerena/features/marketplace/presentation/page/wishlist/wishlist_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/get_medications_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, String> product;

  const ProductDetailPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {  
    final controller = Get.find<GetMedicationsController>();

    final productCategory = product['category'] ?? '';
    if (productCategory.isNotEmpty) {
      controller.fetchMedicationsByCategory(productCategory);
    }

    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorfondo,
      body: SingleChildScrollView(
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
                    child: ProductImageSection(product: product),
                  ),
                  Expanded(
                    flex: 2,
                    child: ProductInfoSection(product: product),
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
            RelatedProductsCarousel(currentProductId: product['id'] ?? ''),
          ],
        ),
      ),
    );
  }
}

class ProductImageSection extends StatelessWidget {
  final Map<String, String> product;

  const ProductImageSection({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> productImages = [
      if (product['image'] != null && product['image']!.isNotEmpty) product['image']!,
      'assets/images/celosome_1.png',
      'assets/images/celosome_2.png',
      'assets/images/celosome_3.png',
      'assets/images/celosome_4.png',
    ];

    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ProductCarouselWidget(
          images: productImages,
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
  final Map<String, String> product;

  const ProductInfoSection({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductInfoSection> createState() => _ProductInfoSectionState();
}

class _ProductInfoSectionState extends State<ProductInfoSection> {
  bool isDescriptionExpanded = false;
  bool isCharacteristicsExpanded = false;
  ShoppingCartController get cartController => Get.find<ShoppingCartController>();
  WishlistController get wishlistController => Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    // Extraer el ID y precio del producto
    final medicamentoId = int.tryParse(widget.product['id'] ?? '0') ?? 0;
    final precio = _extractPrice(widget.product['price'] ?? '0.00');

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
                    widget.product['name'] ?? '',
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
                        onTap: () {
                          wishlistController.toggleWishlist(
                            medicamentoId: medicamentoId,
                            precio: precio,
                          );
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
              '\$${widget.product['price'] ?? ''}',
              style: GoogleFonts.rubik(
                color: GerenaColors.textTertiaryColor,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            const SizedBox(height: 16),
            Divider(),
            const SizedBox(height: 8),
            _buildExpandableSection(
              title: 'Descripción:',
              content: widget.product['description'] ??
                  'No hay descripción disponible',
              isExpanded: isDescriptionExpanded,
            ),
            const SizedBox(height: 16),
            _buildExpandableSection(
              title: 'Características:',
              content:
                  'Vial de 100 Unidades\nMayor potencia, bloqueo muscular más eficaz.\nDuración hasta por más de 5 meses',
              isExpanded: isCharacteristicsExpanded,
            ),
            const SizedBox(height: 16),
            Divider(height: 1, color: GerenaColors.textTertiary),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {},
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
            InkWell(
              onTap: () {},
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
                GerenaColors.widgetButton(
                  text: 'AGREGAR AL CARRITO',
                  onPressed: () async {
                    final medicamentoId = int.tryParse(widget.product['id'] ?? '0');
                    final precio = double.tryParse(
                      widget.product['price']?.replaceAll(' MXN', '').replaceAll(',', '') ?? '0'
                    );
                    
                    if (medicamentoId != null && precio != null && medicamentoId > 0) {
                      await cartController.addToCart(
                        medicamentoId: medicamentoId,
                        precio: precio,
                        cantidad: 1,
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        'No se pudo agregar el producto al carrito',
                        snackPosition: SnackPosition.BOTTOM,
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
                ),
                const SizedBox(height: 12),
                GerenaColors.widgetButton(
                  text: 'COMPRAR AHORA',
                  onPressed: () {},
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

  // Método auxiliar para extraer el precio numérico del string
  double _extractPrice(String priceString) {
    try {
      final cleanPrice = priceString
          .replaceAll('MXN', '')
          .replaceAll('\$', '')
          .replaceAll(',', '')
          .trim();
      return double.tryParse(cleanPrice) ?? 0.0;
    } catch (e) {
      print('Error al extraer precio: $e');
      return 0.0;
    }
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
    final navigationController = Get.find<ShopNavigationController>();
    final relatedCarouselController = CarouselSliderController();
    final currentRelatedPage = 0.obs;

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

        final pages = <List<Map<String, String>>>[];
        for (var i = 0; i < relatedProducts.length; i += 3) {
          final endIndex =
              (i + 3 < relatedProducts.length) ? i + 3 : relatedProducts.length;
          final pageProducts = relatedProducts.sublist(i, endIndex).map((med) {
            final productData = {
              'name': med.name,
              'price': '${med.price.toStringAsFixed(2)} MXN',
              'label': 'DISPONIBLE',
              'id': med.id.toString(),
              'image': med.imagen ?? '',
              'description': med.description,
              'category': med.categoria ?? '',
              'stock': med.stock.toString(),
            };

            if (med.previousprice != null && med.previousprice! > med.price) {
              productData['hasDiscount'] = 'true';
              productData['oldPrice'] =
                  '${med.previousprice!.toStringAsFixed(2)} MXN';
            }

            return productData;
          }).toList();
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
                      children: pageItems.map((product) {
                        return Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: ProductCardWidget(
                              product: product,
                              onTap: () => navigationController
                                  .navigateToProductDetail(product),
                              onFavoritePressed: () {
                                print(
                                    'Añadido a favoritos: ${product['name']}');
                              },
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
}