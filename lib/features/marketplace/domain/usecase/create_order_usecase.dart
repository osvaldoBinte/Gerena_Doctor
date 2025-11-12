import 'package:gerena/features/marketplace/domain/entities/orders/create/create_new_order_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/orders/create/ressponse_new_order_entity.dart';
import 'package:gerena/features/marketplace/domain/repositories/marketplace_repository.dart';

class CreateOrderUsecase {
  final MarketplaceRepository marketplaceRepository;
  CreateOrderUsecase({required this.marketplaceRepository});
   Future<RessponseNewOrderEntity> createaneworder(CreateNewOrderEntity createaneworder) async {
     return await marketplaceRepository.createaneworder(createaneworder);
   }
}