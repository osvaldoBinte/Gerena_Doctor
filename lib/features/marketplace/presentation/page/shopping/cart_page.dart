import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/simple_counter.dart';
import 'package:gerena/features/marketplace/domain/entities/addresses/addresses_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/payment/payment_method_entity.dart';
import 'package:gerena/features/marketplace/presentation/page/addresses/addresses_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/paymentcard/payment_cart_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/shopping/shopping_cart_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPageContent extends StatelessWidget {
  CartPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<ShoppingCartController>();
    final navigationController = Get.find<ShopNavigationController>();
    final paymentController = Get.find<PaymentCartController>();
    final addressesController = Get.find<AddressesController>(); // ✅ AGREGAR
  ever(addressesController.selectedAddress, (AddressesEntity? address) {
    if (address != null) {
      cartController.selectAddress(address.id.toString());
      print('📍 Dirección sincronizada en cart controller: ${address.id}');
    }
  });
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
                    onTap: GetPlatform.isMobile
    ? () => Get.offAllNamed(RoutesNames.categoryById)
    : () => navigationController.navigateToStore(),

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

      // ✅ INTEGRACIÓN DEL SELECTOR DE DIRECCIONES
      Obx(() {
        if (addressesController.isLoading.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircularProgressIndicator(
                color: GerenaColors.primaryColor,
              ),
            ),
          );
        }

        if (addressesController.errorMessage.value.isNotEmpty) {
          return Column(
            children: [
              Text(
                addressesController.errorMessage.value,
                style: GoogleFonts.rubik(
                  color: Colors.red,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () => addressesController.getAddresses(),
                icon: Icon(Icons.refresh),
                label: Text('Reintentar'),
              ),
            ],
          );
        }

        if (addressesController.addresses.isEmpty) {
          return Column(
            children: [
              Text(
                'No tienes direcciones guardadas',
                style: GoogleFonts.rubik(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () {
                  // TODO: Navegar a agregar dirección
                  // navigationController.navigateToAddAddress();
                },
                icon: Icon(Icons.add_location),
                label: Text('Agregar dirección'),
                style: TextButton.styleFrom(
                  foregroundColor: GerenaColors.primaryColor,
                ),
              ),
            ],
          );
        }

        final selectedAddress = addressesController.selectedAddress.value;
        
if (selectedAddress == null && addressesController.addresses.isNotEmpty) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final firstAddress = addressesController.addresses.first;
    addressesController.selectAddress(firstAddress);
    // ✅ Esperar a que se actualice antes de notificar al cart controller
    Future.delayed(Duration(milliseconds: 50), () {
      cartController.selectAddress(firstAddress.id.toString());
    });
  });
}

        return Column(
          children: [
            // Dirección seleccionada
            if (selectedAddress != null)
              _buildSelectedAddressFromEntity(
                selectedAddress,
                onEdit: () {
                  _showAddressSelector(context, addressesController);
                },
              ),

            const SizedBox(height: 10),

            // Botón para cambiar dirección
            if (addressesController.addresses.length > 1)
              InkWell(
                onTap: () => _showAddressSelector(context, addressesController),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.grey[600]),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          'Cambiar dirección de entrega',
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w500,
                            color: GerenaColors.textPrimaryColor,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
                              const SizedBox(height: 30),

                              _buildSection("MÉTODO DE PAGO"),

                              const SizedBox(height: 15),

                              // ✅ SECCIÓN DE MÉTODO DE PAGO CON SELECTOR
                              Obx(() {
                                if (paymentController.isLoading.value) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: CircularProgressIndicator(
                                        color: GerenaColors.primaryColor,
                                      ),
                                    ),
                                  );
                                }

                                if (paymentController.paymentMethods.isEmpty) {
                                  return Column(
                                    children: [
                                      Text(
                                        'No tienes tarjetas guardadas',
                                        style: GoogleFonts.rubik(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextButton.icon(
                                        onPressed: () {
                                         if (GetPlatform.isMobile) {
                                                    Get.offAllNamed(RoutesNames.paymentCardsPage,);

                                          } else {
                                            navigationController
                                              .navigateToPaymentCards();
                                          }
                                        },
                                        icon: Icon(Icons.add_card),
                                        label: Text('Agregar tarjeta'),
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              GerenaColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                // Obtener tarjeta seleccionada o usar la primera por defecto
                                final selectedId =
                                    cartController.selectedPaymentMethodId.value;
                                final selectedCard = selectedId.isNotEmpty
                                    ? paymentController.paymentMethods
                                        .firstWhereOrNull(
                                            (card) => card.id == selectedId)
                                    : null;

                                final displayCard = selectedCard ??
                                    paymentController.paymentMethods.first;

                                // Auto-seleccionar la primera tarjeta si no hay ninguna seleccionada
                                if (selectedId.isEmpty &&
                                    paymentController
                                        .paymentMethods.isNotEmpty) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    cartController
                                        .selectPaymentMethod(displayCard.id);
                                  });
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildPaymentMethod(
                                      paymentController.formatCardNumber(
                                        displayCard.last4,
                                        displayCard.brand,
                                      ),
                                      displayCard.brand,
                                      onTap: () {
                                        _showPaymentMethodSelector(
                                          context,
                                          paymentController,
                                          cartController,
                                        );
                                      },
                                    ),
                                    if (paymentController
                                            .paymentMethods.length >
                                        1)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          '+${paymentController.paymentMethods.length - 1} tarjeta(s) más',
                                          style: GoogleFonts.rubik(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              }),

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
                                  child: Obx(() => ElevatedButton(
                                        onPressed: response != null &&
                                                !cartController
                                                    .isLoading.value &&
                                                !cartController
                                                    .isProcessingPayment.value &&
                                                cartController
                                                    .selectedPaymentMethodId
                                                    .value
                                                    .isNotEmpty
                                            ? () async {
                                                await cartController
                                                    .confirmPurchase();
                                              }
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              GerenaColors.secondaryColor,
                                          foregroundColor:
                                              GerenaColors.cardColor,
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
                                                .isProcessingPayment.value
                                            ? SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<Color?>(Colors.white),
                                                ),
                                              )
                                            : Text(
                                                "CONFIRMAR COMPRA",
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

  // ✅ NUEVO: Selector de direcciones (similar al de métodos de pago)
  void _showAddressSelector(
    BuildContext context,
    AddressesController addressesController,
  ) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 600,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Selecciona una dirección',
                      style: GoogleFonts.rubik(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: GerenaColors.textPrimaryColor,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 16),

              Flexible(
                child: Obx(() {
                  return SingleChildScrollView(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: addressesController.addresses.length,
                      separatorBuilder: (context, index) => SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final address = addressesController.addresses[index];
                        final isSelected =
                            addressesController.selectedAddress.value?.id ==
                                address.id;

                        return _buildAddressOption(
                          address: address,
                          isSelected: isSelected,
                          onTap: () {
                            addressesController.selectAddress(address);
                            Get.back();
                          },
                        );
                      },
                    ),
                  );
                }),
              ),

              SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: () {
                  Get.back();
                  // TODO: Navegar a agregar dirección
                  // navigationController.navigateToAddAddress();
                },
                icon: Icon(Icons.add_location),
                label: Text('Agregar nueva dirección'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: GerenaColors.primaryColor,
                  side: BorderSide(color: GerenaColors.primaryColor),
                  minimumSize: Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  // ✅ NUEVO: Widget para cada opción de dirección
  Widget _buildAddressOption({
    required AddressesEntity address,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final fullAddress = '${address.street} ${address.exteriorNumber}'
        '${address.interiorNumber.isNotEmpty ? ', Int. ${address.interiorNumber}' : ''}, '
        '${address.neighborhood}, ${address.city}, ${address.state}, '
        'C.P. ${address.postalCode}';

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? GerenaColors.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? GerenaColors.primaryColor.withOpacity(0.05)
              : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              color: isSelected ? GerenaColors.primaryColor : Colors.grey[600],
              size: 40,
            ),
            SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.fullName,
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: GerenaColors.textPrimaryColor,
                    ),
                  ),
                  Text(
                    address.phone,
                    style: GoogleFonts.rubik(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    fullAddress,
                    style: GoogleFonts.rubik(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            if (isSelected)
              Icon(
                Icons.check_circle,
                color: GerenaColors.primaryColor,
                size: 28,
              )
            else
              Icon(
                Icons.radio_button_unchecked,
                color: Colors.grey[400],
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
  // ✅ NUEVO WIDGET: Construir dirección seleccionada desde AddressesEntity
  Widget _buildSelectedAddressFromEntity(
    AddressesEntity address, {
    VoidCallback? onEdit,
  }) {
    final fullAddress = '${address.street} ${address.exteriorNumber}'
        '${address.interiorNumber.isNotEmpty ? ', Int. ${address.interiorNumber}' : ''}, '
        '${address.neighborhood}, ${address.city}, ${address.state}, '
        'C.P. ${address.postalCode}';

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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset(
              'assets/icons/check.png',
              width: 30,
              height: 30,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.check_circle,
                  color: GerenaColors.primaryColor,
                  size: 30,
                );
              },
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${address.fullName} ${address.phone}',
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  fullAddress,
                  style: GoogleFonts.rubik(
                    fontSize: 13,
                    color: GerenaColors.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onEdit,
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              child: Image.asset(
                'assets/icons/edit.png',
                width: 30,
                height: 30,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.edit, color: Colors.grey, size: 30);
                },
              ),
            ),
          ),
        ],
      ),
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
    return Text(
      title,
      style: GoogleFonts.rubik(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: GerenaColors.textTertiaryColor,
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

  Widget _buildPaymentMethod(String displayText, String brand,
      {VoidCallback? onTap}) {
    String getCardIcon(String brand) {
      switch (brand.toLowerCase()) {
        case 'visa':
          return 'assets/visa.png';
        case 'mastercard':
          return 'assets/mastercard.png';
        case 'amex':
          return 'assets/amex.png';
        default:
          return 'assets/visa.png';
      }
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              getCardIcon(brand),
              width: 30,
              height: 30,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.credit_card, color: Colors.grey, size: 30);
              },
            ),
            const SizedBox(width: 10),
            Text(
              displayText,
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

  /// Mostrar diálogo para seleccionar método de pago
 void _showPaymentMethodSelector(
  BuildContext context,
  PaymentCartController paymentController,
  ShoppingCartController cartController,
) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 500, // Ancho máximo para desktop
          maxHeight: MediaQuery.of(context).size.height * 0.8, // Altura máxima
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Selecciona un método de pago',
                    style: GoogleFonts.rubik(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: GerenaColors.textPrimaryColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Get.back(),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Lista de tarjetas con scroll
            Flexible(
              child: Obx(() {
                return SingleChildScrollView(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: paymentController.paymentMethods.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final card = paymentController.paymentMethods[index];
                      final isSelected =
                          cartController.selectedPaymentMethodId.value == card.id;

                      return _buildPaymentCardOption(
                        card: card,
                        isSelected: isSelected,
                        paymentController: paymentController,
                        onTap: () {
                          cartController.selectPaymentMethod(card.id);
                          Get.back();
                        },
                      );
                    },
                  ),
                );
              }),
            ),

            SizedBox(height: 16),

            // Botón para agregar nueva tarjeta
            OutlinedButton.icon(
              onPressed: () {
                Get.back();
                if (GetPlatform.isMobile) {
                                                    Get.offAllNamed(RoutesNames.paymentCardsPage,);

                                          } else {
                                                          Get.find<ShopNavigationController>().navigateToPaymentCards();

                                          }
              },
              icon: Icon(Icons.add_card),
              label: Text('Agregar nueva tarjeta'),
              style: OutlinedButton.styleFrom(
                foregroundColor: GerenaColors.primaryColor,
                side: BorderSide(color: GerenaColors.primaryColor),
                minimumSize: Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true, // Permite cerrar tocando fuera del diálogo
  );
}
  /// Widget para cada opción de tarjeta en el selector
  Widget _buildPaymentCardOption({
    required PaymentMethodEntity card,
    required bool isSelected,
    required PaymentCartController paymentController,
    required VoidCallback onTap,
  }) {
    String getCardIcon(String brand) {
      switch (brand.toLowerCase()) {
        case 'visa':
          return 'assets/visa.png';
        case 'mastercard':
          return 'assets/mastercard.png';
        case 'amex':
          return 'assets/amex.png';
        default:
          return 'assets/visa.png';
      }
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? GerenaColors.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? GerenaColors.primaryColor.withOpacity(0.05)
              : Colors.white,
        ),
        child: Row(
          children: [
            // Icono de la tarjeta
            Image.asset(
              getCardIcon(card.brand),
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.credit_card, size: 40, color: Colors.grey);
              },
            ),
            SizedBox(width: 16),

            // Información de la tarjeta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paymentController.formatCardNumber(card.last4, card.brand),
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: GerenaColors.textPrimaryColor,
                    ),
                  ),
                  if (card.cardholderName != null)
                    Text(
                      card.cardholderName!,
                      style: GoogleFonts.rubik(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  Text(
                    'Vence ${card.expMonth.toString().padLeft(2, '0')}/${card.expYear}',
                    style: GoogleFonts.rubik(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            // Indicador de selección
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: GerenaColors.primaryColor,
                size: 28,
              )
            else
              Icon(
                Icons.radio_button_unchecked,
                color: Colors.grey[400],
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}