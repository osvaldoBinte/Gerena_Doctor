import 'dart:convert';
import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart'; // ⭐ Importa tu archivo de snackbars
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_items_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_post_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_response_entity.dart';
import 'package:gerena/features/marketplace/domain/usecase/shopping_cart_usecase.dart';
import 'package:gerena/framework/preferences_service.dart';
import 'package:get/get.dart';

class ShoppingCartController extends GetxController {
  final ShoppingCartUsecase shoppingCartUsecase;
  final PreferencesUser _prefs = PreferencesUser();
  
  ShoppingCartController({required this.shoppingCartUsecase});
  
  final RxList<ShoppingCartPostEntity> cartItems = <ShoppingCartPostEntity>[].obs;
  final Rx<ShoppingCartResponseEntity?> cartResponse = Rx<ShoppingCartResponseEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadCartFromPreferences();
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
      }
    } catch (e, stackTrace) {
      error.value = 'Error al cargar el carrito: $e';
      print('❌ Error loading cart: $e\n$stackTrace');
      showErrorSnackbar('No se pudo cargar el carrito'); // ⭐ Agregado
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
      showErrorSnackbar('No se pudo guardar el carrito'); // ⭐ Agregado
    }
  }
  
  Future<void> addToCart({
    required int medicamentoId,
    required double precio,
    int cantidad = 1,
  }) async {
    try {
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
      
      await saveCartToPreferences();
      await validateCart();
      
      
    } catch (e, stackTrace) {
      error.value = 'Error al agregar al carrito: $e';
      print('❌ Error: $e\n$stackTrace');
      showErrorSnackbar(error.value); // ⭐ Cambiado
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
        
        await saveCartToPreferences();
        await validateCart();
        
        // ⭐ Opcional: puedes agregar feedback visual
        // showSuccessSnackbar('Cantidad actualizada');
      } else {
        print('⚠️ Producto no encontrado en el carrito');
      }
    } catch (e, stackTrace) {
      error.value = 'Error al actualizar cantidad: $e';
      print('❌ Error: $e\n$stackTrace');
      showErrorSnackbar('No se pudo actualizar la cantidad'); // ⭐ Agregado
    }
  }
  
  Future<void> removeFromCart(int medicamentoId) async {
    try {
      cartItems.removeWhere((item) => item.medicamentoId == medicamentoId);
      
      await saveCartToPreferences();
      await validateCart();
      
      showSuccessSnackbar('Producto removido del carrito'); // ⭐ Cambiado
    } catch (e, stackTrace) {
      error.value = 'Error al eliminar producto: $e';
      print('❌ Error: $e\n$stackTrace');
      showErrorSnackbar('No se pudo eliminar el producto'); // ⭐ Agregado
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
      showErrorSnackbar('No se pudo validar el carrito'); // ⭐ Agregado
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> clearCart() async {
    cartItems.clear();
    cartResponse.value = null;
    await _prefs.clearOnePreference(key: AppConstants.cartKey);
    
    showSuccessSnackbar('Carrito limpiado correctamente'); // ⭐ Agregado
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
}