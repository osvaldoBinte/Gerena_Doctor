import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/domain/entities/medications/medications_entity.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/mobil/product_datail_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/get_medications_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/mobil/widget/product_card_widget.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/carousel_indicators_widget.dart';
import 'package:gerena/features/marketplace/presentation/page/shopping/shopping_cart_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/wishlist/wishlist_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/floating_cart_button.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorFondo,
      appBar: AppBar(
        backgroundColor: GerenaColors.backgroundColorFondo,
        elevation: 4,
        shadowColor: GerenaColors.shadowColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              'GERENA',
              style: GoogleFonts.rubik(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            Container(
              width: 140,
              child: GerenaColors.createSearchContainer(
                height: 26,
                heightcontainer: 15,
                iconSize: 18,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: GerenaColors.primaryColor,
            ),
          );
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 60, color: GerenaColors.errorColor),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    controller.errorMessage.value,
                    style: GoogleFonts.rubik(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshData(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GerenaColors.primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: Text(
                    'Reintentar',
                    style: GoogleFonts.rubik(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        final medication = controller.medication.value;
        if (medication == null) {
          return Center(
            child: Text(
              'Producto no encontrado',
              style: GoogleFonts.rubik(fontSize: 16),
            ),
          );
        }

        return _ProductDetailContent(medication: medication);
      }),
    );
  }
}

class _ProductDetailContent extends StatefulWidget {
  final MedicationsEntity medication;

  const _ProductDetailContent({required this.medication});

  @override
  State<_ProductDetailContent> createState() => _ProductDetailContentState();
}

class _ProductDetailContentState extends State<_ProductDetailContent> {
  ShoppingCartController get cartController =>
      Get.find<ShoppingCartController>();
  WishlistController get wishlistController => Get.find<WishlistController>();

  List<String> get _productImages {
    if (widget.medication.images != null &&
        widget.medication.images!.isNotEmpty) {
      return widget.medication.images!;
    }
    return [
      'assets/images/celosome_1.png',
      'assets/images/celosome_2.png',
      'assets/images/celosome_3.png',
      'assets/images/celosome_4.png',
    ];
  }

  // Método para abrir PDFs en WebView dentro de la app
  Future<void> _openPdfUrl(String url, String title) async {
    try {
      if (url.isEmpty) {
        Get.snackbar(
          'Error',
          'URL no disponible',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      print('Intentando abrir documento: $url');

      final uri = Uri.parse(url);

      // Intenta abrir en navegador in-app con barra de navegación
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      );

      if (!launched) {
        print('Intento 1 fallido (inAppBrowserView), probando con inAppWebView');

        // Segundo intento: WebView embebido
        launched = await launchUrl(
          uri,
          mode: LaunchMode.inAppWebView,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );

        if (!launched) {
          print('Intento 2 fallido, probando con platformDefault');

          // Tercer intento: comportamiento por defecto de la plataforma
          launched = await launchUrl(
            uri,
            mode: LaunchMode.platformDefault,
          );

          if (!launched) {
            print('Intento 3 fallido, probando con externalApplication');

            // Último intento: navegador externo
            launched = await launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );

            if (!launched) {
              print('Todos los intentos fallaron');
              throw 'No se pudo abrir el documento';
            }
          }
        }
      }

      print('✅ Documento abierto exitosamente');
    } catch (e) {
      print('❌ Error al abrir documento: $e');
      Get.snackbar(
        'Error',
        'No se pudo abrir el documento',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close,
                            color: GerenaColors.textPrimaryColor, size: 28),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  _buildImageCarousel(),
                  Divider(height: 2, color: GerenaColors.colorinput),
                  _buildProductInfo(),
                  _buildActionButtons(),
                  Divider(height: 2, color: GerenaColors.colorinput),
                  _buildSimilarProducts(),
                  Divider(height: 2, color: GerenaColors.colorinput),
                  _buildCharacteristics(),
                  _buildLinks(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
        FloatingCartButton(),
      ],
    );
  }

  Widget _buildImageCarousel() {
    return ProductCarouselWidget(
      images: _productImages,
      indicatorStyle: IndicatorStyle.customLines,
      height: 400,
      showNavigationButtons: true,
      autoPlay: false,
      backgroundImage: 'assets/tienda-producto.png',
      imagePadding: 40,
    );
  }

