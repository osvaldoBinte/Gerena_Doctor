import 'package:gerena/features/marketplace/domain/entities/addresses/addresses_entity.dart';
import 'package:gerena/features/marketplace/domain/repositories/addresses_repository.dart';

class PostAddressesUsecase {
  final AddressesRepository addressesRepository;
  PostAddressesUsecase({required this.addressesRepository});
  Future<void> postAddresses(AddressesEntity entity) async {
    return await addressesRepository.postAddresses(entity);
  }

}