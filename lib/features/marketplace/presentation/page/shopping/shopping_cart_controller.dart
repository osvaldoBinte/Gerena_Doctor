import 'dart:convert';
import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/common/errors/convert_message.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/marketplace/domain/entities/orders/create/create_new_order_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_items_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_post_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_response_entity.dart' hide ItemEntity;
import 'package:gerena/features/marketplace/domain/usecase/create_order_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/pay_order_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/payment_methods_defaul_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/shopping_cart_usecase.dart';
import 'package:gerena/features/marketplace/presentation/page/addresses/addresses_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
import 'package:gerena/framework/preferences_service.dart';
import 'package:get/get.dart';

class ShoppingCartController extends GetxController {
  final ShoppingCartUsecase shoppingCartUsecase;
  final CreateOrderUsecase createOrderUsecase;
  final PayOrderUsecase payOrderUsecase;
  final PreferencesUser _prefs = PreferencesUser();
  final PaymentMethodsDefaulUsecase paymentMethodsDefaulUsecase;

  ShoppingCartController({
    required this.shoppingCartUsecase,
    required this.createOrderUsecase,
    required this.payOrderUsecase,
    required this.paymentMethodsDefaulUsecase,
  });
  
  final RxList<ShoppingCartPostEntity> cartItems = <ShoppingCartPostEntity>[].obs;
  final Rx<ShoppingCartResponseEntity?> cartResponse = Rx<ShoppingCartResponseEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  
  final RxString selectedPaymentMethodId = ''.obs;
  final RxString selectedAddressId = ''.obs;
  final RxBool isProcessingPayment = false.obs;
  
