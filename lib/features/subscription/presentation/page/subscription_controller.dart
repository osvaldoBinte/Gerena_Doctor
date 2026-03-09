import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/subscription/domain/entities/mysubcription/my_subcription_entity.dart';
import 'package:gerena/features/subscription/domain/entities/view_all_plans_entity.dart';
import 'package:gerena/features/subscription/domain/usecase/VerifyIapReceiptUsecase.dart';
import 'package:gerena/features/subscription/domain/usecase/change_subscription_plan_usecase.dart';
import 'package:gerena/features/subscription/domain/usecase/get_all_plans_usecase.dart';
import 'package:gerena/features/subscription/domain/usecase/get_my_subscription_usecase.dart';
import 'package:gerena/features/subscription/domain/usecase/post_cancel_subcription_usecase.dart';
import 'package:gerena/features/subscription/domain/usecase/post_subscribe_to_plan_usecase.dart';
import 'package:gerena/features/subscription/presentation/page/menbresia/iap_service.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionController extends GetxController {
  final GetAllPlansUsecase getAllPlansUsecase;
  final PostSubscribeToPlanUsecase postSubscribeToPlanUsecase;
  final GetMySubscriptionUsecase getMySubscriptionUsecase;
  final ChangeSubscriptionPlanUsecase changeSubscriptionPlanUsecase;
  final PostCancelSubcriptionUsecase postCancelSubcriptionUsecase;
  final VerifyIAPPurchaseUsecase verifyIAPPurchaseUsecase;

  SubscriptionController({
    required this.getAllPlansUsecase,
    required this.postSubscribeToPlanUsecase,
    required this.getMySubscriptionUsecase,
    required this.changeSubscriptionPlanUsecase,
    required this.postCancelSubcriptionUsecase,
    required this.verifyIAPPurchaseUsecase,
  });

  var isLoading = true.obs;
  var plans = <ViewAllPlansEntity>[].obs;
  var errorMessage = ''.obs;
  var selectedPaymentMethodId = ''.obs;
  var isCancelling = false.obs;
  
  Rx<MySubscriptionEntity?> currentSubscription = Rx<MySubscriptionEntity?>(null);
  var hasActiveSubscription = false.obs;

  // IAP Service
  final IAPService _iapService = IAPService();
  var iapProducts = <ProductDetails>[].obs;
  var isIAPAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSubscriptionData();
    
    // Inicializar IAP solo en iOS
    if (Platform.isIOS) {
      _initializeIAP();
    }
  }

  Future<void> _initializeIAP() async {
    await _iapService.initialize();
    isIAPAvailable.value = _iapService.isAvailable;

    if (isIAPAvailable.value) {
      // Configurar callbacks
      _iapService.onPurchaseSuccess = _handlePurchaseSuccess;
      _iapService.onPurchaseError = _handlePurchaseError;
      _iapService.onPurchasePending = _handlePurchasePending;
      _iapService.onPurchaseRestored = _handlePurchaseRestored;

      // Cargar productos después de obtener los planes
      await loadSubscriptionData();
      await _loadIAPProducts();
    }
  }

  // ✅ MÉTODO ACTUALIZADO - Normaliza los nombres de los planes
  Future<void> _loadIAPProducts() async {
    if (plans.isEmpty) return;

    // Crear lista de product IDs normalizados (sin tildes)
    final productIds = plans.map((plan) {
      String normalizedName = _normalizeProductId(plan.name);
      return 'com.gerena.subscription.$normalizedName';
    }).toList();

    print('🔍 Buscando productos IAP: $productIds');
    await _iapService.loadProducts(productIds);
    iapProducts.value = _iapService.products;
    
    // Mostrar qué productos se cargaron
    if (iapProducts.isNotEmpty) {
      print('✅ Productos IAP cargados:');
      for (var product in iapProducts) {
        print('   - ${product.id}: ${product.title} (${product.price})');
      }
    } else {
      print('⚠️ No se cargaron productos IAP');
    }
  }

  // ✅ NUEVO MÉTODO - Normaliza el nombre del plan (quita tildes y caracteres especiales)
  String _normalizeProductId(String planName) {
    // Convertir a minúsculas
    String normalized = planName.toLowerCase();
    
    // Reemplazar vocales con tilde por vocales sin tilde
    normalized = normalized
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ñ', 'n');
    
    // Reemplazar espacios por guiones bajos
    normalized = normalized.replaceAll(' ', '_');
    
    // Remover cualquier otro caracter especial (solo dejar letras, números y guiones bajos)
    normalized = normalized.replaceAll(RegExp(r'[^a-z0-9_]'), '');
    
    print('📝 Nombre normalizado: "$planName" → "$normalized"');
    return normalized;
  }

  // ✅ MÉTODO ACTUALIZADO - Usa normalización para buscar el producto
  ProductDetails? getIAPProduct(ViewAllPlansEntity plan) {
    final normalizedName = _normalizeProductId(plan.name);
    final productId = 'dev.binteconsulting.gerena.subscription.$normalizedName';
    
    print('🔍 Buscando producto IAP: $productId');
    final product = iapProducts.firstWhereOrNull((p) => p.id == productId);
    
    if (product == null) {
      print('❌ Producto no encontrado: $productId');
      print('   Productos disponibles: ${iapProducts.map((p) => p.id).toList()}');
    } else {
      print('✅ Producto encontrado: ${product.id} - ${product.price}');
    }
    
    return product;
  }

  void _handlePurchaseSuccess(PurchaseDetails purchaseDetails) async {
    print('✅ Compra exitosa, verificando con backend...');
    isLoading.value = true;

    try {
      // Enviar el receipt al backend para validación
      await verifyIAPPurchaseUsecase.execute(
        purchaseDetails.verificationData.serverVerificationData,
        purchaseDetails.productID,
        Platform.isIOS ? 'ios' : 'android',
      );

      showSuccessSnackbar('Suscripción activada correctamente');
      await loadSubscriptionData();
    } catch (e) {
      showErrorSnackbar('Error al validar la compra: ${e.toString()}');
      print('❌ Error validando compra: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _handlePurchaseError(String error) {
    showErrorSnackbar('Error en la compra: $error');
    isLoading.value = false;
  }

  void _handlePurchasePending(PurchaseDetails purchaseDetails) {
    showSnackBar('Compra pendiente de confirmación', GerenaColors.primaryColor);
  }

  void _handlePurchaseRestored(PurchaseDetails purchaseDetails) {
    showSuccessSnackbar('Suscripción restaurada correctamente');
    loadSubscriptionData();
  }

  Future<void> loadSubscriptionData() async {
    await Future.wait([
      fetchPlans(),
      fetchMySubscription(),
    ]);
  }

  Future<void> fetchPlans() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await getAllPlansUsecase.execute();
      plans.value = result;
      
      // Debug: mostrar planes obtenidos
      print('📋 Planes obtenidos del backend:');
      for (var plan in plans) {
        print('   - ${plan.name} (ID: ${plan.id})');
      }
    } catch (e) {
      errorMessage.value = 'Error al cargar los planes: $e';
      print('Error fetching plans: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMySubscription() async {
    try {
      final subscription = await getMySubscriptionUsecase.execute();
      currentSubscription.value = subscription;
      hasActiveSubscription.value = subscription.state?.toLowerCase() == 'active';
      print('✅ Suscripción actual: ${subscription.planname} - Estado: ${subscription.state}');
    } catch (e) {
      print('ℹ️ No hay suscripción activa: $e');
      currentSubscription.value = null;
      hasActiveSubscription.value = false;
    }
  }

  bool isCurrentPlan(int planId) {
    if (currentSubscription.value == null) return false;
    return currentSubscription.value!.subscriptionplanId == planId.toString();
  }

  Future<void> subscribeToPlan(int planId) async {
    // En iOS, usar IAP
    if (Platform.isIOS && isIAPAvailable.value) {
      await _subscribeToPlanViaIAP(planId);
      return;
    }

    // En Android o web, usar Stripe
    await _subscribeToPlanViaStripe(planId);
  }

  Future<void> _subscribeToPlanViaIAP(int planId) async {
    try {
      if (hasActiveSubscription.value) {
        showErrorSnackbar('Ya tienes una suscripción activa. Usa la opción de cambiar plan.');
        return;
      }

      final plan = plans.firstWhereOrNull((p) => p.id == planId);
      if (plan == null) {
        showErrorSnackbar('Plan no encontrado');
        return;
      }

      final product = getIAPProduct(plan);
      if (product == null) {
        showErrorSnackbar('Producto de App Store no disponible para este plan');
        return;
      }

      isLoading.value = true;
      
      final success = await _iapService.buyProduct(product);
      
      if (!success) {
        isLoading.value = false;
        showErrorSnackbar('No se pudo iniciar la compra');
      }
      // El resto se maneja en _handlePurchaseSuccess
      
    } catch (e) {
      isLoading.value = false;
      showErrorSnackbar('Error al iniciar la compra: $e');
      print('Error subscribing via IAP: $e');
    }
  }

  Future<void> _subscribeToPlanViaStripe(int planId) async {
    try {
      if (hasActiveSubscription.value) {
        showErrorSnackbar('Ya tienes una suscripción activa. Usa la opción de cambiar plan.');
        return;
      }

      if (selectedPaymentMethodId.value.isEmpty) {
        showErrorSnackbar('Por favor selecciona un método de pago');
        return;
      }

      isLoading.value = true;
      
      await postSubscribeToPlanUsecase.execute(
        selectedPaymentMethodId.value,
        planId,
      );
      
      showSuccessSnackbar('Suscripción realizada correctamente');
      
      await loadSubscriptionData();
      selectedPaymentMethodId.value = '';
      
    } catch (e) {
      showErrorSnackbar('Error al suscribirse al plan: ${e.toString().replaceAll('Exception: ', '')}');
      print('Error subscribing to plan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> restorePurchases() async {
    if (!Platform.isIOS || !isIAPAvailable.value) {
      showErrorSnackbar('La restauración solo está disponible en iOS');
      return;
    }

    try {
      isLoading.value = true;
      await _iapService.restorePurchases();
      showSnackBar('Buscando compras anteriores...', GerenaColors.primaryColor);
    } catch (e) {
      showErrorSnackbar('Error al restaurar compras: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeSubscriptionPlan(int newPlanId, bool immediateChange) async {
    try {
      if (!hasActiveSubscription.value) {
        showErrorSnackbar('No tienes una suscripción activa para cambiar');
        return;
      }

      if (isCurrentPlan(newPlanId)) {
        showSnackBar('Este ya es tu plan actual', GerenaColors.primaryColor);
        return;
      }

      isLoading.value = true;
      
      await changeSubscriptionPlanUsecase.execute(newPlanId, immediateChange);
      
      showSuccessSnackbar(
        immediateChange 
            ? 'Plan cambiado inmediatamente' 
            : 'El cambio se aplicará al final del período actual'
      );
      
      await loadSubscriptionData();
      
    } catch (e) {
      showErrorSnackbar('Error al cambiar el plan: ${e.toString().replaceAll('Exception: ', '')}');
      print('Error changing subscription plan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelSubscription(bool cancelImmediately, String reason) async {
    try {
      if (!hasActiveSubscription.value) {
        showErrorSnackbar('No tienes una suscripción activa para cancelar');
        return;
      }

      if (reason.trim().isEmpty) {
        showErrorSnackbar('Por favor indica el motivo de la cancelación');
        return;
      }

      isCancelling.value = true;
      
      await postCancelSubcriptionUsecase.execute(cancelImmediately, reason);
      
      showSuccessSnackbar(
        cancelImmediately 
            ? 'Tu suscripción ha sido cancelada inmediatamente' 
            : 'Tu suscripción se cancelará al final del período actual'
      );
      
      await loadSubscriptionData();
      
    } catch (e) {
      showErrorSnackbar('Error al cancelar la suscripción: ${e.toString().replaceAll('Exception: ', '')}');
      print('Error cancelling subscription: $e');
    } finally {
      isCancelling.value = false;
    }
  }

  Color getButtonColor(String planName) {
    switch (planName.toUpperCase()) {
      case 'BÁSICO':
      case 'BASICO':
      case 'BASIC':
        return GerenaColors.secondaryColor;
      case 'PLUS':
      case 'BLACK':
        return GerenaColors.primaryColor;
      case 'ELITE':
        return Colors.red;
      default:
        return GerenaColors.primaryColor;
    }
  }

  bool hasGradientBorder(String planName) {
    return planName.toUpperCase() == 'ELITE';
  }

  bool hasGradientButton(String planName) {
    return planName.toUpperCase() == 'ELITE';
  }

  String getButtonText(int planId, String planName) {
    if (isCurrentPlan(planId)) {
      return 'MI PLAN ACTUAL';
    }
    
    if (hasActiveSubscription.value) {
      return 'CAMBIAR A ESTE PLAN';
    }
    
    // Diferenciar entre iOS y Android
    if (Platform.isIOS && isIAPAvailable.value) {
      return 'SUSCRIBIRSE';
    }
    
    if (planName.toUpperCase() == 'PLUS') {
      return 'DOMICILIAR PAGO';
    }
    
    return 'ELEGIR PLAN';
  }

  String getButtonAction(int planId) {
    if (isCurrentPlan(planId)) {
      return 'current';
    }
    
    if (hasActiveSubscription.value) {
      return 'change';
    }
    
    return 'subscribe';
  }

  @override
  void onClose() {
    if (Platform.isIOS) {
      _iapService.dispose();
    }
    super.onClose();
  }
}