import 'package:gerena/features/marketplace/domain/entities/orders/orders_entity.dart';
import 'package:gerena/features/marketplace/domain/repositories/marketplace_repository.dart';

class GetMyOrderUsecase {
  final MarketplaceRepository marketplaceRepository;
  GetMyOrderUsecase({required this.marketplaceRepository});
  Future<OrderEntity> execute()async {
    return await marketplaceRepository.myorders();
  }
}