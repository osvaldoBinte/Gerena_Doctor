import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/image_placeholder_widget.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/product_card_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/get_medications_controller.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, String> product;

  const ProductDetailPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GetMedicationsController>();

    final carouselController = CarouselSliderController();
    final currentImageIndex = 0.obs;

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
                    child: ProductImageSection(
                      product: product,
                      carouselController: carouselController,
                      currentImageIndex: currentImageIndex,
                    ),
                  ),
                  SizedBox(width: 40),
                  Expanded(
                    flex: 2,
                    child: ProductInfoSection(
                      product: product,
                    ),
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
  final CarouselSliderController carouselController;
  final RxInt currentImageIndex;

  const ProductImageSection({
    Key? key,
    required this.product,
    required this.carouselController,
    required this.currentImageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productImages = [
      product['image'] ?? '',
    ];

    return Column(
      children: [
        Container(
          height: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ProductImageCarousel(
              carouselController: carouselController,
              currentImageIndex: currentImageIndex,
              productImages: productImages,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: productImages.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => carouselController.animateToPage(entry.key),
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentImageIndex.value == entry.key
                          ? GerenaColors.secondaryColor
                          : Colors.grey.withOpacity(0.5),
                    ),
                  ),
                );
              }).toList(),
            )),
      ],
    );
  }
}

class ProductImageCarousel extends StatelessWidget {
  final CarouselSliderController carouselController;
  final RxInt currentImageIndex;
  final List<String> productImages;

  const ProductImageCarousel({
    Key? key,
    required this.carouselController,
    required this.currentImageIndex,
    required this.productImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          carouselController: carouselController,
          options: CarouselOptions(
            height: 600,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            enableInfiniteScroll: productImages.length > 1,
            onPageChanged: (index, reason) {
              currentImageIndex.value = index;
            },
          ),
          items: productImages.map((imagePath) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/tienda-producto.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: (imagePath.isEmpty)
                        ? NoImagePlaceholder(height: 300)
                        : imagePath.startsWith('http')
                            ? Image.network(
                                imagePath,
                                height: 300,
                                fit: BoxFit.contain,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return LoadingImagePlaceholder(height: 300);
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return BrokenImagePlaceholder(height: 300);
                                },
                              )
                            : Image.asset(
                                imagePath,
                                height: 300,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return NoImagePlaceholder(height: 300);
                                },
                              ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        if (productImages.length > 1) ...[
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
                  size: 18,
                ),
              ),
              onPressed: () => carouselController.previousPage(),
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
                  size: 18,
                ),
              ),
              onPressed: () => carouselController.nextPage(),
            ),
          ),
        ],
      ],
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

  @override
  Widget build(BuildContext context) {
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
                    Image.asset(
                      'assets/icons/WISHLIST.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 8),
                    Image.asset(
                      'assets/icons/guardar.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
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
            Text(
              '4 X \$8,400.00 MXN',
              style: GoogleFonts.rubik(
                color: GerenaColors.textpreviousprice,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
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
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.snackbar(
                    'Producto añadido',
                    '${widget.product['name']} se añadió al carrito',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                icon: Icon(Icons.shopping_cart),
                label: Text(
                  'AÑADIR AL CARRITO',
                  style: GoogleFonts.rubik(),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: GerenaColors.secondaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
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
