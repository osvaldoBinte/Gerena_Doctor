class OrdersResponseEntity {
  final int total;
  final List<OrderEntity> orders;

  OrdersResponseEntity({
    required this.total,
    required this.orders,
  });
}

class OrderEntity {
  final int id;
  final String? folio;
  final int doctorId;
  final String doctorName;
  final double totalOriginal;
  final double discountByPoints;
  final int pointsUsed;
  final double total;
  final String status;
  final String shippingAddress;
  final String city;
  final int postalCode;
  final List<OrderDetailEntity> details;
  final DateTime createdAt;
  final String? shippingStatus;
  final DateTime? shippingDate;
  final DateTime? deliveryDate;

  OrderEntity({
    required this.id,
    this.folio,
    required this.doctorId,
    required this.doctorName,
    required this.totalOriginal,
    required this.discountByPoints,
    required this.pointsUsed,
    required this.total,
    required this.status,
    required this.shippingAddress,
    required this.city,
    required this.postalCode,
    required this.details,
    required this.createdAt,
    this.shippingStatus,
    this.shippingDate,
    this.deliveryDate,
  });

  bool get hasFolio => folio != null && folio!.isNotEmpty;
  
  bool get hasDiscount => discountByPoints > 0;
}

class OrderDetailEntity {
  final int medicationId;
  final String medicationName;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  OrderDetailEntity({
    required this.medicationId,
    required this.medicationName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });
}