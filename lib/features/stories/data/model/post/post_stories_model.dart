import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:gerena/features/stories/domain/entities/post/post_stories_entity.dart';

class PostStoriesModel extends PostStoriesEntity {
  PostStoriesModel({
    required super.contentType,
    required super.file,
  });

  /// Crear modelo desde entidad
  factory PostStoriesModel.fromEntity(PostStoriesEntity entity) {
    return PostStoriesModel(
      contentType: entity.contentType,
      file: entity.file,
    );
  }

  // -------------------------------------------------------
  // 🔹 Agregar campos al request
  // -------------------------------------------------------
  void addFieldsToRequest(http.MultipartRequest request) {
    request.fields['TipoContenido'] = contentType; 
    // ejemplo: "imagen" o "video"
    print("✅ Campos agregados correctamente");
  }

  // -------------------------------------------------------
  // 🔹 Agregar archivo (solo una imagen o un video)
  // -------------------------------------------------------
  Future<void> addFileToRequest(http.MultipartRequest request) async {
    if (file.isEmpty) {
      print("⚠️ No hay archivo para subir");
      return;
    }

    final File f = File(file);

    if (!await f.exists()) {
      print("❌ Archivo no encontrado: $file");
      return;
    }

    final String fileName = f.path.split('/').last;
    final String ext = fileName.split('.').last.toLowerCase();
    final MediaType? mimeType = _getMediaType(ext);

    print('📤 Agregando archivo:');
    print('   - Nombre: $fileName');
    print('   - Extensión: $ext');
    print('   - MimeType: ${mimeType?.mimeType ?? "desconocido"}');

    request.files.add(
      await http.MultipartFile.fromPath(
        'Archivo',   // nombre del campo esperado por tu API
        file,
        filename: fileName,
        contentType: mimeType,
      ),
    );

    print("✅ Archivo agregado correctamente");
  }

  // -------------------------------------------------------
  // 🔹 Detectar MIME según extensión (imagen / video)
  // -------------------------------------------------------
  MediaType? _getMediaType(String ext) {
    switch (ext) {
      // IMÁGENES
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'webp':
        return MediaType('image', 'webp');

      // VIDEOS
      case 'mp4':
        return MediaType('video', 'mp4');
      case 'mov':
        return MediaType('video', 'quicktime');
      case 'avi':
        return MediaType('video', 'x-msvideo');
      case 'mkv':
        return MediaType('video', 'x-matroska');

      default:
        return null;
    }
  }
}
