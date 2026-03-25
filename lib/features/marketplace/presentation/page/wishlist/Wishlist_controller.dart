import 'dart:convert';
import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_items_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_post_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_response_entity.dart';
import 'package:gerena/features/marketplace/domain/usecase/shopping_cart_usecase.dart';
import 'package:gerena/framework/preferences_service.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  final ShoppingCartUsecase shoppingCartUsecase;
  final PreferencesUser _prefs = PreferencesUser();

  WishlistController({required this.shoppingCartUsecase});

  final RxList<ShoppingCartPostEntity> wishlistItems =
      <ShoppingCartPostEntity>[].obs;
  final Rx<ShoppingCartResponseEntity?> wishlistResponse =
      Rx<ShoppingCartResponseEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlistFromPreferences();
  }

  Future<void> loadWishlistFromPreferences() async {
    try {
      final wishlistJson =
          await _prefs.loadPrefs(type: String, key: AppConstants.wishlistKey);

      print('💝 Wishlist JSON: $wishlistJson');

      if (wishlistJson != null && wishlistJson.isNotEmpty) {
        final List<dynamic> decoded = json.decode(wishlistJson);

        wishlistItems.value = decoded.map((item) {
          return ShoppingCartPostEntity(
            medicamentoId: item['medicamentoId'],
            cantidad: item['cantidad'] ?? 1,
            precioGuardado: item['precioGuardado'].toDouble(),
          );
        }).toList();

        await validateWishlist();
      }
    } catch (e, stackTrace) {
      error.value = 'Error al cargar la wishlist: $e';
      print('❌ Error loading wishlist: $e\n$stackTrace');
    }
  }

  Future<void> saveWishlistToPreferences() async {
    try {
      final wishlistList = wishlistItems
          .map((item) => {
                'medicamentoId': item.medicamentoId,
                'cantidad': item.cantidad,
                'precioGuardado': item.precioGuardado,
              })
          .toList();

      final wishlistJson = json.encode(wishlistList);

      _prefs.savePrefs(
          type: String, key: AppConstants.wishlistKey, value: wishlistJson);

      print('💾 Wishlist guardada: ${wishlistItems.length} items');
    } catch (e, stackTrace) {
      error.value = 'Error al guardar la wishlist: $e';
      print('❌ Error saving wishlist: $e\n$stackTrace');
    }
  }

  Future<void> toggleWishlist({
    required int medicamentoId,
    required double precio,
  }) async {
    try {
      final isInWishlist = this.isInWishlist(medicamentoId);

      if (isInWishlist) {
        await removeFromWishlist(medicamentoId);
      } else {
        await addToWishlist(medicamentoId: medicamentoId, precio: precio);
      }
    } catch (e) {
      error.value = 'Error al actualizar wishlist: $e';
      showErrorSnackbar(error.value); // ⭐ Cambiado
    }
  }

  Future<void> addToWishlist({
    required int medicamentoId,
    required double precio,
  }) async {
    try {
      // Verifica si ya existe
      final existingIndex = wishlistItems
          .indexWhere((item) => item.medicamentoId == medicamentoId);

      if (existingIndex != -1) {
        showErrorSnackbar(
            'Este producto ya está en tu wishlist'); // ⭐ Cambiado (error porque ya existe)
        return;
      }

      // Agrega con cantidad fija de 1
      wishlistItems.add(ShoppingCartPostEntity(
        medicamentoId: medicamentoId,
        cantidad: 1,
        precioGuardado: precio,
      ));

      await saveWishlistToPreferences();
      await validateWishlist();
      showSuccessSnackbar('agregado a wishlist correctamente');

      //  showSuccessSnackbar('💝 Producto agregado a tu lista de deseos'); // ⭐ Cambiado
    } catch (e, stackTrace) {
      error.value = 'Error al agregar a wishlist: $e';
      print('❌ Error: $e\n$stackTrace');
      showErrorSnackbar(error.value); // ⭐ Cambiado
    }
  }

  Future<void> removeFromWishlist(int medicamentoId) async {
    try {
      wishlistItems.removeWhere((item) => item.medicamentoId == medicamentoId);

      await saveWishlistToPreferences();
      await validateWishlist();

      showSuccessSnackbar('Producto removido de tu wishlist'); // ⭐ Cambiado
    } catch (e, stackTrace) {
      error.value = 'Error al eliminar de wishlist: $e';
      print('❌ Error: $e\n$stackTrace');
      showErrorSnackbar(error.value); // ⭐ Cambiado
    }
  }

  Future<void> validateWishlist() async {
    if (wishlistItems.isEmpty) {
      wishlistResponse.value = null;
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';

      final entity = ShoppingCartItemsEntity(shopping: wishlistItems,invoicerequired :false);

      final response = await shoppingCartUsecase.execute(entity);

      wishlistResponse.value = response;

      print('✅ Wishlist validada: ${response.itenms.length} items');
    } catch (e, stackTrace) {
      error.value = 'Error al validar wishlist: $e';
      print('❌ Error validating wishlist: $e\n$stackTrace');
      showErrorSnackbar('No se pudo validar la wishlist'); // ⭐ Cambiado
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> moveToCart(int medicamentoId) async {
    try {
      final item = wishlistItems
          .firstWhereOrNull((item) => item.medicamentoId == medicamentoId);

      if (item != null) {
        // Aquí podrías llamar al ShoppingCartController para agregar
        // Get.find<ShoppingCartController>().addToCart(...)

        await removeFromWishlist(medicamentoId);

        showSuccessSnackbar(
            '🛒 Producto movido al carrito de compras'); // ⭐ Cambiado
      }
    } catch (e) {
      error.value = 'Error al mover al carrito: $e';
      showErrorSnackbar(error.value); // ⭐ Cambiado
    }
  }

  Future<void> clearWishlist() async {
    wishlistItems.clear();
    wishlistResponse.value = null;
    await _prefs.clearOnePreference(key: AppConstants.wishlistKey);

    showSuccessSnackbar(
        'Wishlist limpiada - Todos los productos removidos'); // ⭐ Cambiado
  }

  // Getters útiles
  int get totalItems => wishlistItems.length;

  bool isInWishlist(int medicamentoId) {
    return wishlistItems.any((item) => item.medicamentoId == medicamentoId);
  }

  List<int> get wishlistIds =>
      wishlistItems.map((item) => item.medicamentoId).toList();
}
