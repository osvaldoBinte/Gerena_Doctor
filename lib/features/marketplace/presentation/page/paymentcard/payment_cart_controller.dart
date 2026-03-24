import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/marketplace/domain/entities/payment/payment_method_entity.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/attach_payment_method_to_customer_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/create_payment_method_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/delete_payment_method_back_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/delete_payment_method_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/get_payment_methods_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/savecard_usecase.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class PaymentCartController extends GetxController {
  final GetPaymentMethodsUsecase getPaymentMethodsUsecase;
  final CreatePaymentMethodUsecase createPaymentMethodUsecase;
  final AttachPaymentMethodToCustomerUsecase attachPaymentMethodToCustomerUsecase;
  final DeletePaymentMethodUsecase deletePaymentMethodUsecase;
  final DeletePaymentMethodBackUsecase deletePaymentMethodBackUsecase;
  final SavecardUsecase savecardUsecase;
  final AuthService authService = AuthService();

  PaymentCartController({
    required this.getPaymentMethodsUsecase,
    required this.createPaymentMethodUsecase,
    required this.attachPaymentMethodToCustomerUsecase,
    required this.deletePaymentMethodUsecase,
    required this.savecardUsecase,
    required this.deletePaymentMethodBackUsecase,
  });

  // Observables
  final RxList<PaymentMethodEntity> paymentMethods = <PaymentMethodEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isProcessing = false.obs;
  final RxString customerId = ''.obs;

  // CardField solo para iOS
  final Rx<CardFieldInputDetails?> cardDetails = Rx<CardFieldInputDetails?>(null);

  // Text Controllers
  final nameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvcController = TextEditingController();

  // Validación manual (Android + Desktop)
  final RxBool isManualCardValid = false.obs;

  // Detectar plataforma
  bool get isMobilePlatform {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  // 👇 iOS usa CardField nativo, Android y Desktop usan campos manuales
  bool get useNativeCardField {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  @override
  void onInit() {
    super.onInit();
    loadPaymentMethods();
    cardNumberController.addListener(_validateManualCard);
    expiryController.addListener(_validateManualCard);
    cvcController.addListener(_validateManualCard);
  }

  @override
  void onClose() {
    nameController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvcController.dispose();
    super.onClose();
  }

  /// Validar campos manuales (Android + Desktop)
  void _validateManualCard() {
    final cardNumber = cardNumberController.text.replaceAll(' ', '');
    final expiry = expiryController.text;
    final cvc = cvcController.text;

    final isCardNumberValid = cardNumber.length >= 15 && cardNumber.length <= 16;
    final isExpiryValid = expiry.length == 5 && expiry.contains('/');
    final isCvcValid = cvc.length >= 3 && cvc.length <= 4;

    isManualCardValid.value = isCardNumberValid && isExpiryValid && isCvcValid;
  }

  /// Actualizar detalles desde CardField (solo iOS)
  void updateCardDetails(CardFieldInputDetails? details) {
    cardDetails.value = details;
    print('📝 Card changed: complete=${details?.complete}');
  }

  /// Validar si la tarjeta está completa
  bool get isCardValid {
    if (useNativeCardField) {
      // iOS: usar CardField
      return cardDetails.value?.complete == true;
    }
    // Android + Desktop: usar campos manuales
    return isManualCardValid.value;
  }

  /// Cargar métodos de pago
  Future<void> loadPaymentMethods() async {
    try {
      print('📥 Cargando métodos de pago...');
      isLoading.value = true;

      customerId.value = await authService.getStripeCustomerId() ??
          (throw Exception('No se encontró el ID de cliente de Stripe.'));
      print('👤 Customer ID: ${customerId.value}');

      final methods = await getPaymentMethodsUsecase.execute();
      paymentMethods.value = methods;
      print('✅ ${methods.length} tarjetas cargadas');
    } catch (e) {
      print('❌ Error: $e');
      showErrorSnackbar(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  /// Manejar el proceso completo de agregar tarjeta
  Future<bool> handleAddCard() async {
    if (!isCardValid) {
      showErrorSnackbar('Por favor completa todos los datos de la tarjeta');
      return false;
    }

    isProcessing.value = true;

    try {
      print('💳 Iniciando proceso de agregar tarjeta...');
      final cardholderName = nameController.text.isNotEmpty
          ? nameController.text
          : null;

      if (useNativeCardField) {
        // iOS: CardField nativo → createPaymentMethodUsecase usa el CardField internamente
        await addPaymentMethod(cardholderName: cardholderName);
      } else {
        // Android + Desktop: campos manuales → Stripe.instance.createPaymentMethod
        await addPaymentMethodManual(cardholderName: cardholderName);
      }

      // Limpiar formularios
      nameController.clear();
      cardNumberController.clear();
      expiryController.clear();
      cvcController.clear();
      cardDetails.value = null;
      isManualCardValid.value = false;

      print('✅ Proceso completado exitosamente');
      return true;
    } catch (e) {
      print('❌ Error en handleAddCard: $e');
      return false;
    } finally {
      isProcessing.value = false;
    }
  }

  /// Agregar payment method con CardField (solo iOS)
  Future<void> addPaymentMethod({String? cardholderName}) async {
    try {
      isLoading.value = true;

      print('💳 Paso 1: Creando payment method (iOS CardField)...');
      final paymentMethod = await createPaymentMethodUsecase.execute(
        cardholderName: cardholderName,
      );
      print('✅ Payment method creado: ${paymentMethod.id}');

      print('🔗 Paso 2: Adjuntando al customer...');
      await attachPaymentMethodToCustomerUsecase.execute(
        paymentMethodId: paymentMethod.id,
        customerId: customerId.value,
      );
      print('✅ Payment method adjuntado');

      print('💾 Paso 3: Guardando tarjeta en backend...');
      await savecardUsecase.execute(paymentMethod.id);
      print('✅ Tarjeta guardada en backend');

      paymentMethods.add(paymentMethod);
      showSuccessSnackbar('Tarjeta agregada correctamente');
    } catch (e) {
      print('❌ Error: $e');
      showErrorSnackbar(e.toString().replaceAll('Exception: ', ''));
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

 Future<void> addPaymentMethodManual({String? cardholderName}) async {
  try {
    isLoading.value = true;

    final rawNumber = cardNumberController.text.replaceAll(' ', '');
    final expiryParts = expiryController.text.split('/');
    final expMonth = int.tryParse(expiryParts[0]) ?? 0;
    final expYearShort = int.tryParse(
      expiryParts.length > 1 ? expiryParts[1] : '',
    ) ?? 0;
    final expYear = expYearShort < 100 ? 2000 + expYearShort : expYearShort;
    final cvc = cvcController.text;

    print('💳 Paso 1: Inyectando datos de tarjeta...');
    await Stripe.instance.dangerouslyUpdateCardDetails(
      CardDetails(
        number: rawNumber,
        expirationMonth: expMonth,
        expirationYear: expYear,
        cvc: cvc,
      ),
    );

    print('💳 Paso 2: Creando payment method...');
    final billingDetails = BillingDetails(name: cardholderName);

    final paymentMethodResult = await Stripe.instance.createPaymentMethod(
      params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: billingDetails,
        ),
      ),
    );
    print('✅ Payment method creado: ${paymentMethodResult.id}');

    print('🔗 Paso 3: Adjuntando al customer...');
    await attachPaymentMethodToCustomerUsecase.execute(
      paymentMethodId: paymentMethodResult.id,
      customerId: customerId.value,
    );
    print('✅ Payment method adjuntado');

    print('💾 Paso 4: Guardando en backend...');
    await savecardUsecase.execute(paymentMethodResult.id);
    print('✅ Tarjeta guardada en backend');

    // 👇 Recargar lista desde backend para evitar problemas Entity vs Model
    await loadPaymentMethods();
    showSuccessSnackbar('Tarjeta agregada correctamente');

  } catch (e) {
    print('❌ Error: $e');
    showErrorSnackbar(e.toString().replaceAll('Exception: ', ''));
    rethrow;
  } finally {
    isLoading.value = false;
  }
}
  /// Eliminar payment method
  Future<void> deletePaymentMethod(String backendId, {String? stripeId}) async {
    try {
      print('🗑️ Eliminando tarjeta...');
      print('📍 Backend ID: $backendId');
      print('📍 Stripe ID: $stripeId');
      isLoading.value = true;

      final paymentMethod = paymentMethods.firstWhere(
        (pm) => pm.id == backendId,
        orElse: () => throw Exception('Tarjeta no encontrada'),
      );

      final stripePaymentId = stripeId ?? paymentMethod.paymentMethodId;

      if (stripePaymentId == null) {
        throw Exception('No se encontró el ID de Stripe para esta tarjeta');
      }

      print('🔹 Paso 1: Eliminando de Stripe ($stripePaymentId)...');
      await deletePaymentMethodUsecase.execute(stripePaymentId);
      print('✅ Eliminado de Stripe');

      print('🔹 Paso 2: Eliminando del backend (ID: $backendId)...');
      final backendIdInt = int.tryParse(backendId);
      if (backendIdInt == null) throw Exception('ID del backend inválido');
      await deletePaymentMethodBackUsecase.execute(backendIdInt);
      print('✅ Eliminado del backend');

      paymentMethods.removeWhere((pm) => pm.id == backendId);
      showSuccessSnackbar('Tarjeta eliminada correctamente');
    } catch (e) {
      print('❌ Error al eliminar: $e');
      showErrorSnackbar(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  /// Formatear número de tarjeta para display
  String formatCardNumber(String last4, String brand) {
    String brandPrefix;
    switch (brand.toLowerCase()) {
      case 'visa':
        brandPrefix = 'VISA';
        break;
      case 'mastercard':
        brandPrefix = 'Mastercard';
        break;
      case 'amex':
        brandPrefix = 'AMEX';
        break;
      default:
        brandPrefix = brand.toUpperCase();
    }
    return '$brandPrefix •••• $last4';
  }
}