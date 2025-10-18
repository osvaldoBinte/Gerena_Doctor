import 'package:gerena/features/marketplace/domain/entities/medications/medications_entity.dart';
import 'package:gerena/features/marketplace/domain/repositories/marketplace_repository.dart';

class SearchingForMedicationsUsecase {
  final MarketplaceRepository marketplaceRepository;
  SearchingForMedicationsUsecase({required this.marketplaceRepository});
  Future<List<MedicationsEntity>> execute(String category,String busqueda)async{
    return await marketplaceRepository.searchingformedications(category, busqueda);
  }
}