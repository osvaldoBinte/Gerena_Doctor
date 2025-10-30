import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_post_entity.dart';

class ShoppingCartItemsEntity {
  List<ShoppingCartPostEntity> shopping;
  ShoppingCartItemsEntity({
    required this.shopping
  });
}