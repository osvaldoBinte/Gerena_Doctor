import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/widgts.dart';
import 'package:gerena/features/marketplace/presentation/page/Category/category_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/Category/widget/half_cut_circle.dart';
import 'package:gerena/features/marketplace/presentation/page/wishlist/saved_products_content.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/mobil/widget/product_card_widget.dart'; // ✅ NUEVO
import 'package:gerena/features/marketplace/presentation/page/widget/floating_cart_button.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends GetView<CategoryController> {
  final RxBool showWishlist = false.obs;

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
              width: 200,
              child: GerenaColors.createSearchTextField(
                controller: controller.searchController,
                hintText: 'Buscar...', // ✅ Cambiado
                onChanged: (value) {
                  // El listener ya maneja esto
                },
                onSearchPressed: () {
                  // Opcional: búsqueda manual
                },
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Obx(() => Container(
                  padding: EdgeInsets.all(GerenaColors.paddingMedium),
                  color: showWishlist.value
                      ? GerenaColors.backgroundColor
                      : GerenaColors.backgroundColorfondo,
                  child: Row(
                    children: [
                      if (showWishlist.value) ...[
                        InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () {
                            showWishlist.value = false;
                          },
                          child: Container(
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
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: buildWishlistButton(
                          onTap: () {
                            showWishlist.toggle();
                          },
                          showShadow: showWishlist.value ? false : true,
                        ),
                      ),
                    ],
                  ),
                )),
                
                // ✅ NUEVO: Banner de resultados mejorado
                Obx(() {
                  if (controller.searchQuery.value.isEmpty) {
                    return SizedBox.shrink();
                  }
                  
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: GerenaColors.primaryColor.withOpacity(0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.search,
                              size: 18,
                              color: GerenaColors.primaryColor,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Buscando: "${controller.searchQuery.value}"',
                                style: GoogleFonts.rubik(
                                  fontSize: 13,
                                  color: GerenaColors.textPrimaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.grey[600],
                              ),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () {
                                controller.clearSearch();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                       // ✅ SOLUCIÓN 1: Hacer que el Row sea flexible
Row(
  children: [
    Flexible(
      child: _buildResultChip(
        icon: Icons.category,
        label: '${controller.filteredCategories.length} categorías',
        color: Colors.blue,
      ),
    ),
    SizedBox(width: 8),
    Flexible(
      child: Obx(() => _buildResultChip(
        icon: Icons.inventory_2,
        label: controller.isLoadingProducts.value 
            ? 'Buscando...' 
            : '${controller.medications.length} productos',
        color: Colors.green,
      )),
    ),
  ],
),
                      ],
                    ),
                  );
                }),
                
                Expanded(
                  child: Obx(() => showWishlist.value
                      ? SavedProductsContent(
                          onBackPressed: () => showWishlist.value = false,
                        )
                      : _buildMainContent()),
                ),
              ],
            ),
          ),
          
          FloatingCartButton(),
        ],
      ),
    );
  }

  // ✅ NUEVO: Chip para mostrar resultados
 // ✅ Y actualizar el widget del chip para que maneje el texto largo
Widget _buildResultChip({
  required IconData icon,
  required String label,
  required Color color,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        SizedBox(width: 4),
        Flexible( // ✅ AGREGADO
          child: Text(
            label,
            style: GoogleFonts.rubik(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            overflow: TextOverflow.ellipsis, // ✅ AGREGADO
            maxLines: 1, // ✅ AGREGADO
          ),
        ),
      ],
    ),
  );
}

  // ✅ NUEVO: Contenido principal que decide qué mostrar
  Widget _buildMainContent() {
    return Obx(() {
      if (controller.showingSearchResults.value && 
          controller.searchQuery.value.isNotEmpty) {
        return _buildSearchResults();
      }
      return _buildCategoriesView();
    });
  }

  // ✅ NUEVO: Vista de resultados de búsqueda
  Widget _buildSearchResults() {
    return Obx(() {
      final hasCategories = controller.filteredCategories.isNotEmpty;
      final hasProducts = controller.medications.isNotEmpty;
      final isLoading = controller.isLoadingProducts.value;

      if (!hasCategories && !hasProducts && !isLoading) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 80,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'No se encontraron resultados',
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: GerenaColors.textTertiaryColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Intenta con otra búsqueda',
                style: GoogleFonts.rubik(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  controller.clearSearch();
                },
                icon: Icon(Icons.clear),
                label: Text('Limpiar búsqueda'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: GerenaColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        );
      }

      return ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Sección de Categorías
          if (hasCategories) ...[
            _buildSectionHeader(
              icon: Icons.category,
              title: 'Categorías (${controller.filteredCategories.length})',
              color: Colors.blue,
            ),
            SizedBox(height: 12),
            _buildCategoryGrid(controller.filteredCategories),
            SizedBox(height: 24),
          ],

          // Sección de Productos
          if (isLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(
                  color: GerenaColors.primaryColor,
                ),
              ),
            )
          else if (hasProducts) ...[
            _buildSectionHeader(
              icon: Icons.inventory_2,
              title: 'Productos (${controller.medications.length})',
              color: Colors.green,
            ),
            SizedBox(height: 12),
            _buildProductsGrid(controller.medications),
          ],
        ],
      );
    });
  }

  // ✅ NUEVO: Header de sección
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.rubik(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: GerenaColors.textPrimaryColor,
          ),
        ),
      ],
    );
  }

  // ✅ NUEVO: Grid de categorías para búsqueda
  Widget _buildCategoryGrid(List categories) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: categories.map((category) {
        return InkWell(
          onTap: () => _navigateToCategory(category),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 160,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: GerenaColors.dividerColor,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: GerenaColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: (category.image != null && category.image!.isNotEmpty)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            category.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.category,
                                color: GerenaColors.primaryColor,
                                size: 30,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.category,
                          color: GerenaColors.primaryColor,
                          size: 30,
                        ),
                ),
                SizedBox(height: 8),
                Text(
                  category.category ?? 'Sin nombre',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                    fontSize: 12,
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
      }).toList(),
    );
  }

  // ✅ NUEVO: Grid de productos para búsqueda
