import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/common/errors/api_errors.dart';
import 'package:gerena/features/banners/data/model/banner_model.dart';
import 'package:gerena/features/banners/domain/entity/banners_entity.dart';


class BannersDataSourcesImp {
     String defaultApiServer = AppConstants.serverBase;
     


  Future<List<BannersEntity>> getBannersList(String token ) async {
   try {
      Uri url = Uri.parse('$defaultApiServer/Banners');
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      
      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);
        
        final List doctores = responseDecode['banners'];
        return doctores.map((json) => BannerModel.fromJson(json)).toList();
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