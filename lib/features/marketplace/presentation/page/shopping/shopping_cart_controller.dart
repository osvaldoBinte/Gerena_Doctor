import 'dart:convert';
import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/common/errors/convert_message.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/doctors/presentation/page/prefil_dortor_controller.dart';
import 'package:gerena/features/marketplace/domain/entities/orders/create/create_new_order_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_items_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_post_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_response_entity.dart' hide ItemEntity;
import 'package:gerena/features/marketplace/domain/usecase/calculate_discount_points_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/create_order_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/shopping_cart_usecase.dart';
import 'package:gerena/features/marketplace/presentation/page/addresses/addresses_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
import 'package:gerena/framework/preferences_service.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ShoppingCartController extends GetxController {
  final ShoppingCartUsecase shoppingCartUsecase;
  final CreateOrderUsecase createOrderUsecase;
  final CalculateDiscountPointsUsecase calculateDiscountPointsUsecase;
  final PreferencesUser _prefs = PreferencesUser();

  ShoppingCartController({
    required this.shoppingCartUsecase,
    required this.createOrderUsecase,
    required this.calculateDiscountPointsUsecase,
  });
  
  final RxList<ShoppingCartPostEntity> cartItems = <ShoppingCartPostEntity>[].obs;
  final Rx<ShoppingCartResponseEntity?> cartResponse = Rx<ShoppingCartResponseEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  
  
  final RxString selectedAddressId = ''.obs;
  final RxBool isProcessingOrder = false.obs; 
  
  
  final RxBool isBuyNowModeActive = false.obs;
  
  final RxBool usePoints = false.obs;
  final RxInt pointsToUse = 0.obs;
  final RxInt availablePoints = 0.obs;
  final RxDouble pointsDiscount = 0.0.obs;
  final RxBool isCalculatingDiscount = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _checkAndLoadCart();
    _loadAvailablePoints();
    loadAvailablePoints();
  }

  Future<void> loadAvailablePoints() async {
    try {
      final doctorController = Get.find<PrefilDortorController>();
      
      await doctorController.loadProfile();
      
      if (doctorController.doctorProfile.value != null) {
        final newPoints = doctorController.doctorProfile.value!.puntosDisponibles ?? 0;
        
        if (availablePoints.value != newPoints) {
          availablePoints.value = newPoints;
          print('💰 Puntos actualizados: ${availablePoints.value}');
          
          if (usePoints.value && pointsToUse.value > availablePoints.value) {
            print('⚠️ Los puntos seleccionados exceden los disponibles, ajustando...');
            await updatePointsToUse(availablePoints.value);
          }
        }
      }
    } catch (e) {
      print('⚠️ No se pudieron cargar los puntos disponibles: $e');
      availablePoints.value = 0;
    }
  }
  
  Future<void> _loadAvailablePoints() async {
    try {
      final doctorController = Get.find<PrefilDortorController>();
      if (doctorController.doctorProfile.value != null) {
        availablePoints.value = doctorController.doctorProfile.value!.puntosDisponibles ?? 0;
        print('💰 Puntos disponibles cargados: ${availablePoints.value}');
      }
    } catch (e) {
      print('⚠️ No se pudieron cargar los puntos disponibles: $e');
      availablePoints.value = 0;
    }
  }
 
  void toggleUsePoints(bool value) async {
    usePoints.value = value;
    
    if (!value) {
      pointsToUse.value = 0;
      pointsDiscount.value = 0.0;
    } else {
      final maxPointsAvailable = availablePoints.value;
      await updatePointsToUse(maxPointsAvailable);
    }
    
    print('💳 Usar puntos: $value | Puntos a usar: ${pointsToUse.value} | Descuento: ${pointsDiscount.value}');
  }

  Future<void> updatePointsToUse(int points) async {
    if (points < 0) {
      pointsToUse.value = 0;
      pointsDiscount.value = 0.0;
      return;
    }
    
    final totalOrder = cartResponse.value?.totalActual ?? 0.0;
    final maxPointsAvailable = availablePoints.value;
    
    if (points > maxPointsAvailable) {
      showErrorSnackbar('No tienes suficientes puntos. Máximo disponible: $maxPointsAvailable');
      pointsToUse.value = maxPointsAvailable;
      points = maxPointsAvailable;
    }
    
    if (points == 0) {
      pointsToUse.value = 0;
      pointsDiscount.value = 0.0;
      return;
    }
    
    try {
      isCalculatingDiscount.value = true;
      
      final montoInt = totalOrder.toInt();
      final discountEntity = await calculateDiscountPointsUsecase.execute(
        montoInt, 
        points,
      );
      
      final calculatedDiscount = discountEntity.totalDiscount;
      
      pointsToUse.value = points;
      pointsDiscount.value = calculatedDiscount;
      
      print('💰 Puntos: $points | Monto orden: \$${totalOrder.toStringAsFixed(2)} | Descuento calculado: \$${calculatedDiscount.toStringAsFixed(2)}');
      
    } catch (e) {
      print('❌ Error al calcular descuento: $e');
      showErrorSnackbar('No se pudo calcular el descuento con puntos');
      pointsToUse.value = 0;
      pointsDiscount.value = 0.0;
    } finally {
      isCalculatingDiscount.value = false;
    }
  }
  
  double get finalTotal {
    final subtotal = cartResponse.value?.totalActual ?? 0.0;
    final discount = usePoints.value ? pointsDiscount.value : 0.0;
    return subtotal - discount;
  }
  
  Future<void> _checkAndLoadCart() async {
    final buyNowJson = await _prefs.loadPrefs(
      type: String, 
      key: AppConstants.buynowKey
    );
    
    if (buyNowJson != null && buyNowJson.isNotEmpty) {
      isBuyNowModeActive.value = true;
      await loadBuyNowFromPreferences();
    } else {
      isBuyNowModeActive.value = false;
      await loadCartFromPreferences();
    }
  }

  // REMOVIDO: método selectPaymentMethod ya no es necesario
  
  void selectAddress(String? addressId) {
    if (addressId == null || addressId.isEmpty) {
      selectedAddressId.value = '';
      print('⚠️ Dirección vacía o nula');
      return;
    }
    
    selectedAddressId.value = addressId;
    print('📍 Dirección seleccionada en controller: $addressId');
  }
  
  // NUEVO: Método para confirmar pedido (sin pago)
  Future<void> confirmOrder() async {
    // REMOVIDO: Validación de método de pago
    
    if (selectedAddressId.value.isEmpty) {
      showErrorSnackbar('Por favor selecciona una dirección de entrega');
      return;
    }
    
    if (cartItems.isEmpty) {
      showErrorSnackbar('El carrito está vacío');
      return;
    }
    
    final response = cartResponse.value;
    if (response != null) {
      final hasOutOfStock = response.itenms.any((item) => item.sinStock);
      if (hasOutOfStock) {
        showErrorSnackbar('Hay productos sin stock en tu carrito');
        return;
      }
    }
    
    if (usePoints.value) {
      if (pointsToUse.value > availablePoints.value) {
        showErrorSnackbar('No tienes suficientes puntos disponibles');
        return;
      }
      
      if (pointsToUse.value <= 0) {
        showErrorSnackbar('Debes especificar cuántos puntos deseas usar');
        return;
      }
      
      if (pointsDiscount.value <= 0) {
        showErrorSnackbar('El descuento con puntos debe ser mayor a 0');
        return;
      }
    }
    
    try {
      isProcessingOrder.value = true;
      
      final addressId = int.parse(selectedAddressId.value);
      
      final items = cartItems.map((item) => ItemEntity(
        medicamentoId: item.medicamentoId,
        quantity: item.cantidad,
      )).toList();
      
      final orderEntity = CreateNewOrderEntity(
        items: items,
        usepoints: usePoints.value,
        pointstouse: usePoints.value ? pointsToUse.value : 0,
      );
      
      print('📦 Creando pedido con usepoints: ${orderEntity.usepoints}, pointstouse: ${orderEntity.pointstouse}, descuento: \$${pointsDiscount.value}');
      
      // SOLO CREAMOS EL PEDIDO - REMOVIDO: payOrderUsecase
      final orderResponse = await createOrderUsecase.createaneworder(
        orderEntity,
        addressId,
      );
      
      print('✅ Pedido creado exitosamente. Order ID: ${orderResponse.orderId}');
      
      if (usePoints.value) {
        print('💰 Se usaron ${pointsToUse.value} puntos con descuento de \$${pointsDiscount.value.toStringAsFixed(2)} en el pedido');
      }
      
      showSuccessSnackbar('¡Pedido confirmado exitosamente!');
      
      // NUEVO: Enviar mensaje de WhatsApp al vendedor
      await _sendWhatsAppToVendor(
        orderId: orderResponse.orderId.toString(),
        totalAmount: finalTotal,
      );
      
      final wasBuyNowMode = isBuyNowModeActive.value;
      
      // Resetear estado
      usePoints.value = false;
      pointsToUse.value = 0;
      pointsDiscount.value = 0.0;
      await loadAvailablePoints();
      
      if (isBuyNowModeActive.value) {
        await clearBuyNow();
        isBuyNowModeActive.value = false;
        await loadCartFromPreferences();
      } else {
        await clearCart();
      }
      
      if (wasBuyNowMode) {
        print('🎉 Navegando a tienda después de Comprar Ahora');
        Get.find<ShopNavigationController>().navigateToStore();
        Get.to(
          () => GlobalShopInterface(),
          arguments: {
            'categoryName': '',
            'showOffers': true,
          },
        );
      } else {
        print('🎉 Pedido desde carrito normal completado');
      }
      
    } catch (e, stackTrace) {
      print('❌ Error al confirmar pedido: $e\n$stackTrace');
      showErrorSnackbar('No se pudo crear el pedido: ${cleanExceptionMessage(e)}');
    } finally {
      isProcessingOrder.value = false;
    }
  }
  
  Future<void> loadCartFromPreferences() async {
    try {
      final cartJson = await _prefs.loadPrefs(type: String, key: AppConstants.cartKey);
      
      print('📦 Cart JSON: $cartJson');
      
      if (cartJson != null && cartJson.isNotEmpty) {
        final List<dynamic> decoded = json.decode(cartJson);
        
        cartItems.value = decoded.map((item) {
          return ShoppingCartPostEntity(
            medicamentoId: item['medicamentoId'],
            cantidad: item['cantidad'],
            precioGuardado: item['precioGuardado'].toDouble(),
          );
        }).toList();
        
        await validateCart();
      } else {
        cartItems.clear();
        cartResponse.value = null;
      }
    } catch (e, stackTrace) {
      error.value = 'Error al cargar el carrito: $e';
      print('❌ Error loading cart: $e\n$stackTrace');
      showErrorSnackbar('No se pudo cargar el carrito');
    }
  }
  
  Future<void> saveCartToPreferences() async {
    try {
      final cartList = cartItems.map((item) => {
        'medicamentoId': item.medicamentoId,
        'cantidad': item.cantidad,
        'precioGuardado': item.precioGuardado,
      }).toList();
      
      final cartJson = json.encode(cartList);
     
      _prefs.savePrefs(type: String, key: AppConstants.cartKey, value: cartJson);
      
      print('💾 Carrito guardado: ${cartItems.length} items');
    } catch (e, stackTrace) {
      error.value = 'Error al guardar el carrito: $e';
      print('❌ Error saving cart: $e\n$stackTrace');
      showErrorSnackbar('No se pudo guardar el carrito');
    }
  }
  
  Future<void> addToCart({
    required int medicamentoId,
    required double precio,
    int cantidad = 1,
  }) async {
    try {
      if (isBuyNowModeActive.value) {
        await clearBuyNow();
        isBuyNowModeActive.value = false;
        await loadCartFromPreferences();
      }
      
      final existingIndex = cartItems.indexWhere(
        (item) => item.medicamentoId == medicamentoId
      );
      
      if (existingIndex != -1) {
        final existing = cartItems[existingIndex];
        cartItems[existingIndex] = ShoppingCartPostEntity(
          medicamentoId: existing.medicamentoId,
          cantidad: existing.cantidad + cantidad,
          precioGuardado: precio,
        );
      } else {
        cartItems.add(ShoppingCartPostEntity(
          medicamentoId: medicamentoId,
          cantidad: cantidad,
          precioGuardado: precio,
        ));
      }
      
      showSuccessSnackbar('AGREGADO AL CARRITO EXITOSAMENTE');

      await saveCartToPreferences();
      await validateCart();
      
    } catch (e, stackTrace) {
      error.value = 'Error al agregar al carrito: $e';
      print('❌ Error: $e\n$stackTrace');
      showErrorSnackbar(error.value);
    }
  }
  
  Future<void> updateQuantity(int medicamentoId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        print('⚠️ Cantidad <= 0, eliminando producto');
        await removeFromCart(medicamentoId);
        return;
      }
      
      final index = cartItems.indexWhere(
        (item) => item.medicamentoId == medicamentoId
      );
      
      if (index != -1) {
        cartItems[index] = ShoppingCartPostEntity(
          medicamentoId: cartItems[index].medicamentoId,
          cantidad: newQuantity,
          precioGuardado: cartItems[index].precioGuardado,
        );
        
        if (isBuyNowModeActive.value) {
          await _saveBuyNowToPreferences();
        } else {
          await saveCartToPreferences();
        }
        
        await validateCart();
      } else {
        print('⚠️ Producto no encontrado en el carrito');
      }
    } catch (e, stackTrace) {
      error.value = 'Error al actualizar cantidad: $e';
      print('❌ Error: $e\n$stackTrace');
      showErrorSnackbar('No se pudo actualizar la cantidad');
    }
  }
  
  Future<void> removeFromCart(int medicamentoId) async {
    try {
      cartItems.removeWhere((item) => item.medicamentoId == medicamentoId);
      
      if (isBuyNowModeActive.value) {
        await clearBuyNow();
        isBuyNowModeActive.value = false;
      } else {
        await saveCartToPreferences();
      }
      
      await validateCart();
      
      showSuccessSnackbar('Producto removido del carrito');
    } catch (e, stackTrace) {
      error.value = 'Error al eliminar producto: $e';
      print('❌ Error: $e\n$stackTrace');
      showErrorSnackbar('No se pudo eliminar el producto');
    }
  }
  
  Future<void> validateCart() async {
    if (cartItems.isEmpty) {
      cartResponse.value = null;
      return;
    }
    
    try {
      isLoading.value = true;
      error.value = '';
      
      final entity = ShoppingCartItemsEntity(shopping: cartItems);
      
      final response = await shoppingCartUsecase.execute(entity);
      
      cartResponse.value = response;
      
      print('✅ Carrito validado: ${response.itenms.length} items');
      
    } catch (e, stackTrace) {
      error.value = 'Error al validar carrito: $e';
      print('❌ Error validating cart: $e\n$stackTrace');
      showErrorSnackbar('No se pudo validar el carrito');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> clearCart() async {
    cartItems.clear();
    cartResponse.value = null;
    selectedAddressId.value = '';
    usePoints.value = false;
    pointsToUse.value = 0;
    pointsDiscount.value = 0.0;
    await _prefs.clearOnePreference(key: AppConstants.cartKey);
    
    print('🧹 Carrito limpiado completamente');
  }
  
  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.cantidad);
  
  bool isInCart(int medicamentoId) {
    return cartItems.any((item) => item.medicamentoId == medicamentoId);
  }
  
  int getProductQuantity(int medicamentoId) {
    final item = cartItems.firstWhereOrNull(
      (item) => item.medicamentoId == medicamentoId
    );
    return item?.cantidad ?? 0;
  }
  
  // MODIFICADO: Ya no valida método de pago
  bool get canConfirmOrder {
    return cartItems.isNotEmpty &&
           selectedAddressId.value.isNotEmpty &&
           !isProcessingOrder.value &&
           !isLoading.value;
  }
  
  Future<void> buyNow({
    required int medicamentoId,
    required double precio,
    int cantidad = 1,
  }) async {
    try {
      isBuyNowModeActive.value = true;
      
      await clearBuyNow();
      
      final buyNowItem = ShoppingCartPostEntity(
        medicamentoId: medicamentoId,
        cantidad: cantidad,
        precioGuardado: precio,
      );
      
      cartItems.clear();
      cartItems.add(buyNowItem);
      
      await _saveBuyNowToPreferences();
      
      await validateCart();
      
      showSuccessSnackbar('¡PRODUCTO LISTO PARA COMPRAR!');
      
      print('🛍️ Comprar Ahora: producto $medicamentoId preparado');
      
    } catch (e, stackTrace) {
      error.value = 'Error al preparar compra: $e';
      print('❌ Error en buyNow: $e\n$stackTrace');
      showErrorSnackbar('No se pudo preparar la compra');
    }
  }

  Future<void> _saveBuyNowToPreferences() async {
    try {
      if (cartItems.isEmpty) return;
      
      final item = cartItems.first;
      final itemJson = json.encode({
        'medicamentoId': item.medicamentoId,
        'cantidad': item.cantidad,
        'precioGuardado': item.precioGuardado,
      });
      
      _prefs.savePrefs(
        type: String, 
        key: AppConstants.buynowKey, 
        value: itemJson
      );
      
      print('💾 BuyNow guardado');
    } catch (e) {
      print('❌ Error al guardar buyNow: $e');
    }
  }

  Future<void> loadBuyNowFromPreferences() async {
    try {
      final buyNowJson = await _prefs.loadPrefs(
        type: String, 
        key: AppConstants.buynowKey
      );
      
      if (buyNowJson != null && buyNowJson.isNotEmpty) {
        final Map<String, dynamic> decoded = json.decode(buyNowJson);
        
        final buyNowItem = ShoppingCartPostEntity(
          medicamentoId: decoded['medicamentoId'],
          cantidad: decoded['cantidad'],
          precioGuardado: decoded['precioGuardado'].toDouble(),
        );
        
        cartItems.clear();
        cartItems.add(buyNowItem);
        
        await validateCart();
        
        print('🛍️ Producto "Comprar Ahora" cargado');
      }
    } catch (e, stackTrace) {
      print('⚠️ Error al cargar buyNow: $e\n$stackTrace');
    }
  }

  Future<void> clearBuyNow() async {
    try {
      await _prefs.clearOnePreference(key: AppConstants.buynowKey);
      print('🧹 BuyNow limpiado');
    } catch (e) {
      print('⚠️ Error al limpiar buyNow: $e');
    }
  }

  Future<bool> isBuyNowMode() async {
    try {
      final buyNowJson = await _prefs.loadPrefs(
        type: String, 
        key: AppConstants.buynowKey
      );
      return buyNowJson != null && buyNowJson.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // NUEVO: Método para enviar mensaje de WhatsApp al vendedor
  Future<void> _sendWhatsAppToVendor({
    required String orderId,
    required double totalAmount,
  }) async {
    try {
      final doctorController = Get.find<PrefilDortorController>();
      final doctorProfile = doctorController.doctorProfile.value;
      
      if (doctorProfile == null) {
        print('⚠️ No se pudo obtener el perfil del doctor');
        return;
      }

      final nombreVendedor = doctorProfile.nombreVendedor;
      final whatsAppVendedor = doctorProfile.whatsAppVendedor;

      if (whatsAppVendedor == null || whatsAppVendedor.isEmpty) {
        print('⚠️ El vendedor no tiene WhatsApp configurado');
        return;
      }

      // Limpiar el número de WhatsApp (quitar espacios, guiones, etc.)
      final cleanPhone = whatsAppVendedor.replaceAll(RegExp(r'[^\d+]'), '');

      // Construir el mensaje
      final addressesController = Get.find<AddressesController>();
      final selectedAddress = addressesController.selectedAddress.value;
      
      String mensaje = '¡Hola ${nombreVendedor ?? ""}! 👋\n\n';
      mensaje += '✅ *Nuevo pedido confirmado*\n\n';
      mensaje += '📦 *ID del pedido:* $orderId\n';
      mensaje += '💰 *Total:* \$${totalAmount.toStringAsFixed(2)} MXN\n\n';
      
      if (usePoints.value && pointsToUse.value > 0) {
        mensaje += '🎁 *Puntos usados:* ${pointsToUse.value} pts (-\$${pointsDiscount.value.toStringAsFixed(2)} MXN)\n\n';
      }
      
      mensaje += '📍 *Dirección de entrega:*\n';
      if (selectedAddress != null) {
        mensaje += '${selectedAddress.fullName}\n';
        mensaje += '${selectedAddress.street} ${selectedAddress.exteriorNumber}';
        if (selectedAddress.interiorNumber.isNotEmpty) {
          mensaje += ', Int. ${selectedAddress.interiorNumber}';
        }
        mensaje += '\n${selectedAddress.neighborhood}, ${selectedAddress.city}\n';
        mensaje += '${selectedAddress.state}, C.P. ${selectedAddress.postalCode}\n';
        mensaje += '📱 ${selectedAddress.phone}\n\n';
      }
      
      mensaje += '🛒 *Productos:*\n';
      final response = cartResponse.value;
      if (response != null) {
        for (var item in response.itenms) {
          mensaje += '• ${item.nombreMedicamento} (x${item.cantidadSolicitada}) - \$${item.precioActual.toStringAsFixed(2)} MXN\n';
        }
      }
      
      mensaje += '\n¡Gracias por tu atención! 🙏';

      // Codificar el mensaje para URL
      final encodedMessage = Uri.encodeComponent(mensaje);
      
      // Crear la URL de WhatsApp
      final whatsappUrl = 'https://wa.me/$cleanPhone?text=$encodedMessage';
      
      print('📱 Intentando abrir WhatsApp: $whatsappUrl');
      
      // Intentar abrir WhatsApp
      final uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        print('✅ WhatsApp abierto correctamente');
      } else {
        print('❌ No se pudo abrir WhatsApp');
        showErrorSnackbar('No se pudo abrir WhatsApp. Verifica que esté instalado.');
      }
      
    } catch (e, stackTrace) {
      print('❌ Error al enviar mensaje de WhatsApp: $e\n$stackTrace');
      // No mostramos error al usuario para no interrumpir el flujo
    }
  }
}