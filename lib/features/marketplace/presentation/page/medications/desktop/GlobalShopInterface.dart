import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/presentation/page/Category/category_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/shopping/shopping_cart_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/get_medications_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/paymentcard/payment_cards_screen.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/product_card_widget.dart';
import 'package:gerena/features/marketplace/presentation/page/wishlist/ejemplo/ejemplo_%20saved_products_content.dart';
import 'package:gerena/features/marketplace/presentation/page/wishlist/saved_products_content.dart';
import 'package:gerena/page/dashboard/dashboard_page.dart';
import 'package:gerena/page/dashboard/widget/appbar/gerena_app_bar.dart';
import 'package:gerena/page/dashboard/widget/appbar/gerena_app_bar_controller.dart';
import 'package:gerena/page/dashboard/widget/estatusdepedido/status_card_modal.dart';
import 'package:gerena/page/dashboard/widget/estatusdepedido/widgets_status_pedido.dart';
import 'package:gerena/page/dashboard/widget/facturacion/facturacion.dart';
import 'package:gerena/page/dashboard/widget/sidebar/modalbot/gerena_%20modal_bot.dart';
import 'package:gerena/page/store/blogGerena/blog_gerena.dart';
import 'package:gerena/page/store/historialDePedidos/historial_de_pedidos_content.dart';
import 'package:gerena/page/store/store_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gerena/features/marketplace/presentation/page/shopping/cart_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'productDetail/product_detail_byid_page.dart';

class ShopNavigationController extends GetxController {
  final RxInt currentView = 0.obs;
  final Rx<Map<String, String>?> selectedProduct = Rx<Map<String, String>?>(null);
  
  // NUEVO: Variable para controlar visibilidad del buscador
  final RxBool showSearchBar = false.obs;

  void navigateToStore() {
    currentView.value = 0;
    selectedProduct.value = null;
  }

  void navigateToCart() {
    currentView.value = 1;
    selectedProduct.value = null;
  }

  void navigateToWishlist() {
    currentView.value = 3;
    selectedProduct.value = null;
  }

  void navigateToProductDetail(Map<String, String> product) {
    selectedProduct.value = product;
    currentView.value = 2;
  }

  void navigateToHistorialDePedidos() {
    currentView.value = 4;
    selectedProduct.value = null;
  }

  void navigateFacturacion() {
    currentView.value = 5;
    selectedProduct.value = null;
  }

  void navigateToBlogGerena() {
    currentView.value = 6;
    selectedProduct.value = null;
  }
void navigateToPaymentCards() {
    currentView.value = 7;
    selectedProduct.value = null;
  }
  void navigateBackToUserProfile() {
    Get.offAll(() => const DashboardPage(), arguments: {
      'showUserProfile': true,
    });
  }
  
  void toggleSearchBar() {
    showSearchBar.value = !showSearchBar.value;
  }
}

class GlobalShopInterface extends StatelessWidget {
  GlobalShopInterface({Key? key}) : super(key: key);

