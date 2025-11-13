import 'package:gerena/features/subscription/domain/entities/view_all_plans_entity.dart';
import 'package:gerena/features/subscription/domain/repositories/subscription_repository.dart';

class GetAllPlansUsecase {
  final SubscriptionRepository subscriptionRepository;
  GetAllPlansUsecase({required this.subscriptionRepository});
  Future<List <ViewAllPlansEntity>> execute() async {
    return await subscriptionRepository.fetchAllPlans();
  }
}