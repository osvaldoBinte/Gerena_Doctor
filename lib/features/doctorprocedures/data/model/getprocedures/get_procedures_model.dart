import 'package:gerena/features/doctorprocedures/domain/entities/getprocedures/get_procedures_entity.dart';

class GetProceduresModel extends GetProceduresEntity {
  GetProceduresModel({
    required super.id,
    required super.titulo,
    required super.creationdate,
    required super.description,
    required super.img,
  });

  factory GetProceduresModel.fromJson(Map<String, dynamic> json) {
    return GetProceduresModel(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      creationdate: json['creationdate'] ?? '',
      description: json['descripcion'] ?? '',
      img: json['imagenes'] != null
          ? (json['imagenes'] as List)
              .map((imgJson) => ImagenesModel.fromJson(imgJson))
              .toList()
          : [],
    );
  }

  factory GetProceduresModel.fromEntity(GetProceduresEntity entity) {
    return GetProceduresModel(
      id: entity.id,
      titulo: entity.titulo,
      creationdate: entity.creationdate,
      description: entity.description,
      img: entity.img,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'creationdate': creationdate,
        'description': description,
        'imagenes': img.map((imagen) => ImagenesModel.fromEntity(imagen).toJson()).toList(),
      };
}

class ImagenesModel extends ImagenesEntity {
  ImagenesModel({
    required super.id,
    required super.urlImagen,
  });

  factory ImagenesModel.fromJson(Map<String, dynamic> json) {
    return ImagenesModel(
      id: json['id'] ?? 0,
      urlImagen: json['urlImagen'] ?? '',
    );
  }

  factory ImagenesModel.fromEntity(ImagenesEntity entity) {
    return ImagenesModel(
      id: entity.id,
      urlImagen: entity.urlImagen,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'urlImagen': urlImagen,
      };
}