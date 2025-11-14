import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/features/doctorprocedures/data/model/createprocedures/procedures_model.dart';
import 'package:gerena/features/doctorprocedures/data/model/getprocedures/get_procedures_model.dart';
import 'package:gerena/features/doctorprocedures/domain/entities/createprocedures/create_procedures_entity.dart';
import 'package:gerena/features/doctorprocedures/domain/entities/getprocedures/get_procedures_entity.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:gerena/common/errors/api_errors.dart';

class ProceduresDataSourcesImp {
  String defaultApiServer = AppConstants.serverBase;
Future<void> createprocedure(ProceduresEntity entity, String token) async {
  try {
    Uri url = Uri.parse('$defaultApiServer/Procedimientos');

    var request = http.MultipartRequest('POST', url);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    final model = ProceduresModel.fromEntity(entity);

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
  Future<List< GetProceduresEntity>> getProcedures(String token) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Procedimientos/mis-procedimientos');
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

   if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);

        final List doctores = responseDecode;
        return doctores
            .map((json) => GetProceduresModel.fromJson(json))
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
    Future<void> updateprocedure(ProceduresEntity entity ,int id,String token) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Procedimientos/$id');

      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':'Bearer $token'
        },
        body:
            jsonEncode(ProceduresModel.fromEntity(entity).toJson()),
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
Future<void> addimagenes(ProceduresEntity entity, int procedimientoId, String token) async {
  try {
    Uri url = Uri.parse('$defaultApiServer/Procedimientos/$procedimientoId/imagenes');

    var request = http.MultipartRequest('POST', url);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    final model = ProceduresModel.fromEntity(entity);

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

    throw Exception('Error agregando imágenes: $e');
  }
}
   Future<void> deleteimg(int id, String token) async {
  try {
    Uri url = Uri.parse('$defaultApiServer/Procedimientos/$id/imagenes');

   
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
    
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
    throw Exception('Error eliminando imagen: $e');
  }
}

Future<void> deleteprocedure(int id, String token) async {
  try {
    Uri url = Uri.parse('$defaultApiServer/Procedimientos/$id');


    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );


    if (response.statusCode == 200 || response.statusCode == 204) {
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
    throw Exception('Error eliminando procedimiento: $e');
  }
}
}
