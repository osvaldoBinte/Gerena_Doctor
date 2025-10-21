import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/widgts.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/get_medications_controller.dart';
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
              width: 140,
              child: GerenaColors.createSearchContainer(
                height: 26,
                heightcontainer: 15,
                iconSize: 18,
                onTap: () {
                  _showSearchDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header con nombre de categoría
            Container(
              padding: EdgeInsets.all(GerenaColors.paddingMedium),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: Get.back,
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
                ],
              ),
            ),

            Divider(height: 2, color: GerenaColors.dividerColor),

            // Contenido con productos
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

                // Lista vacía
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
                        Text(
                          'No hay productos en esta categoría',
                          style: GoogleFonts.rubik(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Grid de productos con líneas divisorias
                return _buildGridWithLines();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridWithLines() {
    final int crossAxisCount = 2;
    final int rowCount = (controller.medications.length / crossAxisCount).ceil();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: List.generate(rowCount * 2 - 1, (index) {
          // Índices pares son filas de productos, impares son divisores
          if (index.isOdd) {
            // Divisor horizontal
            return Container(
              height: 1,
              color: GerenaColors.dividerColor,
              margin: const EdgeInsets.symmetric(vertical: 8),
            );
          }

          // Fila de productos
          final int rowIndex = index ~/ 2;
          final int startIndex = rowIndex * crossAxisCount;
          final int itemsInRow = (controller.medications.length - startIndex).clamp(0, crossAxisCount);

          // Generar lista de widgets: productos intercalados con divisores verticales
          List<Widget> rowChildren = [];
          for (int i = 0; i < itemsInRow; i++) {
            final int itemIndex = startIndex + i;
            final medication = controller.medications[itemIndex];
            
            rowChildren.add(
              Expanded(
                child: _buildProductCard(medication),
              ),
            );

            // Agregar divisor vertical si no es el último item
            if (i < itemsInRow - 1) {
              rowChildren.add(
                Container(
                  width: 1,
                  color: GerenaColors.dividerColor,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
              );
            }
          }

          // Si solo hay un item en la fila (número impar), agregar espacio vacío
          if (itemsInRow == 1) {
            rowChildren.add(Expanded(child: SizedBox.shrink()));
          }

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: rowChildren,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProductCard(dynamic medication) {
    return GestureDetector(
      onTap: () {
        // Navegar a detalle del producto
        Get.toNamed(
          '/product-detail', // Ajusta tu ruta
          arguments: {'productId': medication.id},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: GerenaColors.cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        margin: const EdgeInsets.all(8.0), // Espaciado alrededor de cada card
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
                    child: Hero(
                      tag: 'product-${medication.id}',
                      child: (medication.imagen != null && medication.imagen!.isNotEmpty)
                          ? Image.network(
                              medication.imagen!,
                              height: 120,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: 120,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                      color: GerenaColors.primaryColor,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/productoenventa.png',
                                  height: 120,
                                  fit: BoxFit.contain,
                                );
                              },
                            )
                          : Image.asset(
                              'assets/productoenventa.png',
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/icons/guardar.png',
                        width: 16,
                        height: 16,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  
                  // Badge de estado inactivo
                  if (!medication.activo)
                    Positioned(
                      top: 5,
                      left: 5,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'INACTIVO',
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
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
                          medication.name,
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: GerenaColors.primaryColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite_border, color: Colors.grey),
                        onPressed: () {
                          // Agregar a favoritos
                        },
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),

                  Text(
                    '\$${medication.price.toStringAsFixed(2)} MXN',
                    style: GoogleFonts.rubik(
                      fontSize: 12,
                      color: GerenaColors.textDarkColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  if (medication.stock > 0)
                    Text(
                      'Stock: ${medication.stock}',
                      style: GoogleFonts.rubik(
                        fontSize: 10,
                        color: Colors.green,
                      ),
                    )
                  else
                    Text(
                      'Sin stock',
                      style: GoogleFonts.rubik(
                        fontSize: 10,
                        color: Colors.red,
                      ),
                    ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(
                          '/product-detail',
                          arguments: {'productId': medication.id},
                        );
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                          color: GerenaColors.buttoninformation,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'VER INFORMACIÓN',
                          style: GoogleFonts.rubik(
                            color: GerenaColors.textLightColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final controller = Get.find<GetMedicationsController>();
    final searchController = TextEditingController(text: controller.searchQuery.value);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Buscar Productos'),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Nombre del producto...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            controller.searchMedications(value);
            Get.back();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.clearSearch();
              Get.back();
            },
            child: Text('Limpiar'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.searchMedications(searchController.text);
              Get.back();
            },
            child: Text('Buscar'),
          ),
        ],
      ),
    );
  }
}