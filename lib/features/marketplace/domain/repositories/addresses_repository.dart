import 'package:gerena/features/marketplace/domain/entities/addresses/addresses_entity.dart';

abstract class AddressesRepository {
     Future<List<AddressesEntity>> getAddresses() ;
      Future<void> postAddresses(AddressesEntity entity) ;
      Future<void> putAddresses(AddressesEntity entity, int idAddresse) ;
      Future<void> deleteAddresses(int id) ;

}