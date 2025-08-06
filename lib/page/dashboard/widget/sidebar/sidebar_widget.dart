import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/page/dashboard/dashboard_controller.dart';
import 'package:gerena/page/dashboard/widget/half_cut_circle.dart';
import 'package:gerena/page/dashboard/widget/noticias/news_feed_widget.dart';
import 'package:gerena/page/dashboard/widget/sidebar/modalbot/gerena_%20modal_bot.dart';
import 'package:gerena/page/dashboard/widget/estatusdepedido/widgets_status_pedido.dart';
import 'package:gerena/page/store/cartPage/GlobalShopInterface.dart';
import 'package:get/get.dart';

class SidebarWidget extends StatelessWidget {

  
  const SidebarWidget({
    Key? key,
  
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final DashboardController controller = Get.find<DashboardController>();
  
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
            padding:  EdgeInsets.symmetric(horizontal:16.0),
            
            child: Column(
              children: [
                SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                 _buildWishlistButton(),
                  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            children: [
                              Text(
                                'CATÁLOGO',
                                style: TextStyle(
                                  color: GerenaColors.textLightColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                    
                    _buildCatalogGrid(),
                       Obx(() => (controller.isCalendarFullScreen.value || 
                              controller.currentView.value == 'appointments' ||
                              controller.currentView.value == 'doctor_profile' ||
                              controller.currentView.value == 'user_profile'||
                              controller.currentView.value == 'membresia' ||
                              controller.currentView.value == 'PreguntasFrecuentes')
                         ? const Padding(
                           padding: EdgeInsets.symmetric(horizontal: 16.0),
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
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const GerenaModalBot();
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal:20.0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        // color: GerenaColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                      decoration: BoxDecoration(
                        color: GerenaColors.primaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        'Gerena Bot',
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

          // Noticias compactas en el sidebar
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
                  color: Color(0xFF00332E), // Color verde oscuro para el input
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

  
  
Widget _buildWishlistButton() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 13),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: GerenaColors.textLightColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Icon(
          Icons.favorite, 
          color: GerenaColors.textPrimaryColor,
          size: 24,
        ),
        // Línea horizontal expandible
        Expanded(
          child: Container(
            height: 1, // Grosor de la línea
            margin: const EdgeInsets.symmetric(horizontal: 12), // Espacio a los lados de la línea
            color: GerenaColors.textPrimaryColor, // Color de la línea
          ),
        ),
        Text(
          'WISHLIST',
          style: TextStyle(
            color: GerenaColors.textPrimaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
  
  Widget _buildCatalogGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 0.8,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        children: [
          _buildCategoryItem('Toxinas', 'assets/categoryItem/producto.png'),
          _buildCategoryItem('Relleno Facial', 'assets/categoryItem/producto.png'),
          _buildCategoryItem('Relleno Corporal', 'assets/categoryItem/producto.png'),
          _buildCategoryItem('Enzimas', 'assets/categoryItem/producto.png'),
          _buildCategoryItem('Bioestimuladores','assets/categoryItem/producto.png'),
          _buildCategoryItem('SkinBooster', 'assets/categoryItem/producto.png'),
          _buildCategoryItem('Anestesia', 'assets/categoryItem/producto.png'),
          _buildCategoryItem('Antiobesidad', 'assets/categoryItem/producto.png'),
          _buildCategoryItem('Insumos', 'assets/categoryItem/producto.png'),
        ],
      ),
    );
  }
  
Widget _buildCategoryItem(String text, String imageAssetPath) {
  return InkWell(
    onTap: () {
      
      Get.find<ShopNavigationController>().navigateToStore();
      Get.to(() => GlobalShopInterface());
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
            child: Image.asset(
              imageAssetPath,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(
            color: GerenaColors.textLightColor,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ],
    ),
  );
}



  
 

  // Tarjeta de noticia compacta para el sidebar
  Widget _buildCompactNewsCard(String category, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF00414A),
        borderRadius: GerenaColors.smallBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: TextStyle(
              color: GerenaColors.secondaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              color: GerenaColors.textLightColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}