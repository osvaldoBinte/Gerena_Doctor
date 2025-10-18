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
}

class OrderModel extends OrderEntity {
  OrderModel({
    required super.id,
    required super.doctorId,
    required super.doctorName,
    required super.total,
    required super.status,
    required super.shippingAddress,
    required super.city,
    required super.postalCode,
    required super.details,
    required super.createdAt,
    super.shippingDate,
    super.deliveryDate,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      doctorId: json['doctorId'] ?? 0,
      doctorName: json['doctorNombre'] ?? '',
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
      'doctorId': doctorId,
      'doctorNombre': doctorName,
      'total': total,
      'estado': status,
      'direccionEnvio': shippingAddress,
      'ciudad': city,
      'codigoPostal': postalCode,
      'detalles': details.map((d) => (d as OrderDetailModel).toJson()).toList(),
      'creadoEn': createdAt.toIso8601String(),
      'fechaEnvio': shippingDate?.toIso8601String(),
      'fechaEntrega': deliveryDate?.toIso8601String(),
    };
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
}