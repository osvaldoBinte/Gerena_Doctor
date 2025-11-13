import 'package:gerena/features/subscription/domain/repositories/subscription_repository.dart';

class PostCancelSubcriptionUsecase {
  final SubscriptionRepository subscriptionRepository;
  PostCancelSubcriptionUsecase({required this.subscriptionRepository});
  Future<void> execute(bool cancelarInmediatamente , String motivo) async {
    return await subscriptionRepository.cancelSubscription(cancelarInmediatamente, motivo);
  }
}