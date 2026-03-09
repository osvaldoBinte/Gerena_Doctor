import 'package:gerena/features/subscription/domain/entities/mysubcription/my_subcription_entity.dart';

class MySubcriptionModel extends MySubscriptionEntity {
  MySubcriptionModel({
    super.id,
    super.userid,
    super.username,
    super.subscriptionplanId,
    super.planname,
    super.planprice,
    super.state,
    super.startdate,
    super.currentPeriodEnddate,
    super.cancelledAtPeriodEnd,
    super.cancellationdate,
  });

  factory MySubcriptionModel.fromJson(Map<String, dynamic> json) {
    return MySubcriptionModel(
      id: json['id'] as int?,
      userid: json['usuarioId'] as int?,
      username: json['usuarioNombre'] as String?,
      subscriptionplanId: json['planSuscripcionId'] as int?,
      planname: json['planNombre'] as String?,

      planprice: (json['planPrecio'] as num?)?.toDouble(),

      state: json['estado'] as String?,
      startdate: json['fechaInicio'] as String?,
      currentPeriodEnddate: json['fechaFinPeriodoActual'] as String?,
      cancelledAtPeriodEnd: json['canceladaAlFinalDelPeriodo'] as bool?,
      cancellationdate: json['fechaCancelacion'] as String?,
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
      startdate: entity.startdate,
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
