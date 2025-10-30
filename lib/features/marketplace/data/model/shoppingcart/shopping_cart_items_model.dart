// lib/features/marketplace/data/models/shoppingcart/shopping_cart_items_model.dart

import 'dart:convert';
import 'package:gerena/features/marketplace/data/model/shoppingcart/shopping_cart_post_model.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_items_entity.dart';

class ShoppingCartItemsModel extends ShoppingCartItemsEntity {
  ShoppingCartItemsModel({required super.shopping});

  factory ShoppingCartItemsModel.fromEntity(ShoppingCartItemsEntity entity) {
    return ShoppingCartItemsModel(
      shopping: entity.shopping
          .map((item) => ShoppingCartPostModel.fromEntity(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': shopping
          .map((item) => (item as ShoppingCartPostModel).toJson())
          .toList(),
    };
  }



}