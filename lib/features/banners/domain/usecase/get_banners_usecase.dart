import 'package:gerena/features/banners/domain/entity/banners_entity.dart';
import 'package:gerena/features/banners/domain/repositories/banners_repository.dart';

class GetBannersUsecase {
  final BannersRepository repository;
  GetBannersUsecase({required this.repository});
  Future<List<BannersEntity>> execute() async {
    return await repository.getBannersList();
  }
}