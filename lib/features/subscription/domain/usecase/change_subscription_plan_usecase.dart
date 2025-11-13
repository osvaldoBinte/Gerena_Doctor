import 'package:gerena/features/subscription/domain/repositories/subscription_repository.dart';

class ChangeSubscriptionPlanUsecase {
  final SubscriptionRepository subscriptionRepository;

  ChangeSubscriptionPlanUsecase({required this.subscriptionRepository});

  Future<void> execute(int newPlanId, bool immediatechange) async {
    return await subscriptionRepository.changeSubscriptionPlan(newPlanId, immediatechange);
  }
}