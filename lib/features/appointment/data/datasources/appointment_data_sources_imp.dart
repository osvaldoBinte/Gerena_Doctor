import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/common/errors/api_errors.dart';
import 'package:gerena/features/appointment/data/model/addappointment/add_appointment_model.dart';
import 'package:gerena/features/appointment/data/model/getappointment/get_appointment_model.dart';
import 'package:gerena/features/appointment/domain/entities/addappointment/add_appointment_entity.dart';
import 'package:gerena/features/appointment/domain/entities/getappointment/get_apppointment_entity.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class AppointmentDataSourcesImp {
  String defaultApiServer = AppConstants.serverBase;

  Future<void> postAppointments(
    AddAppointmentEntity addAppointment,
    String token,
  ) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Citas');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token
        },
        body:
            jsonEncode(AddAppointmentModel.fromEntity(addAppointment).toJson()),
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

  Future<List<GetApppointmentEntity>> getAppointments(
      String token, String date,String day) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/doctor/citas?dias=$day&fecha=$date');

      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);

        final List doctores = responseDecode['citas'];
        return doctores
            .map((json) => GetAppointmentModel.fromJson(json))
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
      print('error: $e');
      throw Exception('$e');
    }
  }
}
