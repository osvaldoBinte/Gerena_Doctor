import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/custom_alert_type.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/marketplace/domain/entities/addresses/addresses_entity.dart';
import 'package:gerena/features/marketplace/domain/usecase/addresses/get_addresses_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/addresses/post_addresses_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/addresses/put_addresses_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/addresses/delete_addresses_usecase.dart';
import 'package:get/get.dart';

class AddressesController extends GetxController {
  final GetAddressesUsecase getAddressesUsecase;
  final PostAddressesUsecase postAddressesUsecase;
  final PutAddressesUsecase putAddressesUsecase;
  final DeleteAddressesUsecase deleteAddressesUsecase;
  
  AddressesController({
    required this.getAddressesUsecase,
    required this.postAddressesUsecase,
    required this.putAddressesUsecase,
    required this.deleteAddressesUsecase,
  });

  final RxList<AddressesEntity> addresses = <AddressesEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isDeleting = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<AddressesEntity> selectedAddress = Rxn<AddressesEntity>();
  
  final RxBool isEditing = false.obs;
  final Rxn<int> editingAddressId = Rxn<int>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController exteriorNumberController = TextEditingController();
  final TextEditingController interiorNumberController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController referencesController = TextEditingController();

  final List<TextInputFormatter> phoneFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ];

  final List<TextInputFormatter> postalCodeFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(5),
  ];

  final List<TextInputFormatter> numberFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ];

  @override
  void onInit() {
    super.onInit();
    getAddresses();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    streetController.dispose();
    exteriorNumberController.dispose();
    interiorNumberController.dispose();
    neighborhoodController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    referencesController.dispose();
    super.onClose();
  }

  Future<void> getAddresses() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final result = await getAddressesUsecase.execute();
      addresses.value = result;
      
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

  void prepareForEdit(AddressesEntity address) {
    isEditing.value = true;
    editingAddressId.value = address.id;
    
    fullNameController.text = address.fullName;
    phoneController.text = address.phone;
    streetController.text = address.street;
    exteriorNumberController.text = address.exteriorNumber;
    interiorNumberController.text = address.interiorNumber;
    neighborhoodController.text = address.neighborhood;
    cityController.text = address.city;
    stateController.text = address.state;
    postalCodeController.text = address.postalCode;
    referencesController.text = address.references;
  }

  Future<void> saveAddress() async {
    try {
      isSaving.value = true;

      final addressData = AddressesEntity(
        fullName: fullNameController.text.trim(),
        phone: phoneController.text.trim(),
        street: streetController.text.trim(),
        exteriorNumber: exteriorNumberController.text.trim(),
        interiorNumber: interiorNumberController.text.trim(),
        neighborhood: neighborhoodController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        postalCode: postalCodeController.text.trim(),
        references: referencesController.text.trim(),
      );

      if (isEditing.value && editingAddressId.value != null) {
        // ✅ Guardar el ID que estamos editando
        final editedAddressId = editingAddressId.value!;
        
        await putAddressesUsecase.execute(addressData, editedAddressId);
        
        await refreshAddresses();
        
        // ✅ Actualizar selectedAddress si es la que se editó
        if (selectedAddress.value?.id == editedAddressId) {
          // Buscar la dirección actualizada en la lista
          final updatedAddress = addresses.firstWhereOrNull(
            (addr) => addr.id == editedAddressId
          );
          if (updatedAddress != null) {
            selectedAddress.value = updatedAddress;
          }
        }
        
        clearForm();
        
        Get.back();
        
        await Future.delayed(Duration(milliseconds: 100));
        showSuccessSnackbar('Dirección actualizada correctamente');
     
      } else {
        await postAddressesUsecase.postAddresses(addressData);
        
        await refreshAddresses();
        clearForm();
        
        Get.back();
        
        await Future.delayed(Duration(milliseconds: 100));
        showSuccessSnackbar('Dirección guardada correctamente');
      }
      
    } catch (e) {
      Get.back();
      
      await Future.delayed(Duration(milliseconds: 100));
      showErrorSnackbar(
        isEditing.value 
            ? 'No se pudo actualizar la dirección' 
            : 'No se pudo guardar la dirección'
      );
   
      print('❌ Error al guardar dirección: $e');
    } finally {
      isSaving.value = false;
    }
  }

  // ✅ MÉTODO ACTUALIZADO: Ahora cierra el selector después de eliminar
  Future<void> deleteAddress(int addressId, {bool closeSelector = false}) async {
    final confirmed = await Get.dialog<bool>(
      CustomAlertDialog(
        title: '¿Eliminar dirección?',
        message: '¿Estás seguro de que deseas eliminar esta dirección? Esta acción no se puede deshacer.',
        confirmText: 'ELIMINAR',
        cancelText: 'CANCELAR',
        type: CustomAlertType.error,
        onConfirm: () => Get.back(result: true),
        onCancel: () => Get.back(result: false),
      ),
      barrierDismissible: false,
    );

    if (confirmed == true) {
      try {
        isDeleting.value = true;
        
        await deleteAddressesUsecase.execute(addressId);
        
        if (selectedAddress.value?.id == addressId) {
          selectedAddress.value = null;
        }
        
        await refreshAddresses();
        
        if (addresses.isNotEmpty && selectedAddress.value == null) {
          selectedAddress.value = addresses.first;
        }
        
        // ✅ Si closeSelector es true, cerrar el diálogo selector
        if (closeSelector) {
          Get.back();
        }
        
        // ✅ Pequeño delay para asegurar que la UI se actualizó
        await Future.delayed(Duration(milliseconds: 150));
        
        showSuccessSnackbar('Dirección eliminada correctamente');
        
      } catch (e) {
        showErrorSnackbar('No se pudo eliminar la dirección');
        print('❌ Error al eliminar dirección: $e');
      } finally {
        isDeleting.value = false;
      }
    }
  }

  void clearForm() {
    fullNameController.clear();
    phoneController.clear();
    streetController.clear();
    exteriorNumberController.clear();
    interiorNumberController.clear();
    neighborhoodController.clear();
    cityController.clear();
    stateController.clear();
    postalCodeController.clear();
    referencesController.clear();
    
    isEditing.value = false;
    editingAddressId.value = null;
  }

  void selectAddress(AddressesEntity address) {
    selectedAddress.value = address;
  }

  void clearSelection() {
    selectedAddress.value = null;
  }

  bool isSelected(int? id) {
    return selectedAddress.value?.id == id;
  }

  AddressesEntity? getAddressById(int id) {
    try {
      return addresses.firstWhere((address) => address.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> refreshAddresses() async {
    await getAddresses();
  }

  void clearError() {
    errorMessage.value = '';
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Teléfono es requerido';
    }
    if (value.trim().length != 10) {
      return 'Teléfono debe tener 10 dígitos';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Teléfono solo puede contener números';
    }
    return null;
  }

  String? validatePostalCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Código postal es requerido';
    }
    if (value.trim().length != 5) {
      return 'Código postal debe tener 5 dígitos';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Código postal solo puede contener números';
    }
    return null;
  }

  String? validateExteriorNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Número exterior es requerido';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Número exterior solo puede contener números';
    }
    return null;
  }

  String? validateInteriorNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (!RegExp(r'^[0-9A-Za-z]+$').hasMatch(value.trim())) {
      return 'Número interior solo puede contener letras y números';
    }
    return null;
  }
}