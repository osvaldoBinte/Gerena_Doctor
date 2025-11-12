import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/features/marketplace/data/datasources/Payment_data_sources_imp.dart';
import 'package:gerena/features/marketplace/domain/entities/payment/payment_method_entity.dart';
import 'package:gerena/features/marketplace/domain/repositories/payment_repository.dart';
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentDataSourcesImp paymentDataSourcesImp;
  AuthService authService = AuthService();
  


  PaymentRepositoryImpl({
    required this.paymentDataSourcesImp,
  });

  @override
  Future<List<PaymentMethodEntity>> getPaymentMethods() async {
    final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.')); 
    return await paymentDataSourcesImp.getPaymentMethods(token);
  }

  @override
  Future<PaymentMethodEntity> createPaymentMethod({
    String? cardholderName,
  }) async {
    return await paymentDataSourcesImp.createPaymentMethod(
      cardholderName: cardholderName,
    );

   
  }

  @override
  Future<void> attachPaymentMethodToCustomer({
    required String paymentMethodId,
    required String customerId,
  }) async {
    await paymentDataSourcesImp.attachPaymentMethodToCustomer(
      paymentMethodId: paymentMethodId,
      customerId: customerId,
    );
  }

  @override
  Future<void> deletePaymentMethod(String paymentMethodId) async {
    await paymentDataSourcesImp.detachPaymentMethod(paymentMethodId);
  }


  @override
  Future<String> createCustomer({
    required String email,
    String? name,
    String? phone,
  }) async {
    final customerId = await paymentDataSourcesImp.createCustomer(
      email: email,
      name: name,
      phone: phone,
    );

    await paymentDataSourcesImp.saveCustomerIdToBackend(
      customerId: customerId,
      token: 'token',
    );

    return customerId;
  }
  
  @override
  Future<void> createPayment(String paymentMethodId) async {
    final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return paymentDataSourcesImp.createPayment(token, paymentMethodId);
  }
  
  @override
  Future<void> confirmpayment(int id) async {
        final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    
    return paymentDataSourcesImp.confirmpayment(id,token);  
  }
}