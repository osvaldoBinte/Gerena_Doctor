import 'package:gerena/features/marketplace/domain/repositories/payment_repository.dart';

class SavecardUsecase {
  final PaymentRepository paymentRepository;

  SavecardUsecase({required this.paymentRepository});

  Future<void> execute(String paymentMethodId) async {
    return await paymentRepository.createPaymentMethodback(paymentMethodId);
  }
}