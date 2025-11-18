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
     super.paymentMethodId,
  });

  // ✅ Cuando recibes datos de TU API (backend)
  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    final String cardId = json['id'] is int 
        ? json['id'].toString() 
        : json['id'] as String;
    
    // ✅ Usar paymentMethodId si existe, sino usar id
    final String methodId = json['paymentMethodId'] is int
        ? json['paymentMethodId'].toString()
        : (json['paymentMethodId'] as String? ?? cardId);

    return PaymentMethodModel(
      id: cardId,
      brand: (json['brand'] as String?) ?? 'unknown',
      last4: json['last4'] as String,
      expMonth: (json['expMonth'] as int?) ?? 0,
      expYear: (json['expYear'] as int?) ?? 0,
      cardholderName: json['cardholderName'] as String?,
      paymentMethodId: methodId, // ✅ Agregar paymentMethodId
    );
  }

  // ✅ Cuando recibes datos directamente de Stripe API
  factory PaymentMethodModel.fromStripeApi(Map<String, dynamic> json) {
    final String stripeId = json['id'] as String;
    
    return PaymentMethodModel(
      id: stripeId,
      brand: (json['card']['brand'] as String?) ?? 'unknown',
      last4: json['card']['last4'] as String,
      expMonth: (json['card']['exp_month'] as int?) ?? 0,
      expYear: (json['card']['exp_year'] as int?) ?? 0,
      cardholderName: json['billing_details']?['name'] as String?,
      paymentMethodId: stripeId, // ✅ En Stripe API, el id ES el paymentMethodId
    );
  }

  // ✅ Cuando usas flutter_stripe
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
      paymentMethodId: stripePaymentMethod.id, // ✅ El ID de Stripe es el paymentMethodId
    );
  }

  // ✅ Desde una entidad
  factory PaymentMethodModel.fromEntity(PaymentMethodEntity entity) {
    return PaymentMethodModel(
      id: entity.id,
      brand: entity.brand,
      last4: entity.last4,
      expMonth: entity.expMonth,
      expYear: entity.expYear,
      cardholderName: entity.cardholderName,
      paymentMethodId: entity.paymentMethodId,
    );
  }

  // ✅ Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'last4': last4,
      'expMonth': expMonth,
      'expYear': expYear,
      'cardholderName': cardholderName,
      'paymentMethodId': paymentMethodId, // ✅ Incluir paymentMethodId
    };
  }
}