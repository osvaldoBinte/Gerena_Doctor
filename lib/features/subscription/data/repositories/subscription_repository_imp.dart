import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/features/subscription/data/datasources/subscription_data_sources_imp.dart';
import 'package:gerena/features/subscription/domain/entities/mysubcription/my_subcription_entity.dart';
import 'package:gerena/features/subscription/domain/entities/view_all_plans_entity.dart';
import 'package:gerena/features/subscription/domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImp  implements SubscriptionRepository{
  final SubscriptionDataSourcesImp subscriptionDataSourcesImp;
  SubscriptionRepositoryImp({required this.subscriptionDataSourcesImp});
  AuthService authService = AuthService();
  
  @override
  Future<void> cancelSubscription(bool cancelarInmediatamente, String motivo) async {
    final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await subscriptionDataSourcesImp.cancelSubscription(cancelarInmediatamente, motivo, token);
  }

  @override
  Future<void> changeSubscriptionPlan(int newPlanId, bool immediatechange) async {
        final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));

    return await subscriptionDataSourcesImp.changeSubscriptionPlan(newPlanId, immediatechange, token);
  }

  @override
  Future<List<ViewAllPlansEntity>> fetchAllPlans() async {
       final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await subscriptionDataSourcesImp.fetchAllPlans(token);
  }

  @override
  Future<MySubscriptionEntity> fetchMySubscription()async {
       final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));

    return await subscriptionDataSourcesImp.fetchMySubscription(token);
  }

  @override
  Future<void> reactivateSubscription()async {
        final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));

    return await subscriptionDataSourcesImp.reactivateSubscription( token);
  }

  @override
  Future<void> subscribeToPlan(String paymentMethodId, int planId) async {
        final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));

    return await subscriptionDataSourcesImp.subscribeToPlan(paymentMethodId, planId, token);
  }
 
}