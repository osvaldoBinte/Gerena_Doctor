
import 'package:gerena/features/marketplace/domain/entities/orders/create/create_new_order_entity.dart';

class CreateNewOrderModel extends CreateNewOrderEntity {
  CreateNewOrderModel({required super.items, required super.direccionEnvio, required super.ciudad, required super.codigoPostal});

  
   CreateNewOrderModel.fromEntity(CreateNewOrderEntity entity) 
    : super (
       items: entity.items.map((item) => ItemEntity(
         medicamentoId: item.medicamentoId,
         quantity: item.quantity,
       )).toList(),
      direccionEnvio: entity.direccionEnvio,
      ciudad: entity.ciudad,
      codigoPostal: entity.codigoPostal,
    );
  
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => {
            'medicamentoId': item.medicamentoId,
            'cantidad': item.quantity,
          }).toList(),
      'direccionEnvio': direccionEnvio,
      'ciudad': ciudad,
      'codigoPostal': codigoPostal,
    };  
  }
}