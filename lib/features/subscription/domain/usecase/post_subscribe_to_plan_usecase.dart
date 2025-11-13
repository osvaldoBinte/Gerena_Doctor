import 'package:gerena/features/subscription/domain/repositories/subscription_repository.dart';

class PostSubscribeToPlanUsecase {
  final SubscriptionRepository subscriptionRepository;
  PostSubscribeToPlanUsecase({required this.subscriptionRepository});
  Future<void> execute(String paymentMethodId, int planId) async {
    return await subscriptionRepository.subscribeToPlan(paymentMethodId, planId);
  }
}