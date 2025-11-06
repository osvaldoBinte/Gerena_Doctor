
import 'package:gerena/features/marketplace/domain/entities/payment/customer_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/payment/payment_method_entity.dart';

abstract class PaymentRepository {
  /// Obtener todos los métodos de pago de un customer
  Future< List<PaymentMethodEntity>> getPaymentMethods(
    String customerId,
  );

  /// Agregar un nuevo método de pago usando CardFormField
  Future< PaymentMethodEntity> addPaymentMethod({
    required String customerId,
    String? cardholderName,
  });

  /// Eliminar un método de pago
  Future< void> deletePaymentMethod(
    String paymentMethodId,
  );

  /// Obtener el customer ID del usuario actual
  Future< String> getCustomerId();

  /// Crear un nuevo customer en Stripe
  Future<CustomerEntity> createCustomer({
    required String email,
    String? name,
    String? phone,
  });

  /// Adjuntar un payment method a un customer
  Future< void> attachPaymentMethodToCustomer({
    required String paymentMethodId,
    required String customerId,
  });

  /// Establecer un payment method como predeterminado
  Future< void> setDefaultPaymentMethod({
    required String customerId,
    required String paymentMethodId,
  });
}