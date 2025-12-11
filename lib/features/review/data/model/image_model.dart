import 'package:gerena/features/publications/domain/entities/myposts/image_entity.dart';

class ImageModel extends ImageEntity {
  ImageModel({
    required super.id,
    required super.imageUrl,
    required super.order,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json["id"],
      imageUrl: json["urlImagen"],
      order: json["orden"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "urlImagen": imageUrl,
      "orden": order,
    };
  }

  factory ImageModel.fromEntity(ImageEntity entity) {
    return ImageModel(
      id: entity.id,
      imageUrl: entity.imageUrl,
      order: entity.order,
    );
  }
}
