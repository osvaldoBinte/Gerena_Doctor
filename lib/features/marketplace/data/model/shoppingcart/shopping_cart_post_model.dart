import 'dart:convert';

import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_post_entity.dart';

class ShoppingCartPostModel extends ShoppingCartPostEntity {
  ShoppingCartPostModel(
      {required super.medicamentoId,
      required super.cantidad,
      required super.precioGuardado});

  factory ShoppingCartPostModel.fromEntity(ShoppingCartPostEntity entity) {
    return ShoppingCartPostModel(
        medicamentoId: entity.medicamentoId,
        cantidad: entity.cantidad,
        precioGuardado: entity.precioGuardado);
  }
  Map<String,dynamic> toJson(){
    return{
      'medicamentoId':medicamentoId,
      'cantidad':cantidad,
      'precioGuardado':precioGuardado
    };
  }
}
