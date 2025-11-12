import 'package:gerena/features/marketplace/domain/entities/addresses/addresses_entity.dart';
import 'package:gerena/features/marketplace/domain/usecase/addresses/get_addresses_usecase.dart';
import 'package:get/get.dart';

class AddressesController extends GetxController {
  final GetAddressesUsecase getAddressesUsecase;
  
  AddressesController({required this.getAddressesUsecase});

  // Estado reactivo
  final RxList<AddressesEntity> addresses = <AddressesEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<AddressesEntity> selectedAddress = Rxn<AddressesEntity>();

  @override
  void onInit() {
    super.onInit();
    getAddresses();
  }

  // Obtener direcciones
  Future<void> getAddresses() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final result = await getAddressesUsecase.execute();
      addresses.value = result;
      
      // Si hay direcciones, seleccionar la primera por defecto
      if (addresses.isNotEmpty && selectedAddress.value == null) {
        selectedAddress.value = addresses.first;
      }
    } catch (e) {
      errorMessage.value = 'Error al cargar direcciones: $e';
      print('❌ Error en getAddresses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Seleccionar una dirección
  void selectAddress(AddressesEntity address) {
    selectedAddress.value = address;
  }

  // Limpiar selección
  void clearSelection() {
    selectedAddress.value = null;
  }

  // Verificar si una dirección está seleccionada
  bool isSelected(String? id) {
    return selectedAddress.value?.id == id;
  }

  // Obtener dirección por ID
  AddressesEntity? getAddressById(String id) {
    try {
      return addresses.firstWhere((address) => address.id == id);
    } catch (e) {
      return null;
    }
  }

  // Refrescar direcciones
  Future<void> refreshAddresses() async {
    await getAddresses();
  }

  // Limpiar error
  void clearError() {
    errorMessage.value = '';
  }
}