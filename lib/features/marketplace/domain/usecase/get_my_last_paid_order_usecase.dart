import 'package:gerena/features/marketplace/domain/entities/orders/orders_entity.dart';
import 'package:gerena/features/marketplace/domain/repositories/marketplace_repository.dart';

class GetMyLastPaidOrderUsecase {
  final MarketplaceRepository marketplaceRepository;
  GetMyLastPaidOrderUsecase({required this.marketplaceRepository});
  Future<OrderEntity> execute () async {
    return await marketplaceRepository.getMylastpaidorder();
  }
}