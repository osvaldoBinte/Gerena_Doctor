import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:gerena/features/blog/domain/entities/create/create_blog_social_entity.dart';

class CreateBlogSocialModel extends CreateBlogSocialEntity {
  CreateBlogSocialModel({
    required super.title,
    required super.description,
    required super.questionType,
    required super.image,
  });

  factory CreateBlogSocialModel.fromEntity(CreateBlogSocialEntity entity) {
    return CreateBlogSocialModel(
      title: entity.title,
      description: entity.description,
      questionType: entity.questionType,
      image: entity.image,
    );
  }

  // -------------------------------------------
  // 🔹 Agregar campos al request
  // -------------------------------------------
  void addFieldsToRequest(http.MultipartRequest request) {
    request.fields['Titulo'] = title;
    request.fields['Descripcion'] = description;
    request.fields['TipoPregunta'] = questionType;

    print("✅ Campos agregados correctamente");
  }

  // -------------------------------------------
  // 🔹 Agregar archivo (solo 1 imagen)
  // -------------------------------------------
  Future<void> addFilesToRequest(http.MultipartRequest request) async {
    if (image.isEmpty) {
      print("⚠️ No hay imagen para subir");
      return;
    }

    File file = File(image);

    if (!await file.exists()) {
      print("❌ Archivo no encontrado: $image");
      return;
    }

    String fileName = file.path.split('/').last;
    String extension = fileName.split('.').last.toLowerCase();

    final contentType = _getMediaType(extension);

    print('✅ Agregando imagen:');
    print('   - File: $fileName');
    print('   - Extensión: $extension');
    print('   - Content-Type: ${contentType?.mimeType ?? "no especificado"}');

    request.files.add(
      await http.MultipartFile.fromPath(
        'Imagen', // campo esperado por tu API
        image,
        filename: fileName,
        contentType: contentType,
      ),
    );

    print("✅ Imagen agregada correctamente");
  }

  // -------------------------------------------
  // 🔹 Detectar MediaType
  // -------------------------------------------
  MediaType? _getMediaType(String ext) {
    switch (ext) {
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
        return MediaType('image', 'jpeg'); // fallback
    }
  }
}
