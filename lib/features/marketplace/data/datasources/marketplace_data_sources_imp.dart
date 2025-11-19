import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/common/errors/api_errors.dart';
import 'package:gerena/features/marketplace/data/model/category/category_model.dart';
import 'package:gerena/features/marketplace/data/model/ordes/create/create_new_order_model.dart';
import 'package:gerena/features/marketplace/data/model/ordes/create/response_new_order_model.dart';
import 'package:gerena/features/marketplace/data/model/ordes/order_entity.dart';
import 'package:gerena/features/marketplace/data/model/searchingformedications/searching_for_medications_model.dart';
import 'package:gerena/features/marketplace/data/model/shoppingcart/shopping_cart_items_model.dart';
import 'package:gerena/features/marketplace/data/model/shoppingcart/shopping_cart_post_model.dart';
import 'package:gerena/features/marketplace/data/model/shoppingcart/shopping_cart_response_model.dart';
import 'package:gerena/features/marketplace/domain/entities/categories/categories_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/medications/medications_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/orders/create/create_new_order_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/orders/create/ressponse_new_order_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/orders/orders_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_items_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_post_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_response_entity.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class MarketplaceDataSourcesImp {
  String defaultApiServer = AppConstants.serverBase;
Future<List<MedicationsEntity>> searchingformedications(
    String categoria, String busqueda, String token) async {
  try {
    Uri url = Uri.parse(
        '$defaultApiServer/Marketplace/medicamentos?categoria=$categoria&busqueda=$busqueda');
    
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });


    if (response.statusCode == 200) {
      final dataUTF8 = utf8.decode(response.bodyBytes);
      final responseDecode = jsonDecode(dataUTF8);

      final List medications = responseDecode['medicamentos'];
      
      return medications
          .map((json) => SearchingForMedicationsModel.fromJson(json))
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
  Future<List<MedicationsEntity>> medicinesonsale( String token) async {
    try {
      Uri url = Uri.parse(
          '$defaultApiServer/Marketplace/ofertas');

      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);

        final List medications = responseDecode['medicamentos'];
        return medications
            .map((json) => SearchingForMedicationsModel.fromJson(json))
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
  Future<MedicationsEntity> getmedicationsby(int id, String token) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Marketplace/medicamentos/$id');

      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);
        if (responseDecode is Map<String, dynamic>) {
          SearchingForMedicationsModel medication =
              SearchingForMedicationsModel.fromJson(responseDecode);
          return medication;
        } else {
          throw Exception('Respuesta vacía o formato incorrecto');
        }
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

  Future<List<CategoriesEntity>> getcategories(String token) async {
    try {
      Uri url = Uri.parse(
          '$defaultApiServer/Marketplace/categorias');

      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);

        final List category =responseDecode;
        return category
            .map((json) => CategoryModel.fromJson(json))
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


  Future<OrderEntity> myorders( String token) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Marketplace/mis-pedidos?estado=');

      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);

        final  category = responseDecode['pedidos'];
        if (category is Map<String, dynamic>) {
          OrderModel order =
              OrderModel.fromJson(responseDecode);
          return order;
        } else {
          throw Exception('Respuesta vacía o formato incorrecto');
        }
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

  Future<OrderEntity> getordersbyid( String token,int id) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Marketplace/pedidos/$id');

      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);

        final  category = responseDecode['pedidos'];
        if (category is Map<String, dynamic>) {
          OrderModel order =
              OrderModel.fromJson(responseDecode);
          return order;
        } else {
          throw Exception('Respuesta vacía o formato incorrecto');
        }
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

  Future<RessponseNewOrderEntity> createaneworder(CreateNewOrderEntity createaneworder, int idAddresse,String token) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Marketplace/pedidos?direccionid=$idAddresse');

      final response = await http.post( url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
        },
        body:
            jsonEncode(CreateNewOrderModel.fromEntity(createaneworder).toJson()),
      );

      if (response.statusCode == 201) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);

        if (responseDecode is Map<String, dynamic>) {
          ResponseNewOrderModel order =
              ResponseNewOrderModel.fromJson(responseDecode);
          return order;
        } else {
          throw Exception('Respuesta vacía o formato incorrecto');
        }
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

  Future<void> payorder(int id, String token,String paymentMethodId) async {
    try {
      Uri url = Uri.parse('$defaultApiServer/Marketplace/pedidos/$id/pagar');

      final response = await http.post( url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
        },
          body: jsonEncode({
        'paymentMethodId': paymentMethodId,
      }),
       
      );

      if (response.statusCode == 200) {
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


  Future<ShoppingCartResponseEntity> validatecart(ShoppingCartItemsEntity shoppingcartpostentity, String token) async{
     try {
      Uri url = Uri.parse('$defaultApiServer/Marketplace/carrito/validar');

        final response = await http.post( url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
        },
        body:
            jsonEncode(ShoppingCartItemsModel.fromEntity(shoppingcartpostentity).toJson()),
      );
      if (response.statusCode == 200) {
        final dataUTF8 = utf8.decode(response.bodyBytes);
        final responseDecode = jsonDecode(dataUTF8);

        final  shopping = responseDecode;
        if (shopping is Map<String, dynamic>) {
          ShoppingCartResponseModel shopping =
              ShoppingCartResponseModel.fromJson(responseDecode);
          return shopping;
        } else {
          throw Exception('Respuesta vacía o formato incorrecto');
        }
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
