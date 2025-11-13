
import 'package:gerena/features/subscription/data/model/mysubcription/my_subcription_model.dart';
import 'package:gerena/features/subscription/data/model/view_all_plans_model.dart';
import 'package:gerena/features/subscription/domain/entities/mysubcription/my_subcription_entity.dart';
import 'package:gerena/features/subscription/domain/entities/view_all_plans_entity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/common/errors/api_errors.dart';
class SubscriptionDataSourcesImp {


  Future<MySubscriptionEntity> fetchMySubscription(String token) async {
    try {
      Uri url = Uri.parse('${AppConstants.serverBase}/Suscripciones/mi-suscripcion');
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);
        return MySubcriptionModel.fromJson(responseDecode);
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
      print('error: $e');
      throw Exception('$e');
    }
  }

  Future<void> subscribeToPlan(String paymentMethodId, int planId,String token) async {
    try {
      Uri url = Uri.parse('${AppConstants.serverBase}/Suscripciones');
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(<String, dynamic>{
            'paymentMethodId': paymentMethodId,
            'planSuscripcionId': planId,
          }));
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
      print('error: $e');
      throw Exception('$e');
      
    }
  }
  Future<void> cancelSubscription(bool cancelarInmediatamente, String motivo, String token) async {
    try {
      Uri url = Uri.parse('${AppConstants.serverBase}/Suscripciones/cancelar');
      final response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(<String, dynamic>{
            'cancelarInmediatamente': cancelarInmediatamente,
            'motivo': motivo,
          }));
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
      print('error: $e');
      throw Exception('$e');
      
    }
  } 
  Future<void> reactivateSubscription(String token ) async {
   try{
      Uri url = Uri.parse('${AppConstants.serverBase}/Suscripciones/reactivar');
      final response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          });
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
      print('error: $e');
      throw Exception('$e');
      
    }
  }
  Future<void> changeSubscriptionPlan(int newPlanId, bool immediatechange, String token) async {
    try{
      Uri url = Uri.parse('${AppConstants.serverBase}/Suscripciones/cambiar-plan');
      final response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(<String, dynamic>{
            'nuevoPlanSuscripcionId': newPlanId,
            'cambioInmediato': immediatechange,
          }));
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
      print('error: $e');
      throw Exception('$e');
      
    }
  }
  Future<List< ViewAllPlansEntity>> fetchAllPlans(String token) async {
    try {
      Uri url = Uri.parse('${AppConstants.serverBase}/Suscripciones/planes');
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
       if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);
        
        final List plans =  responseDecode['planes'];

        return plans.map((json) => ViewAllPlansModel.fromJson(json)).toList();
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
      print('error: $e');
      throw Exception('$e');
    }
  }
}