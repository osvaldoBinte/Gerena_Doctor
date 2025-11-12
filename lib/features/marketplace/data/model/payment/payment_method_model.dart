import 'package:gerena/features/marketplace/domain/entities/payment/payment_method_entity.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

class PaymentMethodModel extends PaymentMethodEntity {
  PaymentMethodModel({
    required super.id,
    required super.brand,
    required super.last4,
    required super.expMonth,
    required super.expYear,
    super.cardholderName,
  });

  // Este método es para cuando recibes datos de TU API (backend)
  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(id: json['id'] is int 
    ? json['id'].toString() 
    : json['id'] as String, // Cambiado de 'id' a 'paymentMethodId'
      brand: (json['brand'] as String?) ?? 'unknown',
      last4: json['last4'] as String,
      expMonth: (json['expMonth'] as int?) ?? 0, // Cambiado de 'exp_month' a 'expMonth'
      expYear: (json['expYear'] as int?) ?? 0, // Cambiado de 'exp_year' a 'expYear'
      cardholderName: null, // Tu API no devuelve este campo
    );
  }

  // Este método es para cuando recibes datos directamente de Stripe
  factory PaymentMethodModel.fromStripeApi(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] as String,
      brand: (json['card']['brand'] as String?) ?? 'unknown',
      last4: json['card']['last4'] as String,
      expMonth: (json['card']['exp_month'] as int?) ?? 0,
      expYear: (json['card']['exp_year'] as int?) ?? 0,
      cardholderName: json['billing_details']?['name'] as String?,
    );
  }

  // Este método es para cuando usas flutter_stripe
  factory PaymentMethodModel.fromStripe(
    stripe.PaymentMethod stripePaymentMethod,
    String? cardholderName,
  ) {
    return PaymentMethodModel(
      id: stripePaymentMethod.id,
      brand: stripePaymentMethod.card.brand?.toString().split('.').last.toLowerCase() ?? 'unknown',
      last4: stripePaymentMethod.card.last4 ?? '',
      expMonth: stripePaymentMethod.card.expMonth ?? 0,
      expYear: stripePaymentMethod.card.expYear ?? 0,
      cardholderName: cardholderName,
    );
  }

  factory PaymentMethodModel.fromEntity(PaymentMethodEntity entity) {
    return PaymentMethodModel(
      id: entity.id,
      brand: entity.brand,
      last4: entity.last4,
      expMonth: entity.expMonth,
      expYear: entity.expYear,
      cardholderName: entity.cardholderName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentMethodId': id,
      'brand': brand,
      'last4': last4,
      'expMonth': expMonth,
      'expYear': expYear,
      'cardholderName': cardholderName,
    };
  }
}