  Widget _buildProductInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (widget.medication.name ?? 'Sin nombre').toUpperCase(),
                  style: GoogleFonts.rubik(
                    fontSize: 14,
                    color: GerenaColors.textTertiaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '\$${(widget.medication.price ?? 0.0).toStringAsFixed(2)} MXN',
                  style: GoogleFonts.rubik(
                    fontSize: 14,
                    color: GerenaColors.textTertiaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (widget.medication.previousPrice != null &&
                    widget.medication.previousPrice! >
                        (widget.medication.price ?? 0)) ...[
                  const SizedBox(height: 3),
                  Text(
                    '\$${widget.medication.previousPrice!.toStringAsFixed(2)} MXN',
                    style: GoogleFonts.rubik(
                      fontSize: 14,
                      color: GerenaColors.textpreviousprice,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: GerenaColors.textpreviousprice,
                      decorationThickness: 2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                if ((widget.medication.stock ?? 0) > 0) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Disponible (${widget.medication.stock} en stock)',
                        style: GoogleFonts.rubik(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Row(
                    children: [
                      Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Agotado',
                        style: GoogleFonts.rubik(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Obx(() {
            final isInWishlist =
                wishlistController.isInWishlist(widget.medication.id);

            return GestureDetector(
              onTap: () {
                wishlistController.toggleWishlist(
                  medicamentoId: widget.medication.id,
                  precio: widget.medication.price ?? 0.0,
                );
              },
              child: Icon(
                isInWishlist ? Icons.favorite : Icons.favorite_border,
                color: isInWishlist
                    ? GerenaColors.errorColor
                    : Colors.grey[400],
                size: 40,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final isAvailable = (widget.medication.stock ?? 0) > 0 &&
        (widget.medication.isActive ?? false);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.center,
        child: FractionallySizedBox(
          widthFactor: 0.7,
          child: Column(
            children: [
              GerenaColors.widgetButton(
                text: 'AGREGAR AL CARRITO',
                onPressed: isAvailable
                    ? () async {
                        await cartController.addToCart(
                          medicamentoId: widget.medication.id,
                          precio: widget.medication.price ?? 0.0,
                          cantidad: 1,
                        );
                      }
                    : null,
                backgroundColor: isAvailable
                    ? GerenaColors.secondaryColor
                    : Colors.grey[400]!,
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
                onPressed: isAvailable
                    ? () async {
                        await cartController.addToCart(
                          medicamentoId: widget.medication.id,
                          precio: widget.medication.price ?? 0.0,
                          cantidad: 1,
                        );

                        Get.toNamed(
                          RoutesNames.shoppdingcart,
                        );
                      }
                    : null,
                backgroundColor:
                    isAvailable ? GerenaColors.primaryColor : Colors.grey[400]!,
                textColor: GerenaColors.textLightColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                padding: const EdgeInsets.symmetric(vertical: 2),
                borderRadius: 25,
                showShadow: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimilarProducts() {
    final GetMedicationsController getMedicationsController =
        Get.find<GetMedicationsController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRODUCTOS SIMILARES',
            style: GoogleFonts.rubik(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: GerenaColors.textTertiaryColor,
            ),
          ),
          const SizedBox(height: 15),
          Obx(() {
            if (getMedicationsController.isLoading.value) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                      color: GerenaColors.primaryColor),
                ),
              );
            }

            if (getMedicationsController.errorMessage.isNotEmpty) {
              return Center(
                child: Column(
                  children: [
                    Icon(Icons.error_outline, size: 40, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      'Error al cargar productos similares',
                      style:
                          GoogleFonts.rubik(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        getMedicationsController.fetchMedicationsByCategory(
                          widget.medication.category ?? '',
                        );
                      },
                      child: Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            final similarMedications = getMedicationsController.medications
                .where((med) => med.id != widget.medication.id)
                .take(3)
                .toList();

            if (similarMedications.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'No hay productos similares disponibles',
                    style: GoogleFonts.rubik(fontSize: 12, color: Colors.grey),
                  ),
                ),
              );
            }

            return SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: similarMedications.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12),
                    child: ProductCardWidget(
                      medication: similarMedications[index],
                      showFavoriteButton: false,
                      showSaveIcon: false,
                      imageHeight: 120,
                      cardPadding: 4,
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCharacteristics() {
    final characteristics = widget.medication.features ??
        [
          'Zona a aplicar: Capa subcutánea',
          'Duración: 12 – 24 meses',
          'Concentración: HA 24 mg/ml',
          'Mentón, pómulos y marcaje mandibular',
          'Gran viscoelasticidad y larga duración',
          'Lidocaína: 0.3%',
        ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Características:',
            style: GoogleFonts.rubik(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: GerenaColors.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 15),
          ...characteristics.map((characteristic) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 10),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: GerenaColors.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      characteristic,
                      style: GoogleFonts.rubik(
                        fontSize: 14,
                        color: GerenaColors.textTertiaryColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 12),
          Text(
            'Descripción:',
            style: GoogleFonts.rubik(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: GerenaColors.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.medication.description ?? 'Sin descripción disponible',
            style: GoogleFonts.rubik(
              fontSize: 14,
              color: GerenaColors.textTertiaryColor,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinks() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          if (widget.medication.termsUrl != null)
            _buildLinkItem(
              text: 'Consulta términos y condiciones de la venta',
              onTap: () => _openPdfUrl(
                widget.medication.termsUrl!,
                'Términos y Condiciones',
              ),
            ),
          if (widget.medication.technicalSheetUrl != null)
            _buildLinkItem(
              text: 'Descargar Ficha Técnica',
              onTap: () => _openPdfUrl(
                widget.medication.technicalSheetUrl!,
                'Ficha Técnica',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLinkItem({required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Icon(Icons.chevron_right,
                color: GerenaColors.primaryColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.rubik(
                    fontSize: 14, color: GerenaColors.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}