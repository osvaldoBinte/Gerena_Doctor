import 'package:gerena/features/marketplace/domain/entities/descuentopuntos/descuento_puntos_entity.dart';
import 'package:gerena/features/marketplace/domain/repositories/marketplace_repository.dart';

class CalculateDiscountPointsUsecase {
  final MarketplaceRepository marketplaceRepository;
  CalculateDiscountPointsUsecase({required this.marketplaceRepository});
  Future<DescuentoPuntosEntity> execute(int  monto,int puntosAUsar) async {
    return await marketplaceRepository.calculatediscountpoints(monto, puntosAUsar);
  }
}