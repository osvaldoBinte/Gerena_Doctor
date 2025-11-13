import 'package:gerena/features/subscription/domain/entities/mysubcription/my_subcription_entity.dart';

class MySubcriptionModel extends MySubscriptionEntity {
  MySubcriptionModel({required super.id, required super.userid, required super.username, required super.subscriptionplanId, required super.planname, required super.planprice, required super.state, required super.startdate, required super.currentPeriodEnddate, required super.cancelledAtPeriodEnd,  super.cancellationdate});

  factory MySubcriptionModel.fromJson(Map<String, dynamic> json) {
    return MySubcriptionModel(
      id: json['id'],
      userid: json['usuarioId'],
      username: json['usuarioNombre'],
      subscriptionplanId: json['planSuscripcionId'],
      planname: json['planNombre'],
      planprice: (json['planPrecio'] as num).toDouble(),
      state: json['estado'],
      startdate: json['fechaInicio'],
      currentPeriodEnddate: json['fechaFinPeriodoActual'],
      cancelledAtPeriodEnd: json['canceladaAlFinalDelPeriodo'],
       cancellationdate: json['fechaCancelacion'],
    );
  }
  factory MySubcriptionModel.fromEntity(MySubscriptionEntity entity) {
    return MySubcriptionModel(
      id: entity.id,
      userid: entity.userid,
      username: entity.username,
      subscriptionplanId: entity.subscriptionplanId,
      planname: entity.planname,
      planprice: entity.planprice,
      state: entity.state,
      startdate:  entity.startdate,
      currentPeriodEnddate: entity.currentPeriodEnddate,
      cancelledAtPeriodEnd: entity.cancelledAtPeriodEnd,
       cancellationdate: entity.cancellationdate,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioId': userid,
      'usuarioNombre': username,
      'planSuscripcionId': subscriptionplanId,
      'planNombre': planname,
      'planPrecio': planprice,
      'estado': state,
      'fechaInicio': startdate,
      'fechaFinPeriodoActual': currentPeriodEnddate,
      'canceladaAlFinalDelPeriodo': cancelledAtPeriodEnd,
       'fechaCancelacion': cancellationdate,
    };
  }
}