  final StoreController storeController = Get.put(StoreController());
  final navigationController = Get.find<ShopNavigationController>();
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final GetMedicationsController medicationsController =
      Get.find<GetMedicationsController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorfondo,
      body: Column(
        children: [
          GerenaAppBar(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLeftSidebar(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      Expanded(
                        child: Obx(() {
                          if (navigationController.currentView.value == 0) {
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildMainContent(),
                                  const SizedBox(height: 32),
                                ],
                              ),
                            );
                          } else if (navigationController.currentView.value ==
                              1) {
                            return  Expanded(
                                    child: CartPageContent(
                                     // onBackPressed: navigationController.navigateToStore,
                                    ),
                                  );
                          } else if (navigationController.currentView.value ==
                                  2 &&
                              navigationController.selectedProduct.value !=
                                  null) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 60),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(25),
                                        onTap: navigationController
                                            .navigateToStore,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    GerenaColors.secondaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(8.0),
                                              child: const Icon(
                                                Icons.arrow_back,
                                                color:
                                                    GerenaColors.textLightColor,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'VOLVER A LA TIENDA',
                                              style: GoogleFonts.rubik(
                                                color: GerenaColors
                                                    .textPrimaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: ProductDetailPage(
                                      product: navigationController
                                          .selectedProduct.value!,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (navigationController.currentView.value ==
                              3) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 60),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(25),
                                        onTap: navigationController
                                            .navigateToStore,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    GerenaColors.secondaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(8.0),
                                              child: const Icon(
                                                Icons.arrow_back,
                                                color:
                                                    GerenaColors.textLightColor,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'GUARDADOS',
                                              style: GoogleFonts.rubik(
                                                color: GerenaColors
                                                    .textPrimaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: SavedProductsContent(
                                      onBackPressed:
                                          navigationController.navigateToStore,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (navigationController.currentView.value ==
                              4) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 60),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(25),
                                        onTap: navigationController
                                            .navigateBackToUserProfile,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    GerenaColors.secondaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(8.0),
                                              child: const Icon(
                                                Icons.arrow_back,
                                                color:
                                                    GerenaColors.textLightColor,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'HISTORIAL DE PEDIDOS',
                                              style: GoogleFonts.rubik(
                                                color: GerenaColors
                                                    .textPrimaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: HistorialDePedidosContent(),
                                  ),
                                ],
                              ),
                            );
                          } else if (navigationController.currentView.value ==
                              5) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 60),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(25),
                                        onTap: navigationController
                                            .navigateBackToUserProfile,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    GerenaColors.secondaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(8.0),
                                              child: const Icon(
                                                Icons.arrow_back,
                                                color:
                                                    GerenaColors.textLightColor,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'FACTURACIÓN',
                                              style: GoogleFonts.rubik(
                                                color: GerenaColors
                                                    .textPrimaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Expanded(
                                    child: Facturacion(),
                                  ),
                                ],
                              ),
                            );
                          } else if (navigationController.currentView.value ==
                              6) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 60),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: BlogGerena(),
                                  ),
                                ],
                              ),
                            );
                          } else if (navigationController.currentView.value ==
                              7) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 60),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: PaymentCardsScreen(),
                                  ),
                                ],
                              ),
                            );
                          }

                          return Center(
                            child: Text(
                              'Vista no disponible',
                              style: GoogleFonts.rubik(),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
Widget _buildLeftSidebar() {
  // ⭐ Obtén el controlador del carrito
  final cartController = Get.find<ShoppingCartController>();
  
  return Container(
    width: 50,
    height: double.infinity,
    color: GerenaColors.backgroundColorfondo,
    child: Column(
      children: [
        const SizedBox(height: 20),
        _buildSidebarIcon(
          imagePath: 'assets/icons/search.png',
          tooltip: 'Buscar',
          onPressed: () {
            navigationController.toggleSearchBar();
                        navigationController.navigateToStore();

          },
        ),
        _buildSidebarIcon(
          imagePath: 'assets/icons/truck.png',
          tooltip: 'Estatus de pedido',
          onPressed: () {
            showDialog(
              context: Get.context!,
              builder: (BuildContext context) {
                return StatusCardModal();
              },
            );
          },
        ),
        _buildSidebarIcon(
          icon: Icons.favorite,
          tooltip: 'Favoritos',
          onPressed: () {
            navigationController.navigateToWishlist();
          },
        ),
        
        Obx(() => _buildSidebarIcon(
          imagePath: 'assets/icons/shopping_cart.png',
          tooltip: 'Carrito',
          badgeCount: cartController.totalItems, 
          onPressed: () {
            navigationController.navigateToCart();
          },
        )),
        
        const Spacer(),
        _buildSidebarIcon(
          imagePath: 'assets/icons/headset_mic.png',
          tooltip: 'Soporte',
          onPressed: () {
           openWhatsApp();
          },
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}
  // Función para abrir WhatsApp
  Future<void> openWhatsApp() async {
    final Uri whatsappUrl = Uri.parse(
        'https://api.whatsapp.com/send/?phone=%E2%80%AA%E2%80%AA5213321642470&text=Hola+necesito+m%C3%A1s+informaci%C3%B3n.&type=phone_number&app_absent=0');

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(
          whatsappUrl,
          mode: LaunchMode.externalApplication, // Abre en la app externa
        );
      } else {
        // Si no puede abrir WhatsApp, muestra un mensaje
        Get.snackbar(
          'Error',
          'No se pudo abrir WhatsApp. Por favor, verifica que esté instalado.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error al abrir WhatsApp: $e');
      Get.snackbar(
        'Error',
        'Ocurrió un error al intentar abrir WhatsApp',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

Widget _buildSidebarIcon({
  IconData? icon,
  String? imagePath,
  required String tooltip,
  required VoidCallback onPressed,
  int? badgeCount, // ⭐ NUEVO parámetro
}) {
  return Tooltip(
    message: tooltip,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: GerenaColors.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          width: 48,
          height: 48,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onPressed,
              child: Center(
                child: icon != null
                    ? Icon(
                        icon,
                        color: GerenaColors.secondaryColor,
                        size: 24,
                      )
                    : (imagePath != null && imagePath.isNotEmpty
                        ? Image.asset(
                            imagePath,
                            width: 24,
                            height: 24,
                            color: GerenaColors.secondaryColor,
                          )
                        : const Icon(
                            Icons.error,
                            color: Colors.red,
                          )),
              ),
            ),
          ),
        ),
        
        // ⭐ BADGE - Indicador numérico
        if (badgeCount != null && badgeCount > 0)
          Positioned(
            right: -4,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(
                  color: GerenaColors.backgroundColorfondo,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Center(
                child: Text(
                  badgeCount > 99 ? '99+' : badgeCount.toString(),
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}Widget _buildSearchBar() {
  return Obx(() {
    if (!navigationController.showSearchBar.value) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: GerenaColors.createSearchTextField(
              controller: medicationsController.searchController,
              hintText: 'Buscar productos...',
              onSearchPressed: () {
                final query = medicationsController.searchController.text.trim();
                if (query.isNotEmpty) {
                  medicationsController.searchMedications(query);
                }
              },
              onChanged: (value) {
                print('🔍 Escribiendo: $value');
              },
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: GerenaColors.secondaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  medicationsController.clearSearch();
                  navigationController.toggleSearchBar();
                },
                child: Icon(
                  Icons.close,
                  color: GerenaColors.textLightColor,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  });
}
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/gerena-logo-home.png',
                height: 30,
              ),
            ),
          ),
          const SizedBox(height: 7),
        ],
      ),
    );
  }
Widget _buildMainContent() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BARRA DE BÚSQUEDA (tiene su propio Obx interno)
              _buildSearchBar(),
              
              // SECCIÓN DE OFERTAS (Obx separado)
              _buildOffersSection(),
              
              // SECCIÓN DE CATÁLOGO (separada)
              _buildCatalogSection(),
            ],
          ),
        ),
        
        const SizedBox(width: 24),
        
        // SIDEBAR DE CATEGORÍAS
        _buildCategoriesSidebar(),
      ],
    ),
  );
}
Widget _buildOffersSection() {
  return Obx(() {
    if (!medicationsController.showOffers.value) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'OFERTAS DE PRIMAVERA',
                    style: GoogleFonts.rubik(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: GerenaColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        if (medicationsController.isLoadingOffers.value)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: CircularProgressIndicator(
                color: GerenaColors.primaryColor,
              ),
            ),
          )
        else if (medicationsController.errorMessageOffers.isNotEmpty)
          Center(
            child: Column(
              children: [
                Text(
                  medicationsController.errorMessageOffers.value,
                  style: GoogleFonts.rubik(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: medicationsController.retryFetchOffers,
                  child: Text('Reintentar ofertas'),
                ),
              ],
            ),
          )
        else if (medicationsController.medicationsOnSale.isNotEmpty)
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: GerenaColors.secondaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => _carouselController.previousPage(),
                  icon: Image.asset(
                    'assets/icons/arrow_back_ios.png',
                    width: 18,
                    height: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    height: 280,
                    viewportFraction: 0.25,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: medicationsController.medicationsOnSale.map((medication) {
                    final productData = {
                      'name': medication.name,
                      'price': '${medication.price.toStringAsFixed(2)} MXN',
                      'image': medication.imagen ?? '',
                      'description': medication.description,
                      'stock': medication.stock.toString(),
                      'id': medication.id.toString(),
                      'category': medication.categoria ?? '',
                    };

                    if (medication.previousprice != null && 
                        medication.previousprice! > medication.price) {
                      productData['hasDiscount'] = 'true';
                      productData['oldPrice'] = '${medication.previousprice!.toStringAsFixed(2)} MXN';
                    }

                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ProductCardWidget(
                            product: productData,
                            onTap: () => navigationController.navigateToProductDetail(productData),
                            onFavoritePressed: () {
                              // Lógica para añadir a favoritos
                              print('Añadido a favoritos: ${medication.name}');
                            },
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: GerenaColors.secondaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => _carouselController.nextPage(),
                  icon: Image.asset(
                    'assets/icons/arrow_forward_ios.png',
                    width: 18,
                    height: 18,
                  ),
                ),
              ),
            ],
          )
        else
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'No hay ofertas disponibles',
                style: GoogleFonts.rubik(
                  color: GerenaColors.textTertiaryColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),

        const SizedBox(height: 24),
      ],
    );
  });
}
Widget _buildCatalogSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: GerenaColors.textTertiaryColor.withOpacity(0.6),
              thickness: 2,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'CATÁLOGO',
                  style: GoogleFonts.rubik(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: GerenaColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 16),
            
            Obx(() {
              if (medicationsController.isLoading.value) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(
                      color: GerenaColors.primaryColor,
                    ),
                  ),
                );
              }

              if (medicationsController.errorMessage.isNotEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Text(
                        medicationsController.errorMessage.value,
                        style: GoogleFonts.rubik(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: medicationsController.retryFetch,
                        child: Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              }

              if (medicationsController.medications.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      'No se encontraron productos',
                      style: GoogleFonts.rubik(
                        color: GerenaColors.textTertiaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: medicationsController.medications.length,
                itemBuilder: (context, index) {
                  final medication = medicationsController.medications[index];

                  final productData = {
                    'name': medication.name,
                    'price': '${medication.price.toStringAsFixed(2)} MXN',
                    'image': medication.imagen ?? '',
                    'description': medication.description,
                    'stock': medication.stock.toString(),
                    'id': medication.id.toString(),
                    'category': medication.categoria ?? '',
                  };

                  if (medication.previousprice != null &&
                      medication.previousprice! > medication.price) {
                    productData['hasDiscount'] = 'true';
                    productData['oldPrice'] =
                        '${medication.previousprice!.toStringAsFixed(2)} MXN';
                  }

                  return ProductCardWidget(
                    product: productData,
                    onTap: () => navigationController.navigateToProductDetail(productData),
                    onFavoritePressed: () {
                      // Lógica para añadir a favoritos
                      print('Añadido a favoritos: ${medication.name}');
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
    ],
  );
}


Widget _buildCategoriesSidebar() {
  return Container(
    width: 240,
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CATEGORÍAS',
          style: GoogleFonts.rubik(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: GerenaColors.textTertiaryColor,
          ),
        ),
        const SizedBox(height: 16),
        
        Obx(() {
          if (categoryController.isLoading.value) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(
                  color: GerenaColors.primaryColor,
                  strokeWidth: 2,
                ),
              ),
            );
          }
          
          if (categoryController.errorMessage.isNotEmpty) {
            return Column(
              children: [
                Text(
                  categoryController.errorMessage.value,
                  style: GoogleFonts.rubik(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: categoryController.retryFetch,
                  child: Text(
                    'Reintentar',
                    style: GoogleFonts.rubik(
                      fontSize: 12,
                      color: GerenaColors.primaryColor,
                    ),
                  ),
                ),
              ],
            );
          }
          
          if (categoryController.categories.isEmpty) {
            return Center(
              child: Text(
                'No hay categorías',
                style: GoogleFonts.rubik(
                  fontSize: 12,
                  color: GerenaColors.textTertiaryColor,
                ),
              ),
            );
          }
          
          return Column(
            children: categoryController.categories.map((categoryEntity) {
              final categoryName = categoryEntity.category;
              
              return CheckboxListTile(
                title: Text(
                  categoryName,
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    color: GerenaColors.textTertiaryColor,
                  ),
                ),
                value: categoryController.selectedCategories.contains(categoryName),
                onChanged: (_) => categoryController.toggleCategory(categoryName),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
                activeColor: GerenaColors.primaryColor,
              );
            }).toList(),
          );
        }),
        
        const SizedBox(height: 16),
        
        IntrinsicWidth(
          child: GerenaColors.widgetButton(
            text: 'FILTRAR',
            onPressed: () {
              medicationsController.filterByCategories(
                categoryController.selectedCategories.toList()
              );
            },
            customShadow: GerenaColors.mediumShadow,
          ),
        ),
        
        const SizedBox(height: 16),
        
        IntrinsicWidth(
          child: GerenaColors.widgetButton(
            text: 'BORRAR',
            onPressed: () {
              categoryController.clearFilters();
              medicationsController.clearCategoryFilters();
            },
            customShadow: GerenaColors.mediumShadow,
          ),
        ),
      ],
    ),
  );
}
 
}
