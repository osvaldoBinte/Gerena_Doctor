import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/simple_counter.dart';
import 'package:gerena/features/marketplace/domain/entities/addresses/addresses_entity.dart';
import 'package:gerena/features/marketplace/presentation/page/addresses/addresses_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/addresses/getaddress_/address_selector_widget.dart';
import 'package:gerena/features/marketplace/presentation/page/shopping/shopping_cart_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
import 'package:gerena/features/marketplace/presentation/page/widget/image_placeholder_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPageContent extends StatefulWidget {
  const CartPageContent({Key? key}) : super(key: key);

  @override
  State<CartPageContent> createState() => _CartPageContentState();
}

class _CartPageContentState extends State<CartPageContent> {
  late final ShoppingCartController cartController;
  late final ShopNavigationController navigationController;
  late final AddressesController addressesController;

  @override
  void initState() {
    super.initState();
    cartController = Get.find<ShoppingCartController>();
    navigationController = Get.find<ShopNavigationController>();
    addressesController = Get.find<AddressesController>();

    ever(addressesController.selectedAddress, (AddressesEntity? address) {
      if (address != null) {
        cartController.selectAddress(address.id.toString());
        print('📍 Dirección sincronizada en cart controller: ${address.id}');
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartController.loadAvailablePoints();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: 16),
                Text(
                  'Tu carrito está vacío',
                  style: GoogleFonts.rubik(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: GerenaColors.textTertiaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Agrega productos para continuar',
                  style: GoogleFonts.rubik(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: GetPlatform.isMobile
                      ? () => Get.offAllNamed(RoutesNames.categoryById)
                      : () => navigationController.navigateToStore(),
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text('IR A LA TIENDA'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GerenaColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
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
              horizontal:
                  MediaQuery.of(context).size.width > 600 ? 40.0 : 16.0,
            ),
            child: Column(
              children: [
                // ── Header ──────────────────────────────────────────
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: GetPlatform.isMobile
                          ? () => Get.offAllNamed(RoutesNames.categoryById)
                          : () => navigationController.navigateToStore(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: GerenaColors.secondaryColor,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8.0),
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

                // ── Body Card ────────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width > 600
                          ? 50.0
                          : 0.0,
                      vertical: MediaQuery.of(context).size.width > 600
                          ? 10.0
                          : 8.0,
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
                              // ── Productos ──────────────────────────
                              Column(
                                children: [
                                  if (response != null)
                                    ...response.itenms
                                        .map((item) => Column(
                                              children: [
                                                _buildCartItem(
                                                  item.nombreMedicamento,
                                                  item.alerta ?? '',
                                                  item.imagen ?? '',
                                                  '\$${item.precioActual.toStringAsFixed(2)} MXN',
                                                  medicamentoId:
                                                      item.medicamentoId,
                                                  cantidad:
                                                      item.cantidadSolicitada,
                                                  hasDiscount:
                                                      item.precioAnterior >
                                                          item.precioActual,
                                                  originalPrice:
                                                      item.precioAnterior >
                                                              item.precioActual
                                                          ? '\$${item.precioAnterior.toStringAsFixed(2)} MXN'
                                                          : null,
                                                  sinStock: item.sinStock,
                                                  oferta: item.oferta ?? false,
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            ))
                                        .toList(),
                                  const Divider(),
                                ],
                              ),
                              const SizedBox(height: 30),

                              // ── Dirección ──────────────────────────
                              _buildSection('DIRECCIÓN DE ENTREGA'),
                              const SizedBox(height: 15),
                              AddressSelectorWidget(
                                addressesController: addressesController,
                                onAddressSelected: (address) {
                                  cartController
                                      .selectAddress(address.id.toString());
                                  print(
                                      '📍 Dirección sincronizada: ${address.id}');
                                },
                              ),
                              const SizedBox(height: 30),

                              // ── Puntos ─────────────────────────────
                              Obx(() {
                                final points =
                                    cartController.availablePoints.value;
                                if (points <= 0) return const SizedBox.shrink();

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSection('USAR PUNTOS'),
                                    const SizedBox(height: 15),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey[300]!),
                                        borderRadius: BorderRadius.circular(8),
                                        color: GerenaColors
                                            .colorSubsCardBackground,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.monetization_on,
                                                color: GerenaColors.primaryColor,
                                                size: 24,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Puntos disponibles',
                                                      style: GoogleFonts.rubik(
                                                        fontSize: 14,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                    Text(
                                                      '$points puntos',
                                                      style: GoogleFonts.rubik(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: GerenaColors
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Obx(() => Switch(
                                                    value: cartController
                                                        .usePoints.value,
                                                    onChanged: (value) =>
                                                        cartController
                                                            .toggleUsePoints(
                                                                value),
                                                    activeColor: GerenaColors
                                                        .primaryColor,
                                                  )),
                                            ],
                                          ),
                                          Obx(() {
                                            if (!cartController.usePoints.value) {
                                              return const SizedBox.shrink();
                                            }
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 16),
                                                const Divider(),
                                                const SizedBox(height: 16),
                                                Text(
                                                  '¿Cuántos puntos deseas usar?',
                                                  style: GoogleFonts.rubik(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: GerenaColors
                                                        .textPrimaryColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextField(
                                                        keyboardType:
                                                            TextInputType.number,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Puntos a usar',
                                                          border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(8),
                                                          ),
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 12,
                                                            vertical: 12,
                                                          ),
                                                          suffixText: 'pts',
                                                        ),
                                                        onChanged: (value) {
                                                          final p = int.tryParse(
                                                                  value) ??
                                                              0;
                                                          cartController
                                                              .updatePointsToUse(
                                                                  p);
                                                        },
                                                        controller:
                                                            TextEditingController(
                                                          text: cartController
                                                              .pointsToUse.value
                                                              .toString(),
                                                        )..selection =
                                                                TextSelection.fromPosition(
                                                                    TextPosition(
                                                                        offset: cartController
                                                                            .pointsToUse
                                                                            .value
                                                                            .toString()
                                                                            .length)),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          cartController
                                                              .updatePointsToUse(
                                                                  cartController
                                                                      .availablePoints
                                                                      .value),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            GerenaColors
                                                                .primaryColor,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 16,
                                                          vertical: 12,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Máximo',
                                                        style: GoogleFonts.rubik(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    color: GerenaColors
                                                        .primaryColor
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(8),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.info_outline,
                                                        size: 18,
                                                        color: GerenaColors
                                                            .primaryColor,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Obx(() => Text(
                                                              cartController
                                                                      .isCalculatingDiscount
                                                                      .value
                                                                  ? 'Calculando descuento...'
                                                                  : 'Usarás ${cartController.pointsToUse.value} puntos = -\$${cartController.pointsDiscount.value.toStringAsFixed(2)} MXN',
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                fontSize: 12,
                                                                color: GerenaColors
                                                                    .textPrimaryColor,
                                                              ),
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                  ],
                                );
                              }),

                              const SizedBox(height: 30),
                              Divider(color: GerenaColors.textTertiaryColor),
                              const SizedBox(height: 30),

                              // ── Facturación ────────────────────────
                              Obx(() => Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey[300]!),
                                      borderRadius: BorderRadius.circular(8),
                                      color:
                                          GerenaColors.colorSubsCardBackground,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.receipt_long,
                                          color: GerenaColors.primaryColor,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Facturación',
                                                style: GoogleFonts.rubik(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: GerenaColors
                                                      .textPrimaryColor,
                                                ),
                                              ),
                                              Text(
                                                cartController
                                                        .invoiceRequired.value
                                                    ? 'Se generará factura para este pedido'
                                                    : 'Sin factura',
                                                style: GoogleFonts.rubik(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Switch(
                                          value: cartController
                                              .invoiceRequired.value,
                                          onChanged: cartController
                                              .toggleInvoiceRequired,
                                          activeColor: GerenaColors.primaryColor,
                                        ),
                                      ],
                                    ),
                                  )),
                              const SizedBox(height: 30),

                              // ── Resumen ────────────────────────────
                              _buildSection('RESUMEN'),
                              const SizedBox(height: 15),

                              _buildSummaryItem(
                                'Subtotal',
                                response != null
                                    ? '\$${response.totalActual.toStringAsFixed(2)} MXN'
                                    : '0.00 MXN',
                              ),
                              Divider(color: GerenaColors.textTertiaryColor),

                              Obx(() {
                                if (!cartController.usePoints.value ||
                                    cartController.pointsDiscount.value <= 0) {
                                  return const SizedBox.shrink();
                                }
                                return Column(
                                  children: [
                                    _buildSummaryItem(
                                      'Descuento por puntos (${cartController.pointsToUse.value} pts)',
                                      '-${cartController.pointsDiscount.value.toStringAsFixed(2)} MXN',
                                      valueColor: GerenaColors.descuento,
                                    ),
                                    Divider(
                                        color: GerenaColors.textTertiaryColor),
                                  ],
                                );
                              }),

                              _buildSummaryItem(
                                'Gastos de envío',
                                response != null
                                    ? '\$${response.gastoEnvio.toStringAsFixed(2)} MXN'
                                    : '0.00 MXN',
                              ),
                              Divider(color: GerenaColors.textTertiaryColor),

                              _buildSummaryItem(
                                'IVA',
                                response != null
                                    ? '\$${response.iva.toStringAsFixed(2)} MXN'
                                    : '0.00 MXN',
                              ),
                              const Divider(height: 30),

                              // ── Total ──────────────────────────────
                              Obx(() => _buildTotalRow(
                                    'TOTAL:',
                                    '\$${cartController.finalTotal.toStringAsFixed(2)} MXN',
                                  )),
                              const SizedBox(height: 16),

                              // ── Botón confirmar ────────────────────
                              Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  height: 40,
                                  child: Obx(() => ElevatedButton(
                                        onPressed: response != null &&
                                                !cartController.isLoading.value &&
                                                !cartController
                                                    .isProcessingOrder.value &&
                                                cartController
                                                    .selectedAddressId
                                                    .value
                                                    .isNotEmpty
                                            ? () async => await cartController
                                                .confirmOrder()
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              GerenaColors.secondaryColor,
                                          foregroundColor: GerenaColors.cardColor,
                                          disabledBackgroundColor:
                                              Colors.grey[300],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                        ),
                                        child: cartController
                                                .isProcessingOrder.value
                                            ?  SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color?>(Colors.white),
                                                ),
                                              )
                                            : Text(
                                                'CONFIRMAR PEDIDO',
                                                style: GoogleFonts.rubik(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      )),
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

  // ── Helpers ────────────────────────────────────────────────────────────────

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
    bool oferta = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Opacity(
        opacity: sinStock ? 0.5 : 1.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(child: _buildProductImage(imagePath)),
                if (oferta && !sinStock)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_offer,
                              color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            'OFERTA',
                            style: GoogleFonts.rubik(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (oferta && !sinStock)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.red[700]!,
                                        Colors.red[500]!
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.local_offer,
                                          color: Colors.white, size: 12),
                                      const SizedBox(width: 4),
                                      Text(
                                        '¡EN OFERTA!',
                                        style: GoogleFonts.rubik(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Text(
                              title,
                              style: GoogleFonts.rubik(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: GerenaColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () =>
                            cartController.removeFromCart(medicamentoId),
                        tooltip: 'Eliminar producto',
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  if (description.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: sinStock
                            ? Colors.red.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: sinStock
                              ? Colors.red.withOpacity(0.3)
                              : Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            sinStock
                                ? Icons.error_outline
                                : Icons.warning_amber,
                            size: 16,
                            color: sinStock ? Colors.red : Colors.orange[700],
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              description,
                              style: GoogleFonts.rubik(
                                fontSize: 12,
                                color: sinStock
                                    ? Colors.red
                                    : Colors.orange[900],
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),

                  if (sinStock)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
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
                    ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                                    color: oferta
                                        ? Colors.red[700]
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                if (oferta)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _calculateDiscount(
                                            originalPrice, price),
                                        style: GoogleFonts.rubik(
                                          fontSize: 9,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
                      simpleCounter(
                        initialValue: cantidad,
                        onChanged: (newValue) =>
                            cartController.updateQuantity(medicamentoId, newValue),
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

  String _calculateDiscount(String originalPrice, String currentPrice) {
    try {
      final original =
          double.parse(originalPrice.replaceAll(RegExp(r'[^0-9.]'), ''));
      final current =
          double.parse(currentPrice.replaceAll(RegExp(r'[^0-9.]'), ''));
      if (original <= 0) return '';
      final discount = ((original - current) / original * 100).round();
      return '-$discount%';
    } catch (_) {
      return '';
    }
  }

  Widget _buildProductImage(String imagePath) {
    return NetworkImageWidget(
      imageUrl: imagePath,
      width: 80,
      height: 120,
      fit: BoxFit.contain,
    );
  }

  Widget _buildSection(String title) {
    return Text(
      title,
      style: GoogleFonts.rubik(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: GerenaColors.textTertiaryColor,
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, {Color? valueColor}) {
    final color = valueColor ?? GerenaColors.textTertiaryColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.rubik(color: color)),
          Text(value,
              style:
                  GoogleFonts.rubik(fontWeight: FontWeight.w500, color: color)),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          label,
          style: GoogleFonts.rubik(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: GerenaColors.textTertiaryColor,
          ),
        ),
        const SizedBox(width: 12),
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