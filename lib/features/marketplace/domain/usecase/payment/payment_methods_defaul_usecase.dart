import 'package:gerena/features/marketplace/domain/repositories/payment_repository.dart';

class PaymentMethodsDefaulUsecase {
  final PaymentRepository repository;

  PaymentMethodsDefaulUsecase({required this.repository});

  Future<void> execute(int id) async {
    return repository.confirmpayment(id);
  }
}