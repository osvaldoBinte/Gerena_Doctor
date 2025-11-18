import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:gerena/features/marketplace/data/model/payment/payment_method_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/common/errors/api_errors.dart';

class PaymentDataSourcesImp {
 late final http.Client client; 
   String defaultApiServer = AppConstants.serverBase;

  String defaultApiServerStripe = AppConstants.serverBaseStripe;
  String stripeSecretKey = AppConstants.stripeSecretKey;
  String stripePublishableKey = AppConstants.stripePublishableKey;

  PaymentDataSourcesImp() { 
    client = http.Client(); 
    _initializeStripe();
  }


  Map<String, String> get _stripeHeaders => {
        'Authorization': 'Bearer $stripeSecretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

  void _initializeStripe() {
    try {
      print('🔧 Inicializando Stripe...');
      stripe.Stripe.publishableKey = stripePublishableKey;
      print('✅ Stripe inicializado correctamente');
    } catch (e) {
      print('❌ Error al inicializar Stripe: $e');
      throw Exception('Error al inicializar Stripe');
    }
  }Future<List<PaymentMethodModel>> getPaymentMethods( String token) async {
  try {
     Uri url = Uri.parse(
        '$defaultApiServer/doctores/payment-methods');
    
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });


    if (response.statusCode == 200) {
      final dataUTF8 = utf8.decode(response.bodyBytes);
      final responseDecode = jsonDecode(dataUTF8);

      final List paymentMethodsData = responseDecode;

      final List<PaymentMethodModel> paymentMethods = paymentMethodsData
          .map((json) => PaymentMethodModel.fromJson(json))
          .toList();

      print('✅ ${paymentMethods.length} tarjetas obtenidas');
      return paymentMethods;
    }

    ApiExceptionCustom exception = ApiExceptionCustom(response: response);
    exception.validateMesage();
    throw exception;
  } catch (e) {
    if (e is SocketException ||
        e is http.ClientException ||
        e is TimeoutException) {
      throw Exception(convertMessageException(error: e));
    }
    print('❌ Error: $e');
    throw Exception('$e');
  }
}


