
import 'dart:math';

import 'package:gerena/features/marketplace/domain/entities/orders/create/create_new_order_entity.dart';

class CreateNewOrderModel extends CreateNewOrderEntity {
  CreateNewOrderModel({required super.items,required super.usepoints, super.pointstouse });

  
   CreateNewOrderModel.fromEntity(CreateNewOrderEntity entity) 
    : super (
       items: entity.items.map((item) => ItemEntity(
         medicamentoId: item.medicamentoId,
         quantity: item.quantity,
       )).toList(),

       usepoints: entity.usepoints,
       pointstouse: entity.pointstouse
    
    );
  
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => {
            'medicamentoId': item.medicamentoId,
            'cantidad': item.quantity,
          }).toList(),
      'usarPuntos': usepoints,
      'puntosAUsar': pointstouse
     
    };  
  }
}