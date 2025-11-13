
import 'package:gerena/features/marketplace/domain/entities/payment/customer_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/payment/payment_method_entity.dart';

abstract class PaymentRepository {
  Future<List<PaymentMethodEntity>> getPaymentMethods();

  Future<PaymentMethodEntity> createPaymentMethod({
    String? cardholderName,
  });
  Future<void> createPaymentMethodback(
    String paymentMethodId,
  );
  Future<void> attachPaymentMethodToCustomer({
    required String paymentMethodId,
    required String customerId,
  });

  Future<void> deletePaymentMethod(String paymentMethodId);
 Future<void> createPayment(String paymentMethodId) ;
 

  Future<String> createCustomer({
    required String email,
    String? name,
    String? phone,
  });
    Future<void> confirmpayment(int id);

  
}