import 'package:gerena/features/marketplace/domain/entities/payment/payment_method_entity.dart';
import 'package:gerena/features/marketplace/domain/repositories/payment_repository.dart';

class CreatePaymentMethodUsecase {
  final PaymentRepository repository;

  CreatePaymentMethodUsecase({required this.repository});

  Future<PaymentMethodEntity> execute({String? cardholderName}) async {
    return await repository.createPaymentMethod(
      cardholderName: cardholderName,
    );
  }
}