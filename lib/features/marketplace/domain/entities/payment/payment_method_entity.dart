class PaymentMethodEntity {
  final String id;
  final String brand;
  final String last4;
  final int expMonth;
  final int expYear;
  final String? cardholderName;
   String? paymentMethodId;

  PaymentMethodEntity({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    this.cardholderName,
     this.paymentMethodId
  });

  String get formattedCardNumber {
    String brandPrefix = brand.toUpperCase();
    return '$brandPrefix •••• $last4';
  }

  String get formattedExpiry => '$expMonth/${expYear.toString().substring(2)}';
}