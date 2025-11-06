import 'package:gerena/common/constants/constants.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentCartController extends GetxController {
  final RxList<PaymentMethod> paymentMethods = <PaymentMethod>[].obs;
  final RxBool isLoading = false.obs;
  

  final String stripePublishableKey = AppConstants.stripePublishableKey;
  final String stripeSecretKey = AppConstants.stripeSecretKey;
  final String apiUrl = 'https://api.stripe.com/v1';
  
  @override
  void onInit() {
    super.onInit();
    initializeStripe();
    loadPaymentMethods();
  }
  
  void initializeStripe() {
    try {
      print('🔧 Inicializando Stripe...');
      Stripe.publishableKey = stripePublishableKey;
      print('✅ Stripe inicializado correctamente');
    } catch (e) {
      print('❌ Error al inicializar Stripe: $e');
    }
  }
  
  Future<void> loadPaymentMethods() async {
    try {
      print('📥 Cargando métodos de pago...');
      isLoading.value = true;
      
      String customerId = await getCustomerId();
      print('👤 Customer ID: $customerId');
      
      final response = await http.get(
        Uri.parse('$apiUrl/customers/$customerId/payment_methods?type=card'),
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      
      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        paymentMethods.clear();
        
        for (var pm in data['data']) {
          paymentMethods.add(PaymentMethod.fromJson(pm));
        }
        print('✅ Tarjetas cargadas: ${paymentMethods.length}');
      } else {
        print('❌ Error al cargar tarjetas: ${response.statusCode}');
        Get.snackbar(
          'Error',
          'No se pudieron cargar las tarjetas',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('❌ Exception al cargar tarjetas: $e');
      Get.snackbar(
        'Error',
        'Error al cargar tarjetas: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
Future<void> addCardWithDetails({
  required String cardNumber,
  required int expMonth,
  required int expYear,
  required String cvv,
  required String name,
}) async {
  try {
    print('💳 Iniciando proceso de agregar tarjeta...');
    print('📝 Datos - Nombre: $name, Mes: $expMonth, Año: $expYear');
    print('📝 Número: ${cardNumber.substring(0, 4)}****');
    
    isLoading.value = true;

    // CRÍTICO: Primero establecer los detalles de la tarjeta en Stripe
    print('🔄 Estableciendo detalles de tarjeta en Stripe...');
    await Stripe.instance.dangerouslyUpdateCardDetails(
      CardDetails(
        number: cardNumber,
        expirationMonth: expMonth,
        expirationYear: expYear,
        cvc: cvv,
      ),
    );
    print('✅ CardDetails establecido en Stripe');

    // Ahora crear el payment method (ya tiene los datos de la tarjeta)
    print('🔄 Creando payment method...');
    final paymentMethod = await Stripe.instance.createPaymentMethod(
      params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: BillingDetails(
            name: name,
          ),
        ),
      ),
    );
    print('✅ Payment method creado: ${paymentMethod.id}');

    // Adjuntar payment method al customer
    print('🔄 Adjuntando payment method al customer...');
    await attachPaymentMethodToCustomer(paymentMethod.id);
    print('✅ Payment method adjuntado');

    // Recargar métodos de pago
    print('🔄 Recargando lista de tarjetas...');
    await loadPaymentMethods();
    print('✅ Lista recargada');

  } catch (e, stackTrace) {
    print('❌ Error al agregar tarjeta: $e');
    print('📍 Stack trace: $stackTrace');
    throw Exception('Error al agregar tarjeta: $e');
  } finally {
    isLoading.value = false;
  }
}

  Future<void> attachPaymentMethodToCustomer(String paymentMethodId) async {
    try {
      print('🔗 Adjuntando payment method $paymentMethodId...');
      String customerId = await getCustomerId();

      final response = await http.post(
        Uri.parse('$apiUrl/payment_methods/$paymentMethodId/attach'),
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'customer': customerId,
        },
      );

      print('📡 Attach response status: ${response.statusCode}');
      print('📡 Attach response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Error al adjuntar tarjeta al cliente: ${response.body}');
      }
      print('✅ Tarjeta adjuntada correctamente');
    } catch (e) {
      print('❌ Error en attachPaymentMethodToCustomer: $e');
      throw Exception('Error: $e');
    }
  }
  
  Future<void> deletePaymentMethod(String paymentMethodId) async {
    try {
      print('🗑️ Eliminando tarjeta $paymentMethodId...');
      isLoading.value = true;
      
      final response = await http.post(
        Uri.parse('$apiUrl/payment_methods/$paymentMethodId/detach'),
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      
      print('📡 Delete response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        paymentMethods.removeWhere((pm) => pm.id == paymentMethodId);
        print('✅ Tarjeta eliminada');
        Get.snackbar(
          'Éxito',
          'Tarjeta eliminada correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('❌ Error al eliminar: $e');
      Get.snackbar(
        'Error',
        'Error al eliminar tarjeta: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<String> getCustomerId() async {
    // TODO: Implementar obtención real del customer ID desde tu backend
    print('⚠️ Usando customer ID de prueba - IMPLEMENTAR BACKEND');
    return 'cus_TMYQHP4BxblMrT';
  }
  
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

class PaymentMethod {
  final String id;
  final String brand;
  final String last4;
  final int expMonth;
  final int expYear;
  
  PaymentMethod({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
  });
  
  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      brand: json['card']['brand'],
      last4: json['card']['last4'],
      expMonth: json['card']['exp_month'],
      expYear: json['card']['exp_year'],
    );
  }
}