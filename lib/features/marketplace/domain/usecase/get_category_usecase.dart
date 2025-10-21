import 'package:gerena/features/marketplace/domain/entities/categories/categories_entity.dart';
import 'package:gerena/features/marketplace/domain/repositories/marketplace_repository.dart';

class GetCategoryUsecase {
  final MarketplaceRepository marketplaceRepository;
  GetCategoryUsecase({required this.marketplaceRepository});
  Future<List<CategoriesEntity>>execute() async {
    return marketplaceRepository.categories();
  }
}