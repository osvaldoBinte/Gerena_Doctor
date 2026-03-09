import 'package:gerena/features/subscription/domain/repositories/subscription_repository.dart';


class VerifyIAPPurchaseUsecase {
  final SubscriptionRepository subscriptionRepository;

  VerifyIAPPurchaseUsecase({required this.subscriptionRepository});

  Future<void> execute(
    String receiptData,
    String productId,
    String platform,
  ) async {
    return await subscriptionRepository.verifyIAPPurchase(
      receiptData,
      productId,
      platform,
    );
  }
}