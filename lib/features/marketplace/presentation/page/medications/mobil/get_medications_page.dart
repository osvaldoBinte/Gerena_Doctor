import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/widgts.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/get_medications_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/mobil/widget/product_card_widget.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/floating_cart_button.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GetMedicationsPage extends GetView<GetMedicationsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorFondo,
      appBar: AppBar(
        backgroundColor: GerenaColors.backgroundColorFondo,
        elevation: 4,
        shadowColor: GerenaColors.shadowColor,
        automaticallyImplyLeading: false,
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
                hintText: 'Buscar productos...',
                onSearchPressed: () {
                  if (controller.searchController.text.isNotEmpty) {
                    controller.searchMedications(controller.searchController.text);
                  }
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
                Container(
                  padding: EdgeInsets.all(GerenaColors.paddingMedium),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          controller.clearSearch();
                          Get.back();
                          Get.offAllNamed(RoutesNames.homePage);
                        },
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
                            Obx(() => Text(
                                  controller.currentCategoryName.value.toUpperCase(),
                                  style: GoogleFonts.rubik(
                                    color: GerenaColors.textPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Obx(() {
                        if (controller.searchQuery.value.isNotEmpty) {
                          return TextButton.icon(
                            onPressed: controller.clearSearch,
                            icon: Icon(
                              Icons.clear,
                              size: 18,
                              color: GerenaColors.primaryColor,
                            ),
                            label: Text(
                              'Limpiar',
                              style: GoogleFonts.rubik(
                                color: GerenaColors.primaryColor,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      }),
                    ],
                  ),
                ),

                Divider(height: 2, color: GerenaColors.dividerColor),

                Expanded(
                  child: Obx(() {
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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                controller.errorMessage.value,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.rubik(fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: controller.retryFetch,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: GerenaColors.primaryColor,
                              ),
                              child: Text('Reintentar'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (controller.medications.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 60,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                controller.searchQuery.value.isNotEmpty
                                    ? 'No se encontraron productos con "${controller.searchQuery.value}"'
                                    : 'No hay productos en esta categoría',
                                style: GoogleFonts.rubik(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

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
                          itemCount: (controller.medications.length / crossAxisCount).ceil(),
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            thickness: 1,
                            color: GerenaColors.dividerColor,
                          ),
                          itemBuilder: (context, rowIndex) {
                            final startIdx = rowIndex * crossAxisCount;
                            final endIdx = (startIdx + crossAxisCount).clamp(
                              0,
                              controller.medications.length,
                            );
                            final itemsInRow = endIdx - startIdx;

                            return IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  for (int i = 0; i < itemsInRow; i++) ...[
                                    Expanded(
                                      child: ProductCardWidget(
                                        medication: controller.medications[startIdx + i],
                                        onFavoritePressed: () {
                                          final med = controller.medications[startIdx + i];
                                          Get.snackbar(
                                            'Favoritos',
                                            '${med.name} agregado a favoritos',
                                            snackPosition: SnackPosition.BOTTOM,
                                            duration: const Duration(seconds: 2),
                                          );
                                        },
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
                  }),
                ),
              ],
            ),
          ),
          
          FloatingCartButton(),
        ],
      ),
    );
  }
}