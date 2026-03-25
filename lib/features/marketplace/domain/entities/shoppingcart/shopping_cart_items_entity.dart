import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_post_entity.dart';

class ShoppingCartItemsEntity {
  List<ShoppingCartPostEntity> shopping;
  final bool? invoicerequired;
  ShoppingCartItemsEntity({
    required this.shopping,
     this.invoicerequired
  });
}