import 'package:gerena/features/marketplace/domain/entities/descuentopuntos/descuento_puntos_entity.dart';

class DescuentoPuntosModel extends DescuentoPuntosEntity {
  DescuentoPuntosModel({
    required super.availablePoints,
    required super.pointsToUse,
    required super.totalDiscount,
    required super.originalTotal,
    required super.totalWithDiscount,
  });

  factory DescuentoPuntosModel.fromJson(Map<String, dynamic> json) {
    return DescuentoPuntosModel(
      availablePoints: json['puntosDisponibles'] ?? 0,
      pointsToUse: json['puntosAUsar'] ?? 0,

      totalDiscount: (json['descuentoTotal'] as num?)?.toDouble() ?? 0.0,
      originalTotal: (json['totalOriginal'] as num?)?.toDouble() ?? 0.0,
      totalWithDiscount: (json['totalConDescuento'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
