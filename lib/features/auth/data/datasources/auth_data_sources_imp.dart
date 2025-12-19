import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/common/errors/api_errors.dart';
import 'package:gerena/features/auth/data/model/loginResponse/login_response_model.dart';
import 'package:gerena/features/auth/domain/entities/response/login_response_entity.dart';

class AuthDataSourcesImp {
    String defaultApiServer = AppConstants.serverBase;

  Future<LoginResponseEntity> login(String email, String password) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/auth/login');
      final bodyData = jsonEncode({
        'email': email, 
        'contrasena': password, 
      });
      
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: bodyData
      );
      
     if (response.statusCode == 200) {
      final dataUTF8 = utf8.decode(response.bodyBytes);
      final responseDecode = jsonDecode(dataUTF8);
      
      return LoginResponseModel.fromJson(responseDecode);
       
      }
      
      throw ApiExceptionCustom(response: response);
    } catch (e) {
       if (e is SocketException || e is http.ClientException || e is TimeoutException) {

        throw Exception(convertMessageException(error: e));
      }
      throw Exception('$e');
  
    }
  }

  Future<void> confirmPasswordReset(String email, String code, String newpassword) async {
     try {
      Uri url = Uri.parse('$defaultApiServer/Auth/recuperar-contrasena');
      final bodyData = jsonEncode({
        'email': email, 
        'codigo': code, 
        'nuevaContrasena': newpassword
      });
      
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: bodyData
      );
      
     if (response.statusCode == 200) {
      final dataUTF8 = utf8.decode(response.bodyBytes);
      final responseDecode = jsonDecode(dataUTF8);
      debugPrint(responseDecode);
      
      
      }
      
      throw ApiExceptionCustom(response: response);
    } catch (e) {
       if (e is SocketException || e is http.ClientException || e is TimeoutException) {

        throw Exception(convertMessageException(error: e));
      }
      throw Exception('$e');
  
    }
  }
  
  Future<void> requestPasswordCode(String email) async {
     try {
      Uri url = Uri.parse('$defaultApiServer/Auth/solicitar-codigo');
     
  final bodyData = jsonEncode(email);
      
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: bodyData
      );
      
     if (response.statusCode == 200) {
      final dataUTF8 = utf8.decode(response.bodyBytes);
      final responseDecode = jsonDecode(dataUTF8);
      
       
      }
      
      throw ApiExceptionCustom(response: response);
    } catch (e) {
       if (e is SocketException || e is http.ClientException || e is TimeoutException) {

        throw Exception(convertMessageException(error: e));
      }
      throw Exception('$e');
  
    }
  }
}