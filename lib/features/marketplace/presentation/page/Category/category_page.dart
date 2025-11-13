import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/widgts.dart';
import 'package:gerena/features/marketplace/presentation/page/Category/category_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/wishlist/saved_products_content.dart';
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

      if (controller.categories.isEmpty) {
        return Center(
          child: Text(
            'No hay categorías disponibles',
            style: GoogleFonts.rubik(fontSize: 16),
          ),
        );
      }

      return _buildCategoryGridWithLines(controller.categories);
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
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (category.image != null && category.image!.isNotEmpty)
                ? Image.network(
                    category.image!,
                    width: 70,
                    height: 70,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 70,
                        height: 70,
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
                      return _buildPlaceholderIcon(70);
                    },
                  )
                : _buildPlaceholderIcon(70),
            SizedBox(height: 12),
            Text(
              category.category ?? 'Sin nombre',
              textAlign: TextAlign.center,
              style: GoogleFonts.rubik(
                fontSize: 14,
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
    Get.toNamed(
      RoutesNames.categoryById,
      arguments: {
        'categoryName': category.category,
      },
    );
  }
}