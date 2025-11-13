import 'package:gerena/features/subscription/domain/entities/mysubcription/my_subcription_entity.dart';
import 'package:gerena/features/subscription/domain/entities/view_all_plans_entity.dart';

abstract class SubscriptionRepository {
  Future<List< ViewAllPlansEntity >> fetchAllPlans();
  Future<MySubscriptionEntity> fetchMySubscription();
  Future<void> subscribeToPlan(String paymentMethodId,int planId, );
  Future<void> cancelSubscription(bool cancelarInmediatamente,String motivo);
  Future<void> reactivateSubscription();
  Future<void> changeSubscriptionPlan(int newPlanId,bool immediatechange );

  
  
}