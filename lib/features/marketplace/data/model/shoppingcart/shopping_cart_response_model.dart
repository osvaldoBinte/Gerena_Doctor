import 'dart:convert';

import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_response_entity.dart';

class ShoppingCartResponseModel extends ShoppingCartResponseEntity {
  ShoppingCartResponseModel(
      {required super.totalActual, required super.itenms, required super.gastoEnvio, required super.iva});

  factory ShoppingCartResponseModel.fromJson(Map<String, dynamic> json) {
    return ShoppingCartResponseModel(
      totalActual: (json['totalActual'] ?? 0).toDouble(),
gastoEnvio: (json['gastosEnvio'] as num?)?.toInt() ?? 0,
iva: (json['iva'] as num?)?.toInt() ?? 0,

      itenms: (json['items'] as List?)
              ?.map((order) => ItemModel.fromJson(order))
              .toList() ??
          [],
    );
  }
}
class ItemModel extends ItemEntity {
  ItemModel({
    required super.medicamentoId,
    required super.nombreMedicamento,
    required super.cantidadSolicitada,
    required super.precioActual,
    required super.precioAnterior,
    required super.sinStock,
    super.alerta,
    super.categoria,
    super.imagen,
    super.oferta
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    String? imageUrl;
    if (json['imagen'] != null) {
      try {
        if (json['imagen'] is String) {
          final List<dynamic> imageList = jsonDecode(json['imagen']);
          if (imageList.isNotEmpty) {
            imageUrl = imageList[0].toString();
          }
        } 
        else if (json['imagen'] is List) {
          final List<dynamic> imageList = json['imagen'];
          if (imageList.isNotEmpty) {
            imageUrl = imageList[0].toString();
          }
        }
      } catch (e) {
        print('❌ Error parseando imagen: $e');
        imageUrl = null;
      }
    }

    return ItemModel(
      medicamentoId: json['medicamentoId'],
      nombreMedicamento: json['nombreMedicamento'],
      cantidadSolicitada: json['cantidadSolicitada'],
      precioActual: (json['precioActual'] ?? 0).toDouble(),
      precioAnterior: (json['precioAnterior'] ?? 0).toDouble(),
      sinStock: json['sinStock'] ?? false,
      alerta: json['alerta'],
      categoria: json['categoria'],
      imagen: imageUrl, 
      oferta: json['oferta']
    );
  }
}
