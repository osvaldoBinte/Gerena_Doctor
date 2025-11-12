import 'package:gerena/features/marketplace/domain/repositories/marketplace_repository.dart';

class PayOrderUsecase {
  MarketplaceRepository marketplaceRepository;
  PayOrderUsecase({required this.marketplaceRepository});
  Future<void> execute(int orderId) async {
    return await marketplaceRepository.payorder(orderId);
  }
}