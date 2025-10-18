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
  final int doctorId;
  final String doctorName;
  final double total;
  final String status;
  final String shippingAddress;
  final String city;
  final int postalCode;
  final List<OrderDetailEntity> details;
  final DateTime createdAt;
  final DateTime? shippingDate;
  final DateTime? deliveryDate;

  OrderEntity({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.total,
    required this.status,
    required this.shippingAddress,
    required this.city,
    required this.postalCode,
    required this.details,
    required this.createdAt,
    this.shippingDate,
    this.deliveryDate,
  });
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