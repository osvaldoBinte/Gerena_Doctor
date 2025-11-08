import 'package:gerena/features/marketplace/domain/repositories/payment_repository.dart';

class DeletePaymentMethodUsecase {
  final PaymentRepository repository;

  DeletePaymentMethodUsecase({required this.repository});

  Future<void> execute(String paymentMethodId) async {
    return await repository.deletePaymentMethod(paymentMethodId);
  }
}