import 'dart:io';
import 'package:gerena/features/publications/domain/entities/create/create_publications_entity.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class CreatePublicationsModel extends CreatePublicationsEntity {
  CreatePublicationsModel({
    required super.description,
    required super.isReview,
       super.taggedDoctorId,  
    required super.images, required super.ratings,
  });

  factory CreatePublicationsModel.fromEntity(CreatePublicationsEntity entity) {
    return CreatePublicationsModel(
      description: entity.description,
      isReview: entity.isReview,
      taggedDoctorId: entity.taggedDoctorId,
      images: entity.images,
      ratings: entity.ratings,
    );
  }

 Map<String, dynamic> toJson() {
    final json = {
      "Descripcion": description,
      "EsReseña": isReview,
      'Calificacion': ratings,
      "Imagenes": images,
    };

    if (taggedDoctorId != null) {
      json["DoctorEtiquetadoId"] = taggedDoctorId!;
    }

    return json;
  }

  void addFieldsToRequest(http.MultipartRequest request) {
    request.fields['Descripcion'] = description;
    request.fields['EsReseña'] = isReview;
    
    if (taggedDoctorId != null) {
      request.fields['DoctorEtiquetadoId'] = taggedDoctorId.toString();
      print("   - DoctorEtiquetadoId: $taggedDoctorId");
    } else {
      print("   - DoctorEtiquetadoId: NO ENVIADO (no es reseña)");
    }
    
    request.fields['Calificacion'] = ratings.toString();

    print("✅ Campos agregados al formulario:");
    print("   - Descripcion: $description");
    print("   - EsReseña: $isReview");
    print("   - Calificacion: $ratings");
  }

  Future<void> addFilesToRequest(http.MultipartRequest request) async {
    if (images.isEmpty) {
      print('⚠️ No hay imágenes para agregar');
      return;
    }

    for (int i = 0; i < images.length; i++) {
      final filePath = images[i];
      final file = File(filePath);

      if (await file.exists()) {
        final fileName = file.path.split('/').last;
        final extension = fileName.split('.').last.toLowerCase();
        final contentType = _getMediaType(extension);

        print('📸 Agregando imagen ${i + 1}/${images.length}');
        print('   - File: $fileName');
        print('   - Ext: $extension');
        print('   - Content-Type: ${contentType?.mimeType ?? "default"}');

        request.files.add(
          await http.MultipartFile.fromPath(
            'Imagenes',
            filePath,
            filename: fileName,
            contentType: contentType,
          ),
        );
      } else {
        print('❌ Imagen no encontrada: $filePath');
      }
    }

    print("✅ Total de imágenes agregadas: ${request.files.length}");
  }

  MediaType? _getMediaType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'bmp':
        return MediaType('image', 'bmp');
      case 'webp':
        return MediaType('image', 'webp');
      case 'heic':
        return MediaType('image', 'heic');
      default:
        return MediaType('image', 'jpeg');
    }
  }
}
