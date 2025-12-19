import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/common/errors/api_errors.dart';
import 'package:gerena/features/user/data/model/user/get_user_model.dart';
import 'package:gerena/features/user/data/model/user/search_profile_model.dart';
import 'package:gerena/features/user/data/model/user/search_profile_request_model.dart';
import 'package:gerena/features/user/domain/entities/getuser/get_user_entity.dart';
import 'package:gerena/features/user/domain/entities/getuser/search_profile_entity.dart';
import 'package:gerena/features/user/domain/entities/getuser/search_profile_request_entity.dart';
import 'package:http/http.dart' as http;

class UserDatasourceImp {
  String defaultApiServer = AppConstants.serverBase;
  Future<GetUserEntity> getUserDetails({required String token}) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Clientes/mi-perfil');
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);

        if (responseDecode is Map<String, dynamic>) {
          GetUserModel order = GetUserModel.fromJson(responseDecode);
          return order;
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

  Future<GetUserEntity> getUserDetailsbyid(int iduser, String token) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Clientes/$iduser');

      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);

        final responseDecode = jsonDecode(dataUTF8);

        if (responseDecode is Map<String, dynamic>) {
          GetUserModel order = GetUserModel.fromJson(responseDecode);

          return order;
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
  
  Future<List<SearchProfileEntity>> searchProfile(
  SearchProfileRequestEntity entity,
  String token,
) async {
  try {
    final url = Uri.parse('$defaultApiServer/Seguidores/buscar');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        SearchProfileRequestModel.fromEntity(entity).toJson(),
      ),
    );
    if (response.statusCode == 200) {
      final dataUTF8 = utf8.decode(response.bodyBytes);
      final responseDecode = jsonDecode(dataUTF8);
      final List data = responseDecode;
      return data.map((json) {
        return SearchProfileModel.fromJson(json);
      }).toList();
    }
    throw ApiExceptionCustom(response: response);
  } catch (e, stackTrace) {

    if (e is SocketException ||
        e is http.ClientException ||
        e is TimeoutException) {
      throw Exception(convertMessageException(error: e));
    }

    throw Exception(e.toString());
  }
}

}
