import 'package:gerena/features/marketplace/domain/repositories/payment_repository.dart';

class AttachPaymentMethodToCustomerUsecase {
  final PaymentRepository repository;
  AttachPaymentMethodToCustomerUsecase({required this.repository});
  Future<void> execute({
    required String paymentMethodId,
    required String customerId,
  }) async {
    return await repository.attachPaymentMethodToCustomer(
      paymentMethodId: paymentMethodId,
      customerId: customerId,
    );
  }
}