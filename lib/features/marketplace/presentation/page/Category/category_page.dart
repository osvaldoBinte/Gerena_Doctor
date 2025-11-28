import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/widgts.dart';
import 'package:gerena/features/marketplace/presentation/page/Category/category_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/Category/widget/half_cut_circle.dart';
import 'package:gerena/features/marketplace/presentation/page/wishlist/saved_products_content.dart';
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
                hintText: 'Buscar categoría',
                onChanged: (value) {
                  controller.filterCategories(value);
                },
                onSearchPressed: () {
                 
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
                
                Obx(() {
                  if (controller.searchQuery.value.isEmpty) {
                    return SizedBox.shrink();
                  }
                  
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: GerenaColors.primaryColor.withOpacity(0.1),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: 18,
                          color: GerenaColors.primaryColor,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Buscando: "${controller.searchQuery.value}" - ${controller.filteredCategories.length} resultado(s)',
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
                  );
                }),
                
                Expanded(
                  child: Obx(() => showWishlist.value
                      ? SavedProductsContent(
                          onBackPressed: () => showWishlist.value = false,
                        )
                      : _buildCategoriesView()),
                ),
              ],
            ),
          ),
          
          FloatingCartButton(),
        ],
      ),
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
                controller.searchQuery.value.isEmpty 
                    ? Icons.category_outlined 
                    : Icons.search_off,
                size: 80,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                controller.searchQuery.value.isEmpty
                    ? 'No hay categorías disponibles'
                    : 'No se encontraron categorías',
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: GerenaColors.textTertiaryColor,
                ),
              ),
              if (controller.searchQuery.value.isNotEmpty) ...[
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