import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/marketplace/domain/entities/payment/payment_method_entity.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/attach_payment_method_to_customer_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/create_payment_method_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/delete_payment_method_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/payment/get_payment_methods_usecase.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class PaymentCartController extends GetxController {
  final GetPaymentMethodsUsecase getPaymentMethodsUsecase;
  final CreatePaymentMethodUsecase createPaymentMethodUsecase;
  final AttachPaymentMethodToCustomerUsecase attachPaymentMethodToCustomerUsecase;
  final DeletePaymentMethodUsecase deletePaymentMethodUsecase;
  final AuthService authService = AuthService();

  PaymentCartController({
    required this.getPaymentMethodsUsecase,
    required this.createPaymentMethodUsecase,
    required this.attachPaymentMethodToCustomerUsecase,
    required this.deletePaymentMethodUsecase,
  });

  // Observables
  final RxList<PaymentMethodEntity> paymentMethods = <PaymentMethodEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isProcessing = false.obs;
  final RxString customerId = ''.obs;
  final Rx<CardFieldInputDetails?> cardDetails = Rx<CardFieldInputDetails?>(null);
  
  // Text Controllers
  final nameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvcController = TextEditingController();

  // Para validación manual
  final RxBool isManualCardValid = false.obs;

  // Detectar si es plataforma móvil
  bool get isMobilePlatform {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  @override
  void onInit() {
    super.onInit();
    loadPaymentMethods();
    
    // Escuchar cambios en los campos manuales para validación
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

  /// Validar campos manuales
  void _validateManualCard() {
    final cardNumber = cardNumberController.text.replaceAll(' ', '');
    final expiry = expiryController.text;
    final cvc = cvcController.text;

    // Validación básica
    final isCardNumberValid = cardNumber.length >= 15 && cardNumber.length <= 16;
    final isExpiryValid = expiry.length == 5 && expiry.contains('/');
    final isCvcValid = cvc.length >= 3 && cvc.length <= 4;

    isManualCardValid.value = isCardNumberValid && isExpiryValid && isCvcValid;
  }

  /// Actualizar los detalles de la tarjeta desde el CardFormField (móvil)
  void updateCardDetails(CardFieldInputDetails? details) {
    cardDetails.value = details;
    print('📝 Card changed: complete=${details?.complete}');
  }

  /// Validar si la tarjeta está completa
  bool get isCardValid {
    if (isMobilePlatform) {
      return cardDetails.value?.complete == true;
    } else {
      return isManualCardValid.value;
    }
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

      if (isMobilePlatform) {
        // Usar CardFormField nativo
        await addPaymentMethod(cardholderName: cardholderName);
      } else {
        // Usar campos manuales para escritorio
        await addPaymentMethodManual(cardholderName: cardholderName);
      }

      // Limpiar formularios
      nameController.clear();
      cardNumberController.clear();
      expiryController.clear();
      cvcController.clear();
      cardDetails.value = null;

      print('✅ Proceso completado exitosamente');
      return true;
      
    } catch (e) {
      print('❌ Error en handleAddCard: $e');
      return false;
    } finally {
      isProcessing.value = false;
    }
  }

  /// Agregar payment method con CardFormField (móvil)
  Future<void> addPaymentMethod({String? cardholderName}) async {
    try {
      isLoading.value = true;

      print('💳 Paso 1: Creando payment method...');
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

 /// Agregar payment method manualmente (escritorio)
Future<void> addPaymentMethodManual({String? cardholderName}) async {
  try {
    isLoading.value = true;

    // Parsear datos
    final cardNumber = cardNumberController.text.replaceAll(' ', '');
    final expiryParts = expiryController.text.split('/');
    final expMonth = int.parse(expiryParts[0].trim());
    final expYear = int.parse('20${expiryParts[1].trim()}');
    final cvc = cvcController.text;

    print('💳 Paso 1: Creando payment method con datos manuales...');
    
    // Crear PaymentMethod usando Stripe SDK
    final billingDetails = BillingDetails(
      name: cardholderName,
    );

    final paymentMethodParams = PaymentMethodParams.card(
      paymentMethodData: PaymentMethodData(
        billingDetails: billingDetails,
      ),
    );

    // Crear el payment method
    final paymentMethodResult = await Stripe.instance.createPaymentMethod(
      params: paymentMethodParams,
    );

    print('✅ Payment method creado: ${paymentMethodResult.id}');

    print('🔗 Paso 2: Adjuntando al customer...');
    await attachPaymentMethodToCustomerUsecase.execute(
      paymentMethodId: paymentMethodResult.id,
      customerId: customerId.value,
    );
    print('✅ Payment method adjuntado');

    // Convertir a entidad y agregar a la lista
    final paymentMethodEntity = PaymentMethodEntity(
      id: paymentMethodResult.id,
      last4: paymentMethodResult.card.last4 ?? '',
      brand: paymentMethodResult.card.brand ?? 'unknown', // ✅ Cambiado aquí
      expMonth: paymentMethodResult.card.expMonth ?? 0,
      expYear: paymentMethodResult.card.expYear ?? 0,
      cardholderName: cardholderName,
    );

    paymentMethods.add(paymentMethodEntity);
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
  Future<void> deletePaymentMethod(String paymentMethodId) async {
    try {
      print('🗑️ Eliminando tarjeta $paymentMethodId...');
      isLoading.value = true;

      await deletePaymentMethodUsecase.execute(paymentMethodId);
      paymentMethods.removeWhere((pm) => pm.id == paymentMethodId);

      showSuccessSnackbar('Tarjeta eliminada correctamente');
    } catch (e) {
      print('❌ Error: $e');
      showErrorSnackbar(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  /// Formatear número de tarjeta para display
  String formatCardNumber(String last4, String brand) {
    String brandPrefix = '';

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