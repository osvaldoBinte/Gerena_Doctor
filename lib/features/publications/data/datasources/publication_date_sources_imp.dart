import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/common/errors/api_errors.dart';
import 'package:gerena/features/publications/data/model/create/create_publications_model.dart';
import 'package:gerena/features/publications/data/model/myposts/publication_model.dart';
import 'package:gerena/features/publications/domain/entities/create/create_publications_entity.dart';
import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PublicationDateSourcesImp {
    String defaultApiServer = AppConstants.serverBase;

Future<void> createPublication(CreatePublicationsEntity entity, String token) async {
  try {
    Uri url = Uri.parse('$defaultApiServer/Publicaciones');

    var request = http.MultipartRequest('POST', url);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    final model = CreatePublicationsModel.fromEntity(entity);

    model.addFieldsToRequest(request);

    await model.addFilesToRequest(request);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ApiExceptionCustom(response: response)..validateMesage();
    }

  } catch (e) {
    if (e is ApiExceptionCustom) {
      throw Exception(e.message);
    }
    
    if (e is SocketException ||
        e is http.ClientException ||
        e is TimeoutException) {
      throw Exception(convertMessageException(error: e));
    }

    throw Exception('$e');
  }
}

  Future<void> deletePublication(int publicationId,String token) async {
   try {
    Uri url = Uri.parse('$defaultApiServer/Publicaciones/$publicationId');
    
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
    if (e is SocketException || e is http.ClientException || e is TimeoutException) {
      throw Exception(convertMessageException(error: e));
    }
    throw Exception('$e');
  }
  }

  Future<List<PublicationEntity>> getFeedPosts(String token) async {
   try {
      Uri url = Uri.parse('$defaultApiServer/Publicaciones/feed?pagina=1&tamañoPagina=10&soloSeguidos=false&soloReseñas=false&doctorId');
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

   if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);

        final List data = responseDecode['publicaciones'];
        return data
            .map((json) => PublicationModel.fromJson(json))
            .toList();
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

  Future<List<PublicationEntity>> getMyPosts(String token) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Publicaciones/mis-publicaciones');
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

   if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);

        final List data = responseDecode;
        return data
            .map((json) => PublicationModel.fromJson(json))
            .toList();
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

  Future<void> likePublication(int publicationId,String tipoReaccion, String token) async {
    try {
    Uri url = Uri.parse('$defaultApiServer/Publicaciones/$publicationId/like');
    
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',

      },
      body: jsonEncode({'tipoReaccion': tipoReaccion}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    ApiExceptionCustom exception = ApiExceptionCustom(response: response);
    exception.validateMesage(); 
    throw exception;
    
  } catch (e) {
    if (e is SocketException || e is http.ClientException || e is TimeoutException) {
      throw Exception(convertMessageException(error: e));
    }
    throw Exception('$e');
  }
  }

  Future<void> updatePublication(String descripcion, int publicationId,String token) {
    // TODO: implement updatePublication
    throw UnimplementedError();
  }
  }