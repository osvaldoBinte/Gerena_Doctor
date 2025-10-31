import 'package:flutter/material.dart';
import 'package:gerena/common/widgets/simple_counter.dart';
import 'package:gerena/features/marketplace/presentation/page/wishlist/modalGuardarProducto/modal_guardar_producto.dart';
import 'package:gerena/features/marketplace/presentation/page/wishlist/wishlist_controller.dart';
import 'package:get/get.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedProductsContent extends StatelessWidget {
  final VoidCallback onBackPressed;
  
  SavedProductsContent({
    Key? key, 
    required this.onBackPressed,
  }) : super(key: key);
  
  final wishlistController = Get.find<WishlistController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorfondo,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 600 ? 50.0 : 16.0,
        ),
        child: Container(
          color: GerenaColors.backgroundColor,
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width > 600 ? 40.0 : 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Mis listas',
                  style: GoogleFonts.rubik(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.textTertiaryColor,
                  ),
                ),
              ),
              
              Obx(() {
                if (wishlistController.isLoading.value) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width > 600 ? 40.0 : 16.0,
                      ),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                
                if (wishlistController.wishlistItems.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width > 600 ? 40.0 : 16.0,
                      ),
                      child: Text(
                        'No tienes productos guardados',
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          color: GerenaColors.textTertiaryColor,
                        ),
                      ),
                    ),
                  );
                }
                
                if (wishlistController.error.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width > 600 ? 40.0 : 16.0,
                      ),
                      child: Text(
                        wishlistController.error.value,
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );
                }
                
                final response = wishlistController.wishlistResponse.value;
                
                if (response == null || response.itenms.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width > 600 ? 40.0 : 16.0,
                      ),
                      child: Text(
                        'Cargando productos...',
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          color: GerenaColors.textTertiaryColor,
                        ),
                      ),
                    ),
                  );
                }
                
                final Map<String, List<dynamic>> productsByCategory = {};
                
                for (var item in response.itenms) {
                  final category = item.descripcion?.isNotEmpty == true 
                      ? item.descripcion! 
                      : 'Favoritos';
                  
                  if (!productsByCategory.containsKey(category)) {
                    productsByCategory[category] = [];
                  }
                  productsByCategory[category]!.add(item);
                }
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: productsByCategory.entries.map((entry) {
                    final categoryName = entry.key;
                    final items = entry.value;
                    final isProgrammed = false;
                    
                    return _buildCategorySection(
                      categoryName: categoryName,
                      items: items,
                      isProgrammed: isProgrammed,
                      context: context,
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCategorySection({
    required String categoryName,
    required List items,
    required bool isProgrammed,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(
              '-$categoryName ',
              style: GoogleFonts.rubik(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: GerenaColors.textTertiaryColor,
              ),
            ),),
            
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 600 ? 80.0 : 16.0,
                vertical: 20,
              ),
              child: 
              /*isProgrammed
                  ? Row(
                      children: [
                        Text(
                          'Programado',
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            color: GerenaColors.textTertiaryColor,
                          ),
                        ),
                        SizedBox(width: 8),
                        GerenaColors.widgetButton(
                          text: 'EDITAR',
                          showShadow: false,
                        ),
                      ],
                    )
                  :*/ 
              GerenaColors.widgetButton(
                text: 'PROGRAMAR PEDIDO',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const ModalGuardarProducto();
                    },
                  );
                },
                customShadow: GerenaColors.mediumShadow,
              ),
            )
          ],
        ),
        
        SizedBox(height: 8),
        Column(
          children: List.generate(items.length, (index) {
            final item = items[index];
            return _buildProductItem(
              item: item,
              index: index,
              isProgrammed: isProgrammed,
              context: context,
            );
          }),
        ),
        
        SizedBox(height: 24),
      ],
    );
  }
  
  Widget _buildProductItem({
    required dynamic item,
    required int index,
    bool isProgrammed = false,
    required BuildContext context,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Icon(
              Icons.medical_services,
              size: 40,
              color: Colors.grey[400],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nombreMedicamento,
                    style: GoogleFonts.rubik(
                      fontSize: 16,
                      color: GerenaColors.textTertiaryColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${item.precioActual.toStringAsFixed(2)}',
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: GerenaColors.textTertiaryColor,
                        ),
                      ),
                      if (item.precioAnterior > item.precioActual) ...[
                        SizedBox(width: 8),
                        Text(
                          '\$${item.precioAnterior.toStringAsFixed(2)}',
                          style: GoogleFonts.rubik(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 8),
                  if (item.descripcion != null && item.descripcion!.isNotEmpty)
                    Text(
                      item.nombreMedicamento,
                      style: GoogleFonts.rubik(
                        fontSize: 12,
                        color: GerenaColors.textTertiaryColor,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (item.sinStock)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Sin stock',
                        style: GoogleFonts.rubik(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    wishlistController.removeFromWishlist(item.medicamentoId);
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/icons/guardar.png',
                      width: 16,
                      height: 16,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.grey[600],
                        );
                      },
                    ),
                  ),
                ),
                
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width > 600 ? 40.0 : 16.0,
                  ),
                  child: simpleCounter(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}