import 'package:gerena/features/banners/domain/entity/banners_entity.dart';

class BannerModel extends BannersEntity {
  BannerModel({required super.id, super.imageUrl, super.nombre});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,
      imageUrl: json['url'] ?? '',
      nombre: json['nombre'] ?? '',
    );
  }
  factory BannerModel.fromEntity(BannersEntity entity) {
    return BannerModel(
      id: entity.id,
      imageUrl: entity.imageUrl,
      nombre: entity.nombre,
    );
  }
  json() {
    return {
      'id': id,
      'url': imageUrl,
      'nombre': nombre,
    };
  }
  
}