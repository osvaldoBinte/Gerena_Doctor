import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/widgts.dart';
import 'package:gerena/features/marketplace/presentation/page/Category/category_controller.dart';
import 'package:gerena/page/dashboard/dashboard_controller.dart';
import 'package:gerena/page/dashboard/widget/half_cut_circle.dart';
import 'package:gerena/features/banners/presentation/page/noticias/news_feed_widget.dart';
import 'package:gerena/page/dashboard/widget/estatusdepedido/widgets_status_pedido.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // Importa url_launcher

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({
    Key? key,
  }) : super(key: key);

  // Función para abrir WhatsApp
  Future<void> _openWhatsApp() async {
    final Uri whatsappUrl = Uri.parse(
      'https://api.whatsapp.com/send/?phone=%E2%80%AA%E2%80%AA5213321642470&text=Hola+necesito+m%C3%A1s+informaci%C3%B3n.&type=phone_number&app_absent=0'
    );
    
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

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();
    final CategoryController categoryController =
        Get.find<CategoryController>();

    return Container(
      width: 350,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/menu/MENUGERENA.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            SizedBox(height: 15),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/gerena-logo-home.png',
                                    height: 45,
                                  ),
                                ],
                              ),
                            ),
                            _buildSearchField(),
                            StatusCardWidget(),
                            SizedBox(height: 10),
                            buildWishlistButton(
                              onTap: () {
                                  final navigationController = Get.find<ShopNavigationController>();

                                      navigationController.navigateToWishlist();
                                Get.to(() => GlobalShopInterface());
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.find<ShopNavigationController>()
                                          .navigateToStore();
                                      Get.to(
                                        () => GlobalShopInterface(),
                                        arguments: {
                                          'categoryName': '',
                                          'showOffers': true,
                                        },
                                      );
                                    },
                                    child: Text(
                                      'CATÁLOGO',
                                      style: TextStyle(
                                        color: GerenaColors.textLightColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            _buildCatalogGrid(categoryController),

                            Obx(() => (dashboardController
                                        .isCalendarFullScreen.value ||
                                    dashboardController.currentView.value ==
                                        'appointments' ||
                                    dashboardController.currentView.value ==
                                        'doctor_profile' ||
                                    dashboardController.currentView.value ==
                                        'user_profile' ||
                                    dashboardController.currentView.value ==
                                        'membresia' ||
                                    dashboardController.currentView.value ==
                                        'PreguntasFrecuentes')
                                ? const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: NewsFeedWidget(),
                                  )
                                : const SizedBox.shrink()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: _openWhatsApp, // Cambio aquí: ahora llama a _openWhatsApp
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: GerenaColors.surfaceColor,
                  borderRadius: GerenaColors.smallBorderRadius,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: GerenaColors.surfaceColor,
                      ),
                      child: Image.asset(
                        'assets/icons/headset_mic.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 3),
                        decoration: BoxDecoration(
                          color: GerenaColors.primaryColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'Gerena',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: GerenaColors.surfaceColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 60,
              height: 4,
              margin: const EdgeInsets.only(top: 8, bottom: 12),
              decoration: BoxDecoration(
                color: GerenaColors.surfaceColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return GestureDetector(
      onTap: () {
        Get.find<ShopNavigationController>().navigateToStore();
        Get.to(() => GlobalShopInterface());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 12),
              child: Image.asset(
                'assets/icons/search.png',
                width: 28,
                height: 28,
              ),
            ),
            Expanded(
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Color(0xFF00332E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      'Buscar Producto',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatalogGrid(CategoryController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Container(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(
              color: GerenaColors.primaryColor,
            ),
          ),
        );
      }

      if (controller.errorMessage.isNotEmpty) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 40),
              SizedBox(height: 8),
              Text(
                controller.errorMessage.value,
                style:
                    TextStyle(color: GerenaColors.textLightColor, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: controller.retryFetch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: GerenaColors.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text('Reintentar', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        );
      }

      if (controller.categories.isEmpty) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Text(
            'No hay categorías disponibles',
            style: TextStyle(color: GerenaColors.textLightColor),
            textAlign: TextAlign.center,
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.8,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return _buildCategoryItem(
              category.category ?? 'Sin categoria',
              category.image ?? '',
            );
          },
        ),
      );
    });
  }

  Widget _buildCategoryItem(
    String text,
    String imageAssetPath,
  ) {
    return InkWell(
      onTap: () {
        Get.find<ShopNavigationController>().navigateToStore();
        Get.to(
          () => GlobalShopInterface(),
          arguments: {
            'categoryName': text,
            'showOffers': false,
          },
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhysicalShape(
            clipper: BottomFlatClipper(),
            color: GerenaColors.backgroundproductcategory,
            elevation: 4,
            shadowColor: Colors.black,
            child: Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(12),
              child: imageAssetPath.startsWith('http')
                  ? Image.network(
                      imageAssetPath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.category,
                          color: GerenaColors.primaryColor,
                          size: 40,
                        );
                      },
                    )
                  : Image.asset(
                      imageAssetPath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.category,
                          color: GerenaColors.primaryColor,
                          size: 40,
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
              color: GerenaColors.textLightColor,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}