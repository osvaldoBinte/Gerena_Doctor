import 'package:gerena/features/marketplace/domain/entities/addresses/addresses_entity.dart';

abstract class AddressesRepository {
     Future<List<AddressesEntity>> getAddresses() ;
      Future<void> postAddresses(int paymentIntentId) ;
      Future<void> putAddresses(int paymentIntentId) ;
      Future<void> deliteAddresses(int id) ;

}