import 'dart:convert';

import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_response_entity.dart';

class ShoppingCartResponseModel extends ShoppingCartResponseEntity {
  ShoppingCartResponseModel(
      {required super.totalActual, required super.itenms});

  factory ShoppingCartResponseModel.fromJson(Map<String, dynamic> json) {
   return ShoppingCartResponseModel(
      totalActual: json['totalActual'] ?? 0,
      itenms: (json['items'] as List?)
              ?.map((order) => ItemModel.fromJson(order))
              .toList() ??
          [],
    );
  }
}

class ItemModel extends ItemEntity {
  ItemModel(
      {required super.medicamentoId,
      required super.nombreMedicamento,
      required super.cantidadSolicitada,
      required super.precioActual,
      required super.precioAnterior,
      required super.sinStock,
      super.descripcion,
      });
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
        medicamentoId: json['medicamentoId'],
        nombreMedicamento: json['nombreMedicamento'],
        cantidadSolicitada: json['cantidadSolicitada'],
        precioActual: json['precioActual'],
        precioAnterior: json['precioAnterior'],
        sinStock: json['sinStock'],
        descripcion: json['alerta']
        );
  }
}
