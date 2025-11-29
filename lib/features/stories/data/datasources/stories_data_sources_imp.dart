import 'package:gerena/features/stories/data/model/get/get_stories_model.dart';
import 'package:gerena/features/stories/data/model/get/story_model.dart';
import 'package:gerena/features/stories/data/model/post/post_stories_model.dart';
import 'package:gerena/features/stories/domain/entities/getstories/get_stories_entity.dart';
import 'package:gerena/features/stories/domain/entities/getstories/story_entity.dart';
import 'package:gerena/features/stories/domain/entities/post/post_stories_entity.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/common/errors/api_errors.dart';

class StoriesDataSourcesImp {
  String defaultApiServer = AppConstants.serverBase;

  Future<void> addLikeToStory(int id, String token) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Historias/$id/like');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }

      ApiExceptionCustom exception = ApiExceptionCustom(response: response);
      exception.validateMesage();
      throw exception;
    } catch (e) {
      if (e is SocketException ||
          e is http.ClientException ||
          e is TimeoutException) {
        throw Exception(convertMessageException(error: e));
      }
      throw Exception('$e');
    }
  }Future<void> createStrory(PostStoriesEntity entity, String token) async {
  try {
    Uri url = Uri.parse('$defaultApiServer/Historias');

    print('📌 URL: $url');

    var request = http.MultipartRequest('POST', url);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    print('📌 Headers: ${request.headers}');

    final model = PostStoriesModel.fromEntity(entity);

    // 👉 Antes de agregar los fields
    print('📌 Fields antes de agregar: ${request.fields}');

    model.addFieldsToRequest(request);

    // 👉 Después de agregar los fields
    print('📌 Fields finales: ${request.fields}');

    // 👉 Archivos antes
    print('📌 Files antes: ${request.files}');

    await model.addFileToRequest(request);

    // 👉 Archivos después
    print('📌 Files finales: ${request.files.map((f) => f.filename).toList()}');

    // Puedes imprimir tamaño o bytes si quieres
    // print(await request.files.first.finalize().bytesToString());

    print('🚀 Enviando request...');

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print('📥 STATUS: ${response.statusCode}');
    print('📥 RESPONSE: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error HTTP ${response.statusCode}: ${response.body}');
    }
  } catch (e) {
    print('❌ Error en createStory: $e');

    if (e is SocketException ||
        e is http.ClientException ||
        e is TimeoutException) {
      throw Exception(convertMessageException(error: e));
    }

    throw Exception('Error procesando procedimiento: $e');
  }
}


  Future<List<GetStoriesEntity>> fetchStories(String token) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Historias/doctores/activos');
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);

        final List data = responseDecode;
        return data.map((json) => GetStoriesModel.fromJson(json)).toList();
      }

      throw ApiExceptionCustom(response: response);
    } catch (e) {
      if (e is SocketException ||
          e is http.ClientException ||
          e is TimeoutException) {
        throw Exception(convertMessageException(error: e));
      }
      throw Exception('$e');
    }
  }

  Future<StoryEntity> fetchStoriesbyid(int id, String token) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Historias/doctor/$id');
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);
        final Map<String, dynamic> storyMap =
            responseDecode is List ? responseDecode.first : responseDecode;
        StoryModel data = StoryModel.fromJson(storyMap);
        return data;
      }

      throw ApiExceptionCustom(response: response);
    } catch (e) {
      if (e is SocketException ||
          e is http.ClientException ||
          e is TimeoutException) {
        throw Exception(convertMessageException(error: e));
      }
      throw Exception('$e');
    }
  }

  Future<void> removeStory(int id, String token) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Historias/$id');

      final response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }

      ApiExceptionCustom exception = ApiExceptionCustom(response: response);
      exception.validateMesage();
      throw exception;
    } catch (e) {
      if (e is SocketException ||
          e is http.ClientException ||
          e is TimeoutException) {
        throw Exception(convertMessageException(error: e));
      }
      throw Exception('$e');
    }
  }

  Future<void> setStoryAsSeen(int historiaId, String token) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Historias/$historiaId/vista');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }

      ApiExceptionCustom exception = ApiExceptionCustom(response: response);
      exception.validateMesage();
      throw exception;
    } catch (e) {
      if (e is SocketException ||
          e is http.ClientException ||
          e is TimeoutException) {
        throw Exception(convertMessageException(error: e));
      }
      throw Exception('$e');
    }
  }
}
