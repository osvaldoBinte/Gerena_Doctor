import 'package:gerena/features/banners/domain/entity/banners_entity.dart';

abstract class BannersRepository {
  Future<List<BannersEntity>> getBannersList();
}