// ✅ SOLUCIÓN: Usar el mismo patrón de GetMedicationsPage
Widget _buildProductsGrid(List medications) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final width = MediaQuery.of(context).size.width;

      int crossAxisCount = 2;
      if (width >= 1200) {
        crossAxisCount = 5;
      } else if (width >= 900) {
        crossAxisCount = 4;
      } else if (width >= 600) {
        crossAxisCount = 3;
      }

      return ListView.separated(
        shrinkWrap: true, // ✅ Importante para que funcione dentro de otro scroll
        physics: NeverScrollableScrollPhysics(), // ✅ Importante
        padding: const EdgeInsets.all(16.0),
        itemCount: (medications.length / crossAxisCount).ceil(),
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          color: GerenaColors.dividerColor,
        ),
        itemBuilder: (context, rowIndex) {
          final startIdx = rowIndex * crossAxisCount;
          final endIdx = (startIdx + crossAxisCount).clamp(
            0,
            medications.length,
          );
          final itemsInRow = endIdx - startIdx;

          return IntrinsicHeight( // ✅ Esto permite altura automática
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < itemsInRow; i++) ...[
                  Expanded(
                    child: ProductCardWidget(
                      medication: medications[startIdx + i],
                      showFavoriteButton: true,
                      showSaveIcon: true,
                    ),
                  ),
                  if (i < itemsInRow - 1)
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: GerenaColors.dividerColor,
                    ),
                ],
                if (itemsInRow < crossAxisCount)
                  ...List.generate(
                    crossAxisCount - itemsInRow,
                    (index) => Expanded(child: SizedBox()),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}
  Widget _buildCategoriesView() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: GerenaColors.primaryColor,
          ),
        );
      }

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

      if (controller.filteredCategories.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.category_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'No hay categorías disponibles',
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: GerenaColors.textTertiaryColor,
                ),
              ),
            ],
          ),
        );
      }

      return _buildCategoryGridWithLines(controller.filteredCategories);
    });
  }

  Widget _buildCategoryGridWithLines(List categories) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = MediaQuery.of(context).size.width;

        int crossAxisCount = 2;
        if (width >= 1200) {
          crossAxisCount = 5;
        } else if (width >= 900) {
          crossAxisCount = 4;
        } else if (width >= 600) {
          crossAxisCount = 3;
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: (categories.length / crossAxisCount).ceil(),
          separatorBuilder: (context, index) => Divider(
            height: 1,
            thickness: 1,
            color: GerenaColors.dividerColor,
          ),
          itemBuilder: (context, rowIndex) {
            final startIdx = rowIndex * crossAxisCount;
            final endIdx = (startIdx + crossAxisCount).clamp(
              0,
              categories.length,
            );
            final itemsInRow = endIdx - startIdx;

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int i = 0; i < itemsInRow; i++) ...[
                    Expanded(
                      child: _buildCategoryCard(categories[startIdx + i]),
                    ),
                    if (i < itemsInRow - 1)
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: GerenaColors.dividerColor,
                      ),
                  ],
                  if (itemsInRow < crossAxisCount)
                    ...List.generate(
                      crossAxisCount - itemsInRow,
                      (index) => Expanded(child: SizedBox()),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryCard(dynamic category) {
    return GestureDetector(
      onTap: () => _navigateToCategory(category),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PhysicalShape(
              clipper: BottomFlatClipper(),
              color: GerenaColors.backgroundColor,
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.3),
              child: Container(
                width: 120,
                height: 120,
                padding: const EdgeInsets.all(15),
                child: (category.image != null && category.image!.isNotEmpty)
                    ? Image.network(
                        category.image!,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: GerenaColors.primaryColor,
                              strokeWidth: 2,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.category,
                            color: GerenaColors.primaryColor,
                            size: 40,
                          );
                        },
                      )
                    : Icon(
                        Icons.category,
                        color: GerenaColors.primaryColor,
                        size: 40,
                      ),
              ),
            ),
            
            SizedBox(height: 8),
            
            Text(
              category.category ?? 'Sin nombre',
              textAlign: TextAlign.center,
              style: GoogleFonts.rubik(
                fontSize: 13,
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
  }

  void _navigateToCategory(dynamic category) {
    Get.toNamed(
      RoutesNames.categoryById,
      arguments: {
        'categoryName': category.category,
      },
    );
  }
}