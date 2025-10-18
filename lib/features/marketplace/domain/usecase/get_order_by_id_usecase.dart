
import 'package:gerena/features/marketplace/domain/entities/orders/orders_entity.dart';
import 'package:gerena/features/marketplace/domain/repositories/marketplace_repository.dart';

class GetOrderByIdUsecase {
  final MarketplaceRepository marketplaceRepository;
  GetOrderByIdUsecase({required this.marketplaceRepository});
  Future<OrderEntity>execute(int id) async {
    return await marketplaceRepository.orderbyID(id);
  }
}