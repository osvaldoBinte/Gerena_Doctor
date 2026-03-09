import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class IAPService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  
  // Callbacks
  Function(PurchaseDetails)? onPurchaseSuccess;
  Function(String)? onPurchaseError;
  Function(PurchaseDetails)? onPurchasePending;
  Function(PurchaseDetails)? onPurchaseRestored;

  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  bool _purchasePending = false;
  bool get purchasePending => _purchasePending;

  Future<void> initialize() async {
    _isAvailable = await _inAppPurchase.isAvailable();
    
    if (!_isAvailable) {
      print('❌ IAP no está disponible en este dispositivo');
      return;
    }

    // Configurar listener de compras
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription.cancel(),
      onError: (error) {
        print('❌ Error en stream de compras: $error');
        onPurchaseError?.call(error.toString());
      },
    );

    // Configurar iOS si es necesario
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    print('✅ IAP Service inicializado correctamente');
  }

  Future<void> loadProducts(List<String> productIds) async {
  if (!_isAvailable) {
    print('❌ IAP no disponible, no se pueden cargar productos');
    return;
  }

  print('🔍 Solicitando productos: $productIds');

  final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds.toSet());

  // ✅ Debug más detallado
  print('📦 Response error: ${response.error}');
  print('📦 Products encontrados: ${response.productDetails.length}');
  print('📦 Products no encontrados: ${response.notFoundIDs}');
  
  if (response.error != null) {
    print('❌ Error completo: ${response.error!.code} - ${response.error!.message}');
    print('❌ Source: ${response.error!.source}');
    onPurchaseError?.call(response.error!.message);
    return;
  }

  if (response.productDetails.isEmpty) {
    print('⚠️ No se encontraron productos con los IDs: $productIds');
    print('⚠️ IDs no encontrados: ${response.notFoundIDs}');
    return;
  }

  _products = response.productDetails;
  print('✅ Productos cargados: ${_products.length}');
  for (var product in _products) {
    print('  - ${product.id}: ${product.title} - ${product.price}');
  }
}

  Future<bool> buyProduct(ProductDetails product) async {
    if (!_isAvailable) {
      onPurchaseError?.call('Las compras no están disponibles');
      return false;
    }

    _purchasePending = true;

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    
    try {
      final bool success = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
      
      if (!success) {
        _purchasePending = false;
        onPurchaseError?.call('No se pudo iniciar la compra');
      }
      
      return success;
    } catch (e) {
      _purchasePending = false;
      onPurchaseError?.call(e.toString());
      return false;
    }
  }

  Future<void> restorePurchases() async {
    if (!_isAvailable) {
      onPurchaseError?.call('Las compras no están disponibles');
      return;
    }

    try {
      await _inAppPurchase.restorePurchases();
      print('✅ Restauración de compras iniciada');
    } catch (e) {
      print('❌ Error restaurando compras: $e');
      onPurchaseError?.call(e.toString());
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      print('📦 Estado de compra: ${purchaseDetails.status}');
      
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _purchasePending = true;
        onPurchasePending?.call(purchaseDetails);
      } else {
        _purchasePending = false;
        
        if (purchaseDetails.status == PurchaseStatus.error) {
          print('❌ Error en compra: ${purchaseDetails.error}');
          onPurchaseError?.call(purchaseDetails.error?.message ?? 'Error desconocido');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                   purchaseDetails.status == PurchaseStatus.restored) {
          
          print('✅ Compra exitosa: ${purchaseDetails.productID}');
          
          if (purchaseDetails.status == PurchaseStatus.restored) {
            onPurchaseRestored?.call(purchaseDetails);
          } else {
            onPurchaseSuccess?.call(purchaseDetails);
          }
        }
        
        // Completar la compra
        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
  }
}

// Delegate para iOS
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}