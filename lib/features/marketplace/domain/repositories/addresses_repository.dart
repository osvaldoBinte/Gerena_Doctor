import 'package:gerena/features/marketplace/domain/entities/addresses/addresses_entity.dart';

abstract class AddressesRepository {
     Future<List<AddressesEntity>> getAddresses() ;
      Future<void> postAddresses(AddressesEntity entity) ;
      Future<void> putAddresses(int paymentIntentId) ;
      Future<void> deliteAddresses(int id) ;

}