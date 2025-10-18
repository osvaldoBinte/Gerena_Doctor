import 'package:gerena/features/marketplace/domain/entities/medications/medications_entity.dart';
import 'package:gerena/features/marketplace/domain/repositories/marketplace_repository.dart';

class GetMedicineByIdUsecase {
  final MarketplaceRepository marketplaceRepository;
  GetMedicineByIdUsecase({required this.marketplaceRepository});
  Future <MedicationsEntity> execute(int id) async {
    return await marketplaceRepository.getmedicineByID(id);
  }

}