  // 👇 Agregar esta variable para saber en qué modo estamos
  final RxBool isBuyNowModeActive = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _checkAndLoadCart();
  }
  
  // 👇 Nuevo método que decide qué cargar
  Future<void> _checkAndLoadCart() async {
    // Primero verificar si hay un buyNow activo
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
  
  void selectPaymentMethod(String paymentMethodId) {
    selectedPaymentMethodId.value = paymentMethodId;
    print('💳 Método de pago seleccionado: $paymentMethodId');
  }
  
  void selectAddress(String? addressId) {
    if (addressId == null || addressId.isEmpty) {
      selectedAddressId.value = '';
      print('⚠️ Dirección vacía o nula');
      return;
    }
    
    selectedAddressId.value = addressId;
    print('📍 Dirección seleccionada en controller: $addressId');
  }
Future<void> confirmPurchase() async {
  if (selectedPaymentMethodId.value.isEmpty) {
    showErrorSnackbar('Por favor selecciona un método de pago');
    return;
  }
  
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
  
  try {
    isProcessingPayment.value = true;
    
    print('🛒 Confirmando compra...');
    print('💳 Payment Method ID: ${selectedPaymentMethodId.value}');
    print('📍 Address ID: ${selectedAddressId.value}');
    
    try {
      final paymentMethodId = int.parse(selectedPaymentMethodId.value);
      await paymentMethodsDefaulUsecase.execute(paymentMethodId);
      print('✅ Tarjeta establecida como predeterminada: $paymentMethodId');
    } catch (e) {
      print('⚠️ Error al establecer tarjeta predeterminada: $e');
    }
    
    final addressesController = Get.find<AddressesController>();
    final selectedAddress = addressesController.selectedAddress.value;
    
    if (selectedAddress == null) {
      showErrorSnackbar('No se encontró la dirección seleccionada');
      return;
    }
    
    final fullAddress = '${selectedAddress.street} ${selectedAddress.exteriorNumber}'
        '${selectedAddress.interiorNumber.isNotEmpty ? ', Int. ${selectedAddress.interiorNumber}' : ''}, '
        '${selectedAddress.neighborhood}';
    
    final items = cartItems.map((item) => ItemEntity(
      medicamentoId: item.medicamentoId,
      quantity: item.cantidad,
    )).toList();
    
    final orderEntity = CreateNewOrderEntity(
      items: items,
      direccionEnvio: fullAddress,
      ciudad: selectedAddress.city,
      codigoPostal: int.parse(selectedAddress.postalCode),
    );
    
    final orderResponse = await createOrderUsecase.createaneworder(orderEntity);
    print('✅ Orden creada: ${orderResponse.orderId}');
    
    await payOrderUsecase.execute(orderResponse.orderId);
    print('✅ Pago procesado exitosamente');
    
    showSuccessSnackbar('¡Compra confirmada exitosamente!');
    
    // 👇 AQUÍ ES DONDE VA LA NAVEGACIÓN
    // Guardar si estábamos en modo buyNow antes de limpiar
    final wasBuyNowMode = isBuyNowModeActive.value;
    
    // Limpiar según el modo
    if (isBuyNowModeActive.value) {
      await clearBuyNow();
      isBuyNowModeActive.value = false;
      await loadCartFromPreferences();
    } else {
      await clearCart();
    }
    
    // 👇 NAVEGACIÓN SEGÚN EL MODO
    if (wasBuyNowMode) {
      // Si fue "Comprar Ahora", ir a la tienda/ofertas
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
      // Si fue carrito normal, puedes ir a otra página o quedarte
      print('🎉 Compra desde carrito normal completada');
      
      // Opcional: navegar a pedidos o quedarse en la misma página
      // Get.find<ShopNavigationController>().navigateToOrders();
      // O simplemente no hacer nada y quedarse donde está
    }
    
  } catch (e, stackTrace) {
    print('❌ Error al confirmar compra: $e\n$stackTrace');
    showErrorSnackbar('No se pudo procesar el pago: ${cleanExceptionMessage(e)}');
  } finally {
    isProcessingPayment.value = false;
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
        // Si no hay carrito, limpiar items
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
      // 👇 Si estamos en modo buyNow, salir de él primero
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
        
        // 👇 Guardar según el modo
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
      
      // 👇 Guardar según el modo
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
    selectedPaymentMethodId.value = '';
    selectedAddressId.value = '';
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
  
  bool get canConfirmPurchase {
    return cartItems.isNotEmpty &&
           selectedPaymentMethodId.value.isNotEmpty &&
           selectedAddressId.value.isNotEmpty &&
           !isProcessingPayment.value &&
           !isLoading.value;
  }

  Future<void> setDefaultPaymentMethod(String paymentMethodId) async {
    try {
      isLoading.value = true;
      
      final int id = int.parse(paymentMethodId);
      
      print('💳 Estableciendo tarjeta predeterminada: $id');
      
      await paymentMethodsDefaulUsecase.execute(id);
      
      print('✅ Tarjeta predeterminada actualizada');
      
      showSuccessSnackbar('Tarjeta predeterminada actualizada');
      
    } catch (e, stackTrace) {
      print('❌ Error al establecer tarjeta predeterminada: $e\n$stackTrace');
      showErrorSnackbar('No se pudo actualizar la tarjeta predeterminada');
    } finally {
      isLoading.value = false;
    }
  }
  
  // 👇 Sistema de "Comprar Ahora"
  Future<void> buyNow({
    required int medicamentoId,
    required double precio,
    int cantidad = 1,
  }) async {
    try {
      // Activar modo buyNow
      isBuyNowModeActive.value = true;
      
      // Limpiar cualquier buyNow anterior
      await clearBuyNow();
      
      // Crear el item temporal
      final buyNowItem = ShoppingCartPostEntity(
        medicamentoId: medicamentoId,
        cantidad: cantidad,
        precioGuardado: precio,
      );
      
      // Reemplazar cartItems con el producto de buyNow
      cartItems.clear();
      cartItems.add(buyNowItem);
      
      // Guardar en buyNowKey
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

  // 👇 Método privado para guardar buyNow
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
}