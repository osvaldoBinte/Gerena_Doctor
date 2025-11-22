import 'package:gerena/features/marketplace/domain/entities/orders/orders_entity.dart';

class OrdersResponseModel extends OrdersResponseEntity {
  OrdersResponseModel({
    required super.total,
    required super.orders,
  });

  factory OrdersResponseModel.fromJson(Map<String, dynamic> json) {
    return OrdersResponseModel(
      total: json['total'] ?? 0,
      orders: (json['pedidos'] as List?)
              ?.map((order) => OrderModel.fromJson(order))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'pedidos': orders.map((o) => (o as OrderModel).toJson()).toList(),
    };
  }
}

class OrderModel extends OrderEntity {
  OrderModel({
    required super.id,
    super.folio,
    required super.doctorId,
    required super.doctorName,
    required super.totalOriginal,
    required super.discountByPoints,
    required super.pointsUsed,
    required super.total,
    required super.status,
    required super.shippingAddress,
    required super.city,
    required super.postalCode,
    required super.details,
    required super.createdAt,
    super.shippingStatus,
    super.shippingDate,
    super.deliveryDate,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      folio: json['folio'], // Puede ser null
      doctorId: json['doctorId'] ?? 0,
      doctorName: json['doctorNombre'] ?? '',
      totalOriginal: (json['totalOriginal'] ?? 0).toDouble(),
      discountByPoints: (json['descuentoPorPuntos'] ?? 0).toDouble(),
      pointsUsed: json['puntosUtilizados'] ?? 0,
      total: (json['total'] ?? 0).toDouble(),
      status: json['estado'] ?? '',
      shippingAddress: json['direccionEnvio'] ?? '',
      city: json['ciudad'] ?? '',
      postalCode: json['codigoPostal'] ?? 0,
      details: (json['detalles'] as List?)
              ?.map((detail) => OrderDetailModel.fromJson(detail))
              .toList() ??
          [],
      createdAt: json['creadoEn'] != null
          ? DateTime.parse(json['creadoEn'])
          : DateTime.now(),
      shippingStatus: json['estadoEnvio'], // Puede ser null o ""
      shippingDate: json['fechaEnvio'] != null
          ? DateTime.parse(json['fechaEnvio'])
          : null,
      deliveryDate: json['fechaEntrega'] != null
          ? DateTime.parse(json['fechaEntrega'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'folio': folio,
      'doctorId': doctorId,
      'doctorNombre': doctorName,
      'totalOriginal': totalOriginal,
      'descuentoPorPuntos': discountByPoints,
      'puntosUtilizados': pointsUsed,
      'total': total,
      'estado': status,
      'direccionEnvio': shippingAddress,
      'ciudad': city,
      'codigoPostal': postalCode,
      'detalles': details.map((d) => (d as OrderDetailModel).toJson()).toList(),
      'creadoEn': createdAt.toIso8601String(),
      'estadoEnvio': shippingStatus,
      'fechaEnvio': shippingDate?.toIso8601String(),
      'fechaEntrega': deliveryDate?.toIso8601String(),
    };
  }

  // Factory adicional para crear desde un pedido individual (segundo JSON)
  factory OrderModel.fromSingleJson(Map<String, dynamic> json) {
    return OrderModel.fromJson(json);
  }

  // Método de conveniencia para copiar con modificaciones
  OrderModel copyWith({
    int? id,
    String? folio,
    int? doctorId,
    String? doctorName,
    double? totalOriginal,
    double? discountByPoints,
    int? pointsUsed,
    double? total,
    String? status,
    String? shippingAddress,
    String? city,
    int? postalCode,
    List<OrderDetailEntity>? details,
    DateTime? createdAt,
    String? shippingStatus,
    DateTime? shippingDate,
    DateTime? deliveryDate,
  }) {
    return OrderModel(
      id: id ?? this.id,
      folio: folio ?? this.folio,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      totalOriginal: totalOriginal ?? this.totalOriginal,
      discountByPoints: discountByPoints ?? this.discountByPoints,
      pointsUsed: pointsUsed ?? this.pointsUsed,
      total: total ?? this.total,
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
      shippingStatus: shippingStatus ?? this.shippingStatus,
      shippingDate: shippingDate ?? this.shippingDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
    );
  }
}

class OrderDetailModel extends OrderDetailEntity {
  OrderDetailModel({
    required super.medicationId,
    required super.medicationName,
    required super.quantity,
    required super.unitPrice,
    required super.subtotal,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      medicationId: json['medicamentoId'] ?? 0,
      medicationName: json['medicamentoNombre'] ?? '',
      quantity: json['cantidad'] ?? 0,
      unitPrice: (json['precioUnitario'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicamentoId': medicationId,
      'medicamentoNombre': medicationName,
      'cantidad': quantity,
      'precioUnitario': unitPrice,
      'subtotal': subtotal,
    };
  }

  OrderDetailModel copyWith({
    int? medicationId,
    String? medicationName,
    int? quantity,
    double? unitPrice,
    double? subtotal,
  }) {
    return OrderDetailModel(
      medicationId: medicationId ?? this.medicationId,
      medicationName: medicationName ?? this.medicationName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      subtotal: subtotal ?? this.subtotal,
    );
  }
}