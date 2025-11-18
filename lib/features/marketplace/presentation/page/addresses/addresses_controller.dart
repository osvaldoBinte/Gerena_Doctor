import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ Importar para FilteringTextInputFormatter
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/domain/entities/addresses/addresses_entity.dart';
import 'package:gerena/features/marketplace/domain/usecase/addresses/get_addresses_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/addresses/post_addresses_usecase.dart';
import 'package:get/get.dart';

class AddressesController extends GetxController {
  final GetAddressesUsecase getAddressesUsecase;
  final PostAddressesUsecase postAddressesUsecase;
  
  AddressesController({
    required this.getAddressesUsecase,
    required this.postAddressesUsecase,
  });

  final RxList<AddressesEntity> addresses = <AddressesEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<AddressesEntity> selectedAddress = Rxn<AddressesEntity>();

  // Controllers para el formulario
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

  // ✅ Input formatters para campos numéricos
  final List<TextInputFormatter> phoneFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10), // Máximo 10 dígitos
  ];

  final List<TextInputFormatter> postalCodeFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(5), // Máximo 5 dígitos
  ];

  final List<TextInputFormatter> numberFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10), // Máximo 10 dígitos para números de casa
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

  Future<void> saveAddress() async {
    try {
      isSaving.value = true;

      final newAddress = AddressesEntity(
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

      await postAddressesUsecase.postAddresses(newAddress);
      await refreshAddresses();
      clearForm();

      Get.back();
      Get.snackbar(
        'Éxito',
        'Dirección guardada correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: GerenaColors.successColor,
        colorText: GerenaColors.textLightColor,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo guardar la dirección',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: GerenaColors.errorColor,
        colorText: GerenaColors.textLightColor,
        duration: Duration(seconds: 3),
      );
      print('Error al guardar dirección: $e');
    } finally {
      isSaving.value = false;
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

  // Validaciones
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
    // ✅ Validar que solo contenga números
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
    // ✅ Validar que solo contenga números
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Código postal solo puede contener números';
    }
    return null;
  }

  // ✅ Nueva validación para número exterior
  String? validateExteriorNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Número exterior es requerido';
    }
    // ✅ Validar que solo contenga números
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Número exterior solo puede contener números';
    }
    return null;
  }

  // ✅ Validación opcional para número interior (puede tener letras y números)
  String? validateInteriorNumber(String? value) {
    // Interior es opcional, así que si está vacío es válido
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    // Permitir números y letras para interior (ej: 4B, 101A)
    if (!RegExp(r'^[0-9A-Za-z]+$').hasMatch(value.trim())) {
      return 'Número interior solo puede contener letras y números';
    }
    return null;
  }
}