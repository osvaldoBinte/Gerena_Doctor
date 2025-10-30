import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_items_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_post_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_response_entity.dart';
import 'package:gerena/features/marketplace/domain/repositories/marketplace_repository.dart';

class ShoppingCartUsecase {
  final MarketplaceRepository marketplaceRepository;
  ShoppingCartUsecase({required this.marketplaceRepository});

  Future<ShoppingCartResponseEntity> execute(ShoppingCartItemsEntity entity) async {
    return marketplaceRepository.validatecart(entity);

  }
}
