import 'package:gerena/features/marketplace/domain/repositories/addresses_repository.dart';

class DeleteAddressesUsecase {
  final AddressesRepository addressesRepository;
  DeleteAddressesUsecase({required this.addressesRepository});
  Future<void> execute(int idAddresse) async {
    addressesRepository.deleteAddresses(idAddresse);
  }
}