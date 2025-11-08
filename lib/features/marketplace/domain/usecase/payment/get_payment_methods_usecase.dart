import 'package:gerena/features/marketplace/domain/entities/payment/payment_method_entity.dart';
import 'package:gerena/features/marketplace/domain/repositories/payment_repository.dart';

class GetPaymentMethodsUsecase {
  final PaymentRepository repository;
  GetPaymentMethodsUsecase({required this.repository});
  Future<List<PaymentMethodEntity>> execute(String customerId) async {
    return await repository.getPaymentMethods(customerId);
  }
}