import 'package:gerena/features/marketplace/domain/entities/medications/medications_entity.dart';
import 'package:gerena/features/marketplace/domain/repositories/marketplace_repository.dart';

class GetMedicinesOnSaleUsecase {
  final MarketplaceRepository marketplaceRepository;
  GetMedicinesOnSaleUsecase({required this.marketplaceRepository});
  Future<List<MedicationsEntity>> execute() async {
    return await marketplaceRepository.medicinesonsale();
  }
}