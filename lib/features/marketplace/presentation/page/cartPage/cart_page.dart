import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/simple_counter.dart';
import 'package:gerena/features/marketplace/presentation/page/cartPage/shopping_cart_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPageContent extends StatelessWidget {
  CartPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<ShoppingCartController>();
    final navigationController = Get.find<ShopNavigationController>();

    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorfondo,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: GerenaColors.backgroundColorFondo,
          elevation: 4,
          shadowColor: GerenaColors.shadowColor,
        ),
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: GerenaColors.primaryColor,
            ),
          );
        }

        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 100,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'Tu carrito está vacío',
                  style: GoogleFonts.rubik(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: GerenaColors.textTertiaryColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Agrega productos para continuar',
                  style: GoogleFonts.rubik(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: navigationController.navigateToStore,
                  icon: Icon(Icons.shopping_bag),
                  label: Text('IR A LA TIENDA'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GerenaColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final response = cartController.cartResponse.value;

        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 10000),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 600 ? 40.0 : 16.0,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: GetPlatform.isMobile ? Get.back:navigationController.navigateToStore,
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
                          Text(
                            'CONFIRMAR PEDIDO',
                            style: GoogleFonts.rubik(
                              color: GerenaColors.textPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          MediaQuery.of(context).size.width > 600 ? 50.0 : 0.0,
                      vertical:
                          MediaQuery.of(context).size.width > 600 ? 10.0 : 8.0,
                    ),
                    child: Card(
                      elevation: GetPlatform.isMobile ? 0 : 2,
                      color: GetPlatform.isMobile
                          ? GerenaColors.backgroundColorfondo
                          : GerenaColors.colorSubsCardBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width > 600 ? 50.0 : 16.0,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Column(
                                children: [
                                  if (response != null)
                                    ...response.itenms
                                        .map((item) => Column(
                                              children: [
                                                _buildCartItem(
                                                  item.nombreMedicamento,
                                                  item.descripcion ?? '',
                                                  "",
                                                  "${item.precioActual.toStringAsFixed(2)} MXN",
                                                  medicamentoId:
                                                      item.medicamentoId,
                                                  cantidad:
                                                      item.cantidadSolicitada,
                                                  hasDiscount:
                                                      item.precioAnterior >
                                                          item.precioActual,
                                                  originalPrice: item
                                                              .precioAnterior >
                                                          item.precioActual
                                                      ? "${item.precioAnterior.toStringAsFixed(2)} MXN"
                                                      : null,
                                                  sinStock: item.sinStock,
                                                  cartController:
                                                      cartController,
                                                ),
                                                SizedBox(height: 10),
                                              ],
                                            ))
                                        .toList(),
                                  const Divider(),
                                ],
                              ),

                              const SizedBox(height: 30),

                              _buildSection("DIRECCIÓN DE ENTREGA"),

                              const SizedBox(height: 15),

                              _buildSelectedAddress(
                                "Juan Pedro González Pérez +52 3333303333",
                                "Col. Providencia, Av. Lorem ipsum #3050, Guadalajara, Jalisco, México",
                                isSelected: true,
                              ),

                              const SizedBox(height: 10),

                              _buildAddressSelector(
                                "En sucursal",
                                "Col. Lorem ipsum Av. Lorem ipsum #3050, Guadalajara, Jalisco, México",
                              ),

                              const SizedBox(height: 30),

                              _buildSection("MÉTODO DE PAGO"),

                              const SizedBox(height: 15),

                              Align(
                                alignment: Alignment.centerLeft,
                                child:
                                    _buildPaymentMethod("5545 3******** 9905"),
                              ),

                              const SizedBox(height: 30),
                              Divider(color: GerenaColors.textTertiaryColor),
                              const SizedBox(height: 30),

                              _buildSection("RESUMEN"),

                              const SizedBox(height: 15),

                              _buildSummaryItem(
                                  "Subtotal",
                                  response != null
                                      ? response.totalActual.toString()
                                      : "0.00 MXN"),
                              Divider(color: GerenaColors.textTertiaryColor),
                              _buildSummaryItem(
                                  "Descuentos y promociones", "-0.00 MXN"),
                              Divider(color: GerenaColors.textTertiaryColor),
                              _buildSummaryItem("*IVA", "0.00 MXN"),
                              Divider(color: GerenaColors.textTertiaryColor),
                              _buildSummaryItem(
                                  "Gastos de envío", "250.00 MXN"),
                              Divider(color: GerenaColors.textTertiaryColor),
                              _buildSummaryItem(
                                  "Puntos acumulados", "+0.00 MXN"),

                              const Divider(height: 30),

                              _buildTotalRow(
                                  "TOTAL:",
                                  response != null
                                      ? response.totalActual.toString()
                                      : "0.00 MXN"),

                              const SizedBox(height: 100),

                              // BOTÓN CONFIRMAR COMPRA
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: response != null &&
                                            !cartController.isLoading.value
                                        ? () {
                                            // TODO: Implementar lógica de confirmar compra
                                            print('Confirmar compra');
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          GerenaColors.secondaryColor,
                                      foregroundColor: GerenaColors.cardColor,
                                      disabledBackgroundColor: Colors.grey[300],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                    ),
                                    child: Text(
                                      "CONFIRMAR COMPRA",
                                      style: GoogleFonts.rubik(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
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
      }),
    );
  }

  Widget _buildCartItem(
    String title,
    String description,
    String imagePath,
    String price, {
    required int medicamentoId,
    required int cantidad,
    bool hasDiscount = false,
    String? originalPrice,
    bool sinStock = false,
    required ShoppingCartController cartController,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Opacity(
        opacity: sinStock ? 0.5 : 1.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                imagePath,
                width: 80,
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 120,
                    color: Colors.grey[200],
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.rubik(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: GerenaColors.primaryColor,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () =>
                            cartController.removeFromCart(medicamentoId),
                        tooltip: 'Eliminar producto',
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // DESCRIPCIÓN
                  if (description.isNotEmpty)
                    Text(
                      description,
                      style: GoogleFonts.rubik(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                  // INDICADOR DE SIN STOCK
                  if (sinStock)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        'SIN STOCK',
                        style: GoogleFonts.rubik(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  const SizedBox(height: 5),

                  // PRECIO Y CONTADOR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // PRECIO
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hasDiscount && originalPrice != null)
                            Row(
                              children: [
                                Text(
                                  originalPrice,
                                  style: GoogleFonts.rubik(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  price,
                                  style: GoogleFonts.rubik(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              price,
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: GerenaColors.primaryColor,
                              ),
                            ),
                        ],
                      ),

                      // CONTADOR
                      simpleCounter(
                        initialValue: cantidad,
                        onChanged: (newValue) {
                          cartController.updateQuantity(
                              medicamentoId, newValue);
                        },
                        enabled: !sinStock,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildSection(String title) {
  return GestureDetector(
    onTap: () {
      Get.find<ShopNavigationController>().navigateToPaymentCards();
      Get.to(() => GlobalShopInterface());
    },
    child: Text(
      title,
      style: GoogleFonts.rubik(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: GerenaColors.textTertiaryColor,
      ),
    ),
  );
}

  Widget _buildSelectedAddress(String name, String address,
      {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          if (isSelected)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                'assets/icons/check.png',
                width: 30,
                height: 30,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.check_circle,
                      color: GerenaColors.primaryColor, size: 30);
                },
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  address,
                  style: GoogleFonts.rubik(
                    fontSize: 13,
                    color: GerenaColors.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: Image.asset(
              'assets/icons/edit.png',
              width: 30,
              height: 30,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.edit, color: Colors.grey, size: 30);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddressSelector(String title, String address) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          const SizedBox(width: 70),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.textPrimaryColor,
                  ),
                ),
                Text(
                  address,
                  style: GoogleFonts.rubik(
                    fontSize: 13,
                    color: GerenaColors.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String number) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/visa.png',
            width: 30,
            height: 30,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.credit_card, color: Colors.grey, size: 30);
            },
          ),
          const SizedBox(width: 10),
          Text(
            number,
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w500,
              color: GerenaColors.textPrimaryColor,
            ),
          ),
          const SizedBox(width: 15),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    final Color valueColor = GerenaColors.textTertiaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.rubik(
              color: GerenaColors.textTertiaryColor,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(),
        ),
        Text(
          label,
          style: GoogleFonts.rubik(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: GerenaColors.textTertiaryColor,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Text(
          value,
          style: GoogleFonts.rubik(
            fontSize: 18,
            color: GerenaColors.textTertiaryColor,
          ),
        ),
      ],
    );
  }
}
