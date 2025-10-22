import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/presentation/page/Category/category_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/get_medications_controller.dart';
import 'package:gerena/page/dashboard/dashboard_page.dart';
import 'package:gerena/page/dashboard/widget/appbar/gerena_app_bar.dart';
import 'package:gerena/page/dashboard/widget/appbar/gerena_app_bar_controller.dart';
import 'package:gerena/page/dashboard/widget/estatusdepedido/status_card_modal.dart';
import 'package:gerena/page/dashboard/widget/estatusdepedido/widgets_status_pedido.dart';
import 'package:gerena/page/dashboard/widget/facturacion/facturacion.dart';
import 'package:gerena/page/dashboard/widget/sidebar/modalbot/gerena_%20modal_bot.dart';
import 'package:gerena/page/store/blogGerena/blog_gerena.dart';
import 'package:gerena/page/store/cartPage/Wishlistproduct/Wishlist_controller.dart';
import 'package:gerena/page/store/historialDePedidos/historial_de_pedidos_content.dart';
import 'package:gerena/page/store/store_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gerena/page/store/cartPage/cart_page.dart';
import '../../../../../../page/store/cartPage/productDetail/product_detail_byid_page.dart';

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

  void navigateBackToUserProfile() {
    Get.offAll(() => const DashboardPage(), arguments: {
      'showUserProfile': true,
    });
  }
  
  // NUEVO: Toggle del buscador
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
                                              'CONFIRMAR PEDIDO',
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
                                    child: CartPageContent(
                                      onBackPressed:
                                          navigationController.navigateToStore,
                                    ),
                                  ),
                                ],
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
    return Container(
      width: 50,
      height: double.infinity,
      color: GerenaColors.backgroundColorfondo,
      child: Column(children: [
        const SizedBox(height: 20),
        _buildSidebarIcon(
          imagePath: 'assets/icons/search.png',
          tooltip: 'Buscar',
          onPressed: () {          navigationController.toggleSearchBar();
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
        _buildSidebarIcon(
          imagePath: 'assets/icons/shopping_cart.png',
          tooltip: 'Carrito',
          onPressed: () {
            navigationController.navigateToCart();
          },
        ),
        const Spacer(),
        _buildSidebarIcon(
          imagePath: 'assets/icons/headset_mic.png',
          tooltip: 'Soporte',
          onPressed: () {
            showDialog(
              context: Get.context!,
              builder: (BuildContext context) {
                return const GerenaModalBot();
              },
            );
          },
        ),
        const SizedBox(height: 20),
      ]),
    );
  }

 Widget _buildSidebarIcon({
  IconData? icon,
  String? imagePath,
  required String tooltip,
  required VoidCallback onPressed,
}) {
  return Tooltip(
    message: tooltip,
    child: Container(
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
                // El debounce ya está configurado en el controller
                print('🔍 Escribiendo: $value');
              },
            ),
          ),
          const SizedBox(width: 12),
          // Botón para cerrar barra de búsqueda
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
}Widget _buildOffersSection() {
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

        // Loading de ofertas
        if (medicationsController.isLoadingOffers.value)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: CircularProgressIndicator(
                color: GerenaColors.primaryColor,
              ),
            ),
          )
        // Error de ofertas
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
        // Carousel de ofertas
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
                          child: _buildProductCard(productData),
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
}Widget _buildCatalogSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Header del catálogo
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

      // Grid de productos (Obx separado)
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
                  };

                  if (medication.previousprice != null &&
                      medication.previousprice! > medication.price) {
                    productData['hasDiscount'] = 'true';
                    productData['oldPrice'] =
                        '${medication.previousprice!.toStringAsFixed(2)} MXN';
                  }

                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: _buildProductCard(productData),
                      );
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
}Widget _buildCategoriesSidebar() {
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
  Widget _buildProductCard(Map<String, String> product) {
    final bool hasDiscount = product['hasDiscount'] == 'true';

    return GestureDetector(
      onTap: () => navigationController.navigateToProductDetail(product),
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
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(8)),
                      image: DecorationImage(
                        image: AssetImage('assets/tienda-producto.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Center(
  child: Hero(
    tag: 'product-${product['name']}',
    child: (product['image']?.isNotEmpty ?? false)
        ? Image.network(
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
              return Container(
                height: 120,
                decoration: BoxDecoration(
                  color: GerenaColors.backgroundColorfondo,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image_outlined,
                      size: 50,
                      color: GerenaColors.textTertiaryColor.withOpacity(0.4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Imagen no disponible',
                      style: GoogleFonts.rubik(
                        fontSize: 10,
                        color: GerenaColors.textTertiaryColor.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          )
        : Container(
            height: 120,
            decoration: BoxDecoration(
              color: GerenaColors.backgroundColorfondo,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  size: 50,
                  color: GerenaColors.textTertiaryColor.withOpacity(0.4),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sin imagen',
                  style: GoogleFonts.rubik(
                    fontSize: 10,
                    color: GerenaColors.textTertiaryColor.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
  ),
),
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product['name']!,
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: GerenaColors.primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite_border,
                            color: Colors.grey),
                        onPressed: () {},
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  if (hasDiscount) ...[
                    Text(
                      product['price']!,
                      style: GoogleFonts.rubik(
                        fontSize: 12,
                        color: GerenaColors.textDarkColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      product['oldPrice']!,
                      style: GoogleFonts.rubik(
                        fontSize: 10,
                        color: GerenaColors.descuento,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: GerenaColors.descuento,
                      ),
                    ),
                  ] else ...[
                    Text(
                      product['price']!,
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
                      onTap: () =>
                          navigationController.navigateToProductDetail(product),
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
            ),
          ],
        ),
      ),
    );
  }
}
