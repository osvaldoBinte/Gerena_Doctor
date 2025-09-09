import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
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
import 'productDetail/product_detail_byid_page.dart';

class ShopNavigationController extends GetxController {
  final RxInt currentView = 0.obs;
  final Rx<Map<String, String>?> selectedProduct = Rx<Map<String, String>?>(null);

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
  
  void navigateFacturacion(){
    currentView.value = 5; 
    selectedProduct.value = null;
  }
  
  void navigateToBlogGerena(){
    currentView.value = 6; 
    selectedProduct.value = null;
  }
  
  void navigateBackToUserProfile() {
    Get.offAll(() => const DashboardPage(), arguments: {
      'showUserProfile': true,
    });
  }
}

class GlobalShopInterface extends StatelessWidget {
  GlobalShopInterface({Key? key}) : super(key: key);

  final StoreController storeController = Get.put(StoreController());
  final navigationController = Get.find<ShopNavigationController>();
  final CarouselSliderController _carouselController = CarouselSliderController();

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
                          } 
                          else if (navigationController.currentView.value == 1) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 60),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(25),
                                        onTap: navigationController.navigateToStore,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: GerenaColors.secondaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(8.0),
                                              child: const Icon(
                                                Icons.arrow_back,
                                                color: GerenaColors.textLightColor,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'CONFIRMAR PEDIDO',
                                              style: GoogleFonts.rubik(
                                                color: GerenaColors.textPrimaryColor,
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
                                      onBackPressed: navigationController.navigateToStore,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          else if (navigationController.currentView.value == 2 && 
                                   navigationController.selectedProduct.value != null) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 60),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(25),
                                        onTap: navigationController.navigateToStore,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: GerenaColors.secondaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(8.0),
                                              child: const Icon(
                                                Icons.arrow_back,
                                                color: GerenaColors.textLightColor,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'VOLVER A LA TIENDA',
                                              style: GoogleFonts.rubik(
                                                color: GerenaColors.textPrimaryColor,
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
                                      product: navigationController.selectedProduct.value!,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          else if (navigationController.currentView.value == 3) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 60),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(25),
                                        onTap: navigationController.navigateToStore,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: GerenaColors.secondaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(8.0),
                                              child: const Icon(
                                                Icons.arrow_back,
                                                color: GerenaColors.textLightColor,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'GUARDADOS',
                                              style: GoogleFonts.rubik(
                                                color: GerenaColors.textPrimaryColor,
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
                                      onBackPressed: navigationController.navigateToStore,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          else if (navigationController.currentView.value == 4) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 60),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(25),
                                        onTap: navigationController.navigateBackToUserProfile,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: GerenaColors.secondaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(8.0),
                                              child: const Icon(
                                                Icons.arrow_back,
                                                color: GerenaColors.textLightColor,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'HISTORIAL DE PEDIDOS',
                                              style: GoogleFonts.rubik(
                                                color: GerenaColors.textPrimaryColor,
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
                          }
                          else if (navigationController.currentView.value == 5) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 60),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(25),
                                        onTap: navigationController.navigateBackToUserProfile,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: GerenaColors.secondaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(8.0),
                                              child: const Icon(
                                                Icons.arrow_back,
                                                color: GerenaColors.textLightColor,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'FACTURACIÓN',
                                              style: GoogleFonts.rubik(
                                                color: GerenaColors.textPrimaryColor,
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
                          }
                          else if (navigationController.currentView.value == 6) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 60),
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
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          _buildSidebarIcon(
            imagePath: 'assets/icons/search.png',
            tooltip: 'Buscar', 
            onPressed: () {},
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
        ]
      ),
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
                  : Image.asset(
                      imagePath!,
                      width: 24,
                      height: 24,
                      color: GerenaColors.secondaryColor,
                    ),
            ),
          ),
        ),
      ),
    );
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
                        icon: Image.asset('assets/icons/arrow_back_ios.png',
                        width: 18,
                        height: 18,
                        )
                        
                      
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
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration: const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: false,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: [
                          {'name': 'MD COLAGENASA', 'price': '900.00 MXN', 'oldPrice': '1,000.00 MXN', 'image': 'assets/productoenventa.png', 'hasDiscount': 'true'},
                          {'name': 'GLAM FILL', 'price': '850.00 MXN', 'oldPrice': '1,000.00 MXN', 'image': 'assets/productoenventa.png', 'hasDiscount': 'true'},
                          {'name': 'CELOSOME SOFT', 'price': '900.00 MXN', 'oldPrice': '1,000.00 MXN', 'image': 'assets/productoenventa.png', 'hasDiscount': 'true'},
                          {'name': 'JADE GAIN PLUS+', 'price': '800.00 MXN', 'oldPrice': '1,000.00 MXN', 'image': 'assets/productoenventa.png', 'hasDiscount': 'true'},
                        ].map((product) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: _buildProductCard(product),
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
                        icon: Image.asset('assets/icons/arrow_forward_ios.png',
                        width: 18,
                        height: 18,
                        )
                    ),
                    )
                  ],
                ),
              
                const SizedBox(height: 24),
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
                      
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          final catalogProducts = [
                            {'name': 'CELOSOME IMPLANT', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                            {'name': 'CELOSOME MID', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                            {'name': 'CELOSOME SOFT', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                            {'name': 'CELOSOME STRONG', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                            {'name': 'DERMA EVOLUTION', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                            {'name': 'INNOTOX', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                            {'name': 'LIRAFIT SEMAGLUTIDA', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                            {'name': 'LINURASE', 'price': '2,200.00 MXN', 'image': 'assets/productoenventa.png'},
                            {'name': 'DERMA WRINKLES', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                            {'name': 'DERMA EVOLUTION', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                            {'name': 'GLAM FILL', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                            {'name': 'JADE CAINE', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                          ];
                          
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: _buildProductCard(catalogProducts[index]),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 24),
          
          Container(
            width: 240,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CATEGORIAS',
                  style: GoogleFonts.rubik(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.textTertiaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                
                Obx(() => Column(
                  children: storeController.categories.map((category) {
                    return CheckboxListTile(
                      title: Text(
                        category,
                        style: GoogleFonts.rubik(fontSize: 16,
                        color: GerenaColors.textTertiaryColor),
                        
                      ),
                      value: storeController.selectedCategories.contains(category),
                      onChanged: (_) => storeController.toggleCategory(category),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      activeColor: GerenaColors.primaryColor,
                      
                    );
                  }).toList(),
                )),
                
               const SizedBox(height: 16),

IntrinsicWidth(
  child: GerenaColors.widgetButton(
    text: 'FILTRAR',
    onPressed: storeController.filterProducts,
    customShadow: GerenaColors.mediumShadow,
  ),
),

const SizedBox(height: 16),

IntrinsicWidth(
  child: GerenaColors.widgetButton(
    text: 'BORRAR',
    onPressed: storeController.clearFilters,
    customShadow: GerenaColors.mediumShadow,
  ),
),
                
              ],
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
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      image: DecorationImage(
                        image: AssetImage('assets/tienda-producto.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Center(
                    child: Hero(
                      tag: 'product-${product['name']}',
                      child: Image.asset(
                        product['image']!,
                        height: 120,
                        fit: BoxFit.contain,
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
                        icon: const Icon(Icons.favorite_border, color: Colors.grey),
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
                      onTap: () => navigationController.navigateToProductDetail(product),
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