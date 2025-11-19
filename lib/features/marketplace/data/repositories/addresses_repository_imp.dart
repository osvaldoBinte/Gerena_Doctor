import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/features/marketplace/data/datasources/addresses_data_sources_imp.dart';
import 'package:gerena/features/marketplace/domain/entities/addresses/addresses_entity.dart';
import 'package:gerena/features/marketplace/domain/repositories/addresses_repository.dart';

class AddressesRepositoryImp implements AddressesRepository {
  final AddressesDataSourcesImp addressesDataSourcesImp;
  AddressesRepositoryImp({required this.addressesDataSourcesImp});
  final AuthService authService = AuthService();
  @override
  Future<void> deleteAddresses(int id) async {
    final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return addressesDataSourcesImp.deleteAddresses(id, token);
  }



  @override
  Future<void> postAddresses(AddressesEntity entity) async {
    final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await addressesDataSourcesImp.postAddresses(entity, token);
  }



  @override
  Future<List<AddressesEntity>> getAddresses() async {
    final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await addressesDataSourcesImp.getAddresses(token);
  }
  
  @override
  Future<void> putAddresses(AddressesEntity entity, int idAddresse) async {
    final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await addressesDataSourcesImp.putAddresses(entity, idAddresse, token);
  }
}