import 'package:gerena/features/marketplace/domain/entities/orders/create/ressponse_new_order_entity.dart';

class ResponseNewOrderModel extends RessponseNewOrderEntity {
  ResponseNewOrderModel({required super.orderId});

  factory ResponseNewOrderModel.fromJson(Map<String, dynamic> json) {
    return ResponseNewOrderModel(
      orderId: json['id'],
    );
  }
}