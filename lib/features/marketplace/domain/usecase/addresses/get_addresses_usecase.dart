import 'package:gerena/features/marketplace/domain/entities/addresses/addresses_entity.dart';
import 'package:gerena/features/marketplace/domain/repositories/addresses_repository.dart';

class GetAddressesUsecase {
  final AddressesRepository addressesRepository;

  GetAddressesUsecase({required this.addressesRepository});

  Future<List<AddressesEntity>> execute() async {
    return addressesRepository.getAddresses();
  }
}