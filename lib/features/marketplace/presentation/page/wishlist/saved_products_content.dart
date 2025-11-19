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
                
                // ✅ Agrupa por categoria
                final Map<String, List<dynamic>> productsByCategory = {};

                for (var item in response.itenms) {
                  final category = item.categoria?.isNotEmpty == true 
                      ? item.categoria! 
                      : 'Sin Categoría';
                  
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
            Expanded(
              child: Text(
                '-$categoryName ',
                style: GoogleFonts.rubik(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: GerenaColors.textTertiaryColor,
                ),
              ),
            ),
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
          // ✅ IMAGEN DEL PRODUCTO
          _buildProductImage(item.imagen),
          
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
                  
                  // ✅ MOSTRAR ALERTA SI EXISTE
                  if (item.alerta != null && item.alerta!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: item.sinStock 
                            ? Colors.red.withOpacity(0.1) 
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: item.sinStock 
                              ? Colors.red.withOpacity(0.3) 
                              : Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.sinStock ? Icons.error_outline : Icons.warning_amber,
                            size: 14,
                            color: item.sinStock ? Colors.red : Colors.orange[700],
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item.alerta!,
                              style: GoogleFonts.rubik(
                                fontSize: 11,
                                color: item.sinStock ? Colors.red : Colors.orange[900],
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Badge adicional de sin stock
                  if (item.sinStock)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'SIN STOCK',
                        style: GoogleFonts.rubik(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
                simpleCounter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Método para construir la imagen del producto
  Widget _buildProductImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
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
      );
    }

    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          bottomLeft: Radius.circular(4),
        ),
        child: Image.network(
          imagePath,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
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
            );
          },
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(4),
        bottomLeft: Radius.circular(4),
      ),
      child: Image.asset(
        imagePath,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
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
          );
        },
      ),
    );
  }
}