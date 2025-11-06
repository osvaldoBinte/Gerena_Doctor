
import 'package:gerena/features/marketplace/domain/entities/payment/payment_method_entity.dart';

class PaymentMethodModel extends PaymentMethodEntity {
  PaymentMethodModel({
    required super.id,
    required super.brand,
    required super.last4,
    required super.expMonth,
    required super.expYear,
    super.cardholderName,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] as String,
      brand: json['card']['brand'] as String,
      last4: json['card']['last4'] as String,
      expMonth: json['card']['exp_month'] as int,
      expYear: json['card']['exp_year'] as int,
      cardholderName: json['billing_details']?['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'last4': last4,
      'exp_month': expMonth,
      'exp_year': expYear,
      'cardholder_name': cardholderName,
    };
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
}