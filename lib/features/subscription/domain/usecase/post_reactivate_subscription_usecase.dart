import 'package:gerena/features/subscription/domain/repositories/subscription_repository.dart';

class PostReactivateSubscriptionUsecase {
  final SubscriptionRepository subscriptionRepository;
  PostReactivateSubscriptionUsecase({required this.subscriptionRepository});
  Future<void> execute() async {
    return await subscriptionRepository.reactivateSubscription();
  }
}