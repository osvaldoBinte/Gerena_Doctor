import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/page/dashboard/widget/appbar/gerena_app_bar.dart';
import 'package:gerena/page/dashboard/widget/appbar/gerena_app_bar_controller.dart';
import 'package:gerena/page/store/cartPage/cart_page.dart';
import 'package:gerena/page/store/store_controller.dart';
import 'package:get/get.dart';

class StorePage extends StatelessWidget {
  StorePage({Key? key}) : super(key: key);

  final StoreController controller = Get.put(StoreController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          
            GerenaAppBar(
      
      ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLeftSidebar(),
                
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        
                        _buildMainContent(),
                        
                        const SizedBox(height: 32),
                      ],
                    ),
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
    color: GerenaColors.surfaceColor,
    child: Column(
      children: [
        const SizedBox(height: 20),
        _buildSidebarIcon(Icons.search, 'Buscar', () {
        }),
        _buildSidebarIcon(Icons.favorite, 'Favoritos', () {
        }),
        _buildSidebarIcon(Icons.shopping_cart, 'Carrito', () {
        }),
        const Spacer(),
        _buildSidebarIcon(Icons.headset_mic, 'Soporte', () {
        }),
        const SizedBox(height: 20),
      ],
    ),
  );
}

  
 Widget _buildSidebarIcon(IconData icon, String tooltip, VoidCallback onPressed) {
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
      child: IconButton(
        icon: Icon(
          icon,
          color: GerenaColors.secondaryColor,
        ),
        onPressed: onPressed, 
        padding: EdgeInsets.zero,
        iconSize: 24,
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
          
          const SizedBox(height: 20),
         
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
                Text(
                  'OFERTAS DE PRIMAVERA',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.primaryColor,
                  ),
                ),
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
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final products = [
                      {'name': 'MD COLAGENASA', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                      {'name': 'GLAM FILL', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                      {'name': 'CELOSOME SOFT', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                      {'name': 'JADE GAIN PLUS+', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                    ];
                    
                    return _buildProductCard(products[index]);
                  },
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  'CATÁLOGO',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.primaryColor,
                  ),
                ),
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
                    
                    return _buildProductCard(catalogProducts[index]);
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 24),
          
          Container(
            width: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: GerenaColors.smallBorderRadius,
              boxShadow: [GerenaColors.lightShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CATEGORIAS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                
                Obx(() => Column(
                  children: controller.categories.map((category) {
                    return CheckboxListTile(
                      title: Text(
                        category,
                        style: const TextStyle(fontSize: 14),
                      ),
                      value: controller.selectedCategories.contains(category),
                      onChanged: (_) => controller.toggleCategory(category),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      activeColor: GerenaColors.secondaryColor,
                    );
                  }).toList(),
                )),
                
                const SizedBox(height: 16),
                
               
                ElevatedButton(
                  onPressed: controller.filterProducts,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GerenaColors.secondaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(double.infinity, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text('FILTRAR'),
                ),
                
                const SizedBox(height: 8),
                
                ElevatedButton(
                  onPressed: controller.clearFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: GerenaColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(double.infinity, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text('BORRAR'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProductCard(Map<String, String> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                  child: Image.asset(
                    product['image']!,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: GerenaColors.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16,
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
                        style: TextStyle(
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
                Text(
                  product['price']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: GerenaColors.secondaryColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        'VER INFORMACIÓN',
                        style: TextStyle(
                          color: GerenaColors.secondaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}