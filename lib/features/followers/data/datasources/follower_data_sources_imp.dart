 import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/common/errors/api_errors.dart';
import 'package:gerena/features/followers/data/model/follow_status_model.dart';
import 'package:gerena/features/followers/data/model/follow_user_model.dart';
import 'package:gerena/features/followers/domain/entities/follow_status_entity.dart';
import 'package:gerena/features/followers/domain/entities/follow_user_entity.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:gerena/common/constants/constants.dart';

class FollowerDataSourcesImp  {
  String defaultApiServer = AppConstants.serverBase;

  Future<void> followUser(int userId, String token) async {
    try {
    Uri url = Uri.parse('$defaultApiServer/Seguidores/seguir/$userId');
    
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
    if (e is SocketException || e is http.ClientException || e is TimeoutException) {
      throw Exception(convertMessageException(error: e));
    }
    throw Exception('$e');
  }
  }


  Future<FollowStatusEntity> getFollowStatus(int userId, String token) async {
   try {
    Uri url = Uri.parse('$defaultApiServer/Seguidores/estado-seguimiento/$userId');
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    
    if (response.statusCode == 200) {
      final dataUTF8 = utf8.decode(response.bodyBytes);
      final responseDecode = jsonDecode(dataUTF8);
      
       if (responseDecode is Map<String, dynamic>) {
        FollowStatusModel order = FollowStatusModel.fromJson(responseDecode);
        return order;
      } else {
        throw Exception('Respuesta vacía o formato incorrecto');
      }
    }
    
    throw ApiExceptionCustom(response: response);
  } catch (e) {
    if (e is SocketException || e is http.ClientException || e is TimeoutException) {
      throw Exception(convertMessageException(error: e));
    }
    throw Exception('$e');
  }
  }


  Future<List<FollowUserEntity>> getFollowingByUser(int userid,String token) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Seguidores/$userid/siguiendo');
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      
      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);
        
        final List doctores = responseDecode;
        return doctores.map((json) => FollowUserModel.fromJson(json)).toList();
      }
      
      throw ApiExceptionCustom(response: response);
    } catch (e) {
      if (e is SocketException || e is http.ClientException || e is TimeoutException) {
        throw Exception(convertMessageException(error: e));
      }
      throw Exception('$e');
    }
  }

  Future<List<FollowUserEntity>> getUserFollowers(int userid,String token) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Seguidores/$userid/seguidores');
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      
      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);
        
        final List doctores = responseDecode;
        return doctores.map((json) => FollowUserModel.fromJson(json)).toList();
      }
      
      throw ApiExceptionCustom(response: response);
    } catch (e) {
      if (e is SocketException || e is http.ClientException || e is TimeoutException) {
        throw Exception(convertMessageException(error: e));
      }
      throw Exception('$e');
    }
  }


  Future<void> unfollowUser(int userId, String token) async {
     try {
    Uri url = Uri.parse('$defaultApiServer/Seguidores/dejar-de-seguir/$userId');
    
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

}