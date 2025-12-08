import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; 
import 'package:gerena/features/doctorprocedures/domain/entities/createprocedures/create_procedures_entity.dart';

class ProceduresModel extends ProceduresEntity {
  ProceduresModel({
    super.titulo,
    super.description,
    super.fotos,
  });

  factory ProceduresModel.fromEntity(ProceduresEntity entity) {
    return ProceduresModel(
      titulo: entity.titulo,
      description: entity.description,
      fotos: entity.fotos,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (titulo != null) data["Titulo"] = titulo;
    if (description != null) data["Descripcion"] = description;
    
    return data;
  }

  void addFieldsToRequest(http.MultipartRequest request) {
    if (titulo != null && titulo!.isNotEmpty) {
      request.fields['Titulo'] = titulo!;
      print('✅ Campo agregado - Titulo: $titulo');
    }
    
    if (description != null && description!.isNotEmpty) {
      request.fields['Descripcion'] = description!;
      print('✅ Campo agregado - Descripcion: $description');
    }
  }

  Future<void> addFilesToRequest(http.MultipartRequest request) async {
    if (fotos == null || fotos!.isEmpty) {
      print('⚠️ No hay imágenes para agregar');
      return;
    }

    List<String> imagenesLista = fotos!;

    for (int i = 0; i < imagenesLista.length; i++) {
      String filePath = imagenesLista[i];
      File file = File(filePath);

      if (await file.exists()) {
        String fieldName = 'Imagenes';
        String fileName = file.path.split('/').last;
        String extension = fileName.split('.').last.toLowerCase();

        MediaType? contentType = _getMediaType(extension);

        print('✅ Agregando imagen ${i + 1}/${imagenesLista.length}:');
        print('   - Field: $fieldName');
        print('   - File: $fileName');
        print('   - Extension: $extension');
        print('   - Content-Type: ${contentType?.mimeType ?? "no especificado"}');

        request.files.add(
          await http.MultipartFile.fromPath(
            fieldName,
            filePath,
            filename: fileName,
            contentType: contentType,
          ),
        );
      } else {
        print('❌ Archivo no encontrado: $filePath');
      }
    }
    
    print('✅ Total de imágenes agregadas: ${request.files.length}');
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