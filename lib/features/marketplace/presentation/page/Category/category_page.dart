import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/widgts.dart';
import 'package:gerena/features/marketplace/presentation/page/Category/category_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends GetView<CategoryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorFondo,
      appBar: AppBar(
        backgroundColor: GerenaColors.backgroundColorFondo,
        elevation: 4,
        shadowColor: GerenaColors.shadowColor,
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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(GerenaColors.paddingMedium),
              child: buildWishlistButton(),
            ),
            Expanded(
              child: Obx(() {
                // Estado de carga
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: GerenaColors.primaryColor,
                    ),
                  );
                }
                
                // Estado de error
                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red,
                        ),
                        SizedBox(height: 16),
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rubik(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: controller.retryFetch,
                          child: Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }
                
                // Lista vacía
                if (controller.categories.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay categorías disponibles',
                      style: GoogleFonts.rubik(fontSize: 16),
                    ),
                  );
                }
                
                // Grid con categorías
                return _buildCategoryGridWithLines(controller.categories);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGridWithLines(List categories) {
    final int crossAxisCount = 2;
    final int rowCount = (categories.length / crossAxisCount).ceil();
    
    return Column(
      children: List.generate(rowCount, (rowIndex) {
        return Expanded(
          child: IntrinsicHeight(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: List.generate(crossAxisCount, (colIndex) {
                      final index = rowIndex * crossAxisCount + colIndex;
                      
                      return Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: index < categories.length
                                  ? _buildCategoryCard(categories[index])
                                  : Container(),
                            ),
                            if (colIndex < crossAxisCount - 1)
                              Container(
                                width: 1,
                                color: GerenaColors.dividerColor,
                              ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                if (rowIndex < rowCount - 1)
                  Container(
                    height: 1,
                    color: GerenaColors.dividerColor,
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCategoryCard(dynamic category) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        final double imageSize = availableWidth > 150 ? 70 : 35;
        final double fontSize = availableWidth > 150 ? 14 : 9;
        final double spacing = 12.0;
        
        return GestureDetector(
          onTap: () => _navigateToCategory(category),
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (category.image != null && category.image!.isNotEmpty)
                    ? Image.network(
                        category.image!,
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: imageSize,
                            height: imageSize,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                color: GerenaColors.primaryColor,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderIcon(imageSize);
                        },
                      )
                    : _buildPlaceholderIcon(imageSize),
                
                SizedBox(height: spacing),
                
                Text(
                  category.category ?? 'Sin nombre',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: GerenaColors.textPrimaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholderIcon(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: GerenaColors.primaryColor,
        borderRadius: GerenaColors.smallBorderRadius,
      ),
      child: Icon(
        Icons.category,
        color: Colors.white,
        size: size * 0.5,
      ),
    );
  }

  void _navigateToCategory(dynamic category) {
    // Pasa el nombre de la categoría a la siguiente página
    Get.toNamed(
      RoutesNames.categoryById,
      arguments: {
        'categoryName': category.category,
      },
    );
  }
}