Future<PaymentMethodModel> createPaymentMethod({
  String? cardholderName,
}) async {
  try {
    print('💳 Creando payment method en Stripe...');

    // 1. Crear con el SDK de Stripe
    final stripePaymentMethod = await stripe.Stripe.instance.createPaymentMethod(
      params: stripe.PaymentMethodParams.card(
        paymentMethodData: stripe.PaymentMethodData(
          billingDetails: stripe.BillingDetails(
            name: cardholderName,
          ),
        ),
      ),
    );

    print('✅ Payment method creado: ${stripePaymentMethod.id}');

    // 2. Convertir usando el factory method fromStripe
    final paymentMethodModel = PaymentMethodModel.fromStripe(
      stripePaymentMethod,
      cardholderName,
    );

    print('✅ Convertido a PaymentMethodModel');
    return paymentMethodModel;
    
  } on stripe.StripeException catch (e) {
    print('❌ Stripe error: ${e.error.message}');
    throw Exception(e.error.localizedMessage ?? 'Error al crear método de pago');
  } catch (e) {
    print('❌ Error inesperado: $e');
    throw Exception('Error al crear método de pago');
  }
}

  /// Adjuntar payment method a un customer
  Future<void> attachPaymentMethodToCustomer({
    required String paymentMethodId,
    required String customerId,
  }) async {
    try {
      print('🔗 Adjuntando payment method: $paymentMethodId');

      final response = await client.post(
        Uri.parse('$defaultApiServerStripe/payment_methods/$paymentMethodId/attach'),
        headers: _stripeHeaders,
        body: {'customer': customerId},
      );

      if (response.statusCode == 200) {
        print('✅ Payment method adjuntado');
        return;
      }

      ApiExceptionCustom exception = ApiExceptionCustom(response: response);
      exception.validateMesage();
      throw exception;
    } catch (e) {
      if (e is SocketException ||
          e is http.ClientException ||
          e is TimeoutException) {
        throw Exception(convertMessageException(error: e));
      }
      print('❌ Error: $e');
      throw Exception('$e');
    }
  }

  /// Eliminar (detach) payment method
  Future<void> detachPaymentMethod(String paymentMethodId) async {
    try {
      print('🗑️ Eliminando payment method: $paymentMethodId');

      final response = await client.post(
        Uri.parse('$defaultApiServerStripe/payment_methods/$paymentMethodId/detach'),
        headers: _stripeHeaders,
      );

      if (response.statusCode == 200) {
        print('✅ Payment method eliminado');
        return;
      }

      ApiExceptionCustom exception = ApiExceptionCustom(response: response);
      exception.validateMesage();
      throw exception;
    } catch (e) {
      if (e is SocketException ||
          e is http.ClientException ||
          e is TimeoutException) {
        throw Exception(convertMessageException(error: e));
      }
      print('❌ Error: $e');
      throw Exception('$e');
    }
  }

  /// Crear customer en Stripe
  Future<String> createCustomer({
    required String email,
    String? name,
    String? phone,
  }) async {
    try {
      print('👤 Creando customer en Stripe...');

      final body = {
        'email': email,
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
      };

      final response = await client.post(
        Uri.parse('$defaultApiServerStripe/customers'),
        headers: _stripeHeaders,
        body: body,
      );

      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);
        final customerId = responseDecode['id'] as String;
        print('✅ Customer creado: $customerId');
        return customerId;
      }

      ApiExceptionCustom exception = ApiExceptionCustom(response: response);
      exception.validateMesage();
      throw exception;
    } catch (e) {
      if (e is SocketException ||
          e is http.ClientException ||
          e is TimeoutException) {
        throw Exception(convertMessageException(error: e));
      }
      print('❌ Error: $e');
      throw Exception('$e');
    }
  }


 Future<void> createPayment(String token, String paymentMethodId) async {
  try {
    Uri url = Uri.parse('$defaultApiServer/doctores/payment-methods');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode({
        'paymentMethodId': paymentMethodId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    ApiExceptionCustom exception = ApiExceptionCustom(response: response);
    exception.validateMesage();
    throw exception;
  } catch (e) {
    if (e is SocketException ||
        e is http.ClientException ||
        e is TimeoutException) {
      throw Exception(convertMessageException(error: e));
    }
    throw Exception('$e');
  }
}

  Future<void> saveCustomerIdToBackend({
    required String customerId,
    required String token,
  }) async {
    try {
      print('💾 Guardando customer ID en backend...');

      print('⚠️ Método saveCustomerIdToBackend no implementado');
    } catch (e) {
      if (e is SocketException ||
          e is http.ClientException ||
          e is TimeoutException) {
        throw Exception(convertMessageException(error: e));
      }
      print('❌ Error: $e');
      throw Exception('$e');
    }
  }
Future<void> confirmpayment(int id, String token, ) async {
  try {
    Uri url = Uri.parse('$defaultApiServer/doctores/payment-methods/default');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({'paymentMethodId': id}),
    );
    
    if (response.statusCode == 200) {
      return;
    }

    ApiExceptionCustom exception = ApiExceptionCustom(response: response);
    exception.validateMesage();
    throw exception;
    
  } catch (e) {
    if (e is SocketException ||
        e is http.ClientException ||
        e is TimeoutException) {
      throw Exception(convertMessageException(error: e));
    }
    
    // ✅ Si es ApiExceptionCustom, re-lanzarla sin envolver
    if (e is ApiExceptionCustom) {
      rethrow;
    }
    
    print('error: $e');
    throw Exception('$e');
  }
}


  Future<void> savecard( String paymentMethodId, String token) async {
    try {
      Uri url = Uri.parse('${AppConstants.serverBase}/doctores/payment-methods');
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(<String, dynamic>{
            'paymentMethodId': paymentMethodId,
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }
      ApiExceptionCustom exception = ApiExceptionCustom(response: response);
      exception.validateMesage();
      throw exception;
    } catch (e) {
      if (e is SocketException ||
          e is http.ClientException ||
          e is TimeoutException) {
        throw Exception(convertMessageException(error: e));
      }
      print('error: $e');
      throw Exception('$e');
      
    }
  } 
}