import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:gerena/features/blog/data/model/blog/blog_gerena_model.dart';
import 'package:gerena/features/blog/data/model/blog/blog_social_model.dart';
import 'package:gerena/features/blog/data/model/blog/create_blog_social_model.dart';
import 'package:gerena/features/blog/domain/entities/blog_gerena_entity.dart';
import 'package:gerena/features/blog/domain/entities/blog_social_entity.dart';
import 'package:gerena/features/blog/domain/entities/create/create_blog_social_entity.dart';
import 'package:http/http.dart' as http;
import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/common/errors/api_errors.dart';

class BlogDataSourcesImp {
  String defaultApiServer = AppConstants.serverBase;

  Future<List<BlogGerenaEntity>> blogGerena(String token) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Blog/previews');
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);

        final List data = responseDecode;
        return data.map((json) => BlogGerenaModel.fromJson(json)).toList();
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

  Future<BlogGerenaEntity> blogGerenabyid(String token, int id) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Blog/$id');
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);

        if (responseDecode is Map<String, dynamic>) {
          BlogGerenaModel data = BlogGerenaModel.fromJson(responseDecode);
          return data;
        } else {
          throw Exception('Respuesta vacía o formato incorrecto');
        }
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

  Future<List<BlogSocialEntity>> blogSocial(String token) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/BlogSocial/preguntasPreview');
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);

        final List data = responseDecode;
        return data.map((json) => BlogSocialModel.fromJson(json)).toList();
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

  Future<BlogSocialEntity> blogSocialbyid(String token, int id) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/BlogSocial/pregunta/$id');
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);

        if (responseDecode is Map<String, dynamic>) {
          BlogSocialModel data = BlogSocialModel.fromJson(responseDecode);
          return data;
        } else {
          throw Exception('Respuesta vacía o formato incorrecto');
        }
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

  Future<void> createBlogSocial(
      CreateBlogSocialEntity entity, String token) async {
    try {
    Uri url = Uri.parse('$defaultApiServer/BlogSocial/pregunta');

    var request = http.MultipartRequest('POST', url);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    final model = CreateBlogSocialModel.fromEntity(entity);

    model.addFieldsToRequest(request);

    await model.addFilesToRequest(request);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error HTTP ${response.statusCode}: ${response.body}');
    }

  } catch (e) {
    
    if (e is SocketException ||
        e is http.ClientException ||
        e is TimeoutException) {
      throw Exception(convertMessageException(error: e));
    }

    throw Exception('Error procesando procedimiento: $e');
  }
  }

  Future<void> answerBlog(int idblog, String answer, String token) async {
    try {
      Uri url =
          Uri.parse('$defaultApiServer/BlogSocial/pregunta/$idblog/respuesta');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "contenido": answer,
        }),
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
