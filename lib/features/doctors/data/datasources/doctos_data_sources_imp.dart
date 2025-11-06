import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/common/errors/api_errors.dart';
import 'package:gerena/features/doctors/data/model/doctor_model.dart';
import 'package:gerena/features/doctors/data/model/doctoravailability/doctor_availability_model.dart';
import 'package:gerena/features/doctors/domain/entities/doctor/doctor_entity.dart';
import 'package:gerena/features/doctors/domain/entities/doctoravailability/doctor_availability_entity.dart';
import 'package:http/http.dart' as http;

class DoctosDataSourcesImp {

    String defaultApiServer = AppConstants.serverBase;
 Future<DoctorEntity> getDoctorProfile({required String token}) async {
  try {
    Uri url = Uri.parse('$defaultApiServer/Doctores/mi-perfil');
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    
    if (response.statusCode == 200) {
      final dataUTF8 = utf8.decode(response.bodyBytes);
      final responseDecode = jsonDecode(dataUTF8);
      
       if (responseDecode is Map<String, dynamic>) {
        DoctorModel order = DoctorModel.fromJson(responseDecode);
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

 Future<List<DoctorAvailabilityEntity>> getDoctorAvailability({
    required String token,
  }) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/doctor/citas/disponibilidad');
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      
      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);
        
        final List doctores = responseDecode['disponibilidad'];
        return doctores.map((json) => DoctorAvailabilityModel.fromJson(json)).toList();
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