import 'package:gerena/features/marketplace/domain/repositories/payment_repository.dart';

class DeletePaymentMethodBackUsecase {
  final PaymentRepository repository;

  DeletePaymentMethodBackUsecase({required this.repository});

  Future<void> execute(int id) async {
    return await repository.deletePaymentMethodback(id);
  }
}