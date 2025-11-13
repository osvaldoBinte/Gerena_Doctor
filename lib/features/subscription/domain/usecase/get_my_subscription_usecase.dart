import 'package:gerena/features/subscription/domain/entities/mysubcription/my_subcription_entity.dart';
import 'package:gerena/features/subscription/domain/repositories/subscription_repository.dart';

class GetMySubscriptionUsecase  {
  final SubscriptionRepository subscriptionRepository;
  GetMySubscriptionUsecase({required this.subscriptionRepository});
  Future<MySubscriptionEntity> execute() async {
    return await subscriptionRepository.fetchMySubscription();
  }
}