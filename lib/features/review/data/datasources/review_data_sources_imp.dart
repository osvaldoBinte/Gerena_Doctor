import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/features/review/data/model/my_review_model.dart';
import 'package:gerena/features/review/domain/entities/my_review_entity.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:gerena/common/errors/api_errors.dart';
class ReviewDataSourcesImp {
    String defaultApiServer = AppConstants.serverBase;


  Future<List<MyReviewEntity>> getMyReview( int id, String token) async {
    try {
      Uri uri = Uri.parse('$defaultApiServer/Reseñas/doctor/$id');
      final response = await http.get(uri, headers: <String, String >{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

       if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);

        final List data = responseDecode['reseñas'];
        return data
            .map((json) => MyReviewModel.fromJson(json))
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

}