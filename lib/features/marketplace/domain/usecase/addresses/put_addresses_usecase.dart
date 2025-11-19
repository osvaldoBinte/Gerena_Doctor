import 'package:gerena/features/marketplace/domain/entities/addresses/addresses_entity.dart';
import 'package:gerena/features/marketplace/domain/repositories/addresses_repository.dart';

class PutAddressesUsecase {
  final AddressesRepository addressesRepository;
  PutAddressesUsecase({required this.addressesRepository});
  Future<void> execute(AddressesEntity entity, int idAddresse) async {
    return addressesRepository.putAddresses(entity, idAddresse);
  }
}