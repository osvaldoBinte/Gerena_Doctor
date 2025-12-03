import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/domain/entities/addresses/addresses_entity.dart';
import 'package:gerena/features/marketplace/presentation/page/addresses/add_address_modal.dart';
import 'package:gerena/features/marketplace/presentation/page/addresses/addresses_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/addresses/getaddress_/loading/address_selector_loading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressSelectorWidget extends StatelessWidget {
  final AddressesController addressesController;
  final Function(AddressesEntity)? onAddressSelected;

  const AddressSelectorWidget({
    Key? key,
    required this.addressesController,
    this.onAddressSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (addressesController.isLoading.value) {
        return AddressSelectorLoading();
      }

      if (addressesController.errorMessage.value.isNotEmpty) {
        return _buildErrorState();
      }

      if (addressesController.addresses.isEmpty) {
        return _buildEmptyState();
      }

      return _buildAddressContent();
    });
  }
  Widget _buildErrorState() {
    return Column(
      children: [
        Text(
          addressesController.errorMessage.value,
          style: GoogleFonts.rubik(
            color: Colors.red,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: () => addressesController.getAddresses(),
          icon: Icon(Icons.refresh),
          label: Text('Reintentar'),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Text(
          'No tienes direcciones guardadas',
          style: GoogleFonts.rubik(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: () {
            Get.dialog(
              AddAddressModal(),
              barrierDismissible: false,
            );
          },
          icon: Icon(Icons.add_location),
          label: Text('Agregar dirección'),
          style: TextButton.styleFrom(
            foregroundColor: GerenaColors.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressContent() {
    return Obx(() {
      final selectedAddress = addressesController.selectedAddress.value;

      if (selectedAddress == null && addressesController.addresses.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final firstAddress = addressesController.addresses.first;
          addressesController.selectAddress(firstAddress);
          
          if (onAddressSelected != null) {
            onAddressSelected!(firstAddress);
          }
        });
      }

      return Column(
        children: [
          if (selectedAddress != null)
            _buildSelectedAddress(selectedAddress),

          const SizedBox(height: 10),

          if (addressesController.addresses.length > 1)
            _buildChangeAddressButton(),
        ],
      );
    });
  }

  Widget _buildSelectedAddress(AddressesEntity address) {
    final fullAddress = '${address.street} ${address.exteriorNumber}'
        '${address.interiorNumber.isNotEmpty ? ', Int. ${address.interiorNumber}' : ''}, '
        '${address.neighborhood}, ${address.city}, ${address.state}, '
        'C.P. ${address.postalCode}';

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset(
              'assets/icons/check.png',
              width: 30,
              height: 30,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.check_circle,
                  color: GerenaColors.primaryColor,
                  size: 30,
                );
              },
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${address.fullName} ${address.phone}',
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  fullAddress,
                  style: GoogleFonts.rubik(
                    fontSize: 13,
                    color: GerenaColors.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _showAddressSelector(Get.context!),
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              child: Image.asset(
                'assets/icons/edit.png',
                width: 30,
                height: 30,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.edit, color: Colors.grey, size: 30);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeAddressButton() {
    return InkWell(
      onTap: () => _showAddressSelector(Get.context!),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, color: Colors.grey[600]),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                'Cambiar dirección de entrega',
                style: GoogleFonts.rubik(
                  fontWeight: FontWeight.w500,
                  color: GerenaColors.textPrimaryColor,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }
  void _showAddressSelector(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 600,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDialogHeader(),
              SizedBox(height: 16),
              _buildAddressList(),
              SizedBox(height: 16),
              _buildAddNewAddressButton(),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildDialogHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Selecciona una dirección',
            style: GoogleFonts.rubik(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: GerenaColors.textPrimaryColor,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Get.back(),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildAddressList() {
    return Flexible(
      child: Obx(() {
        return SingleChildScrollView(
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: addressesController.addresses.length,
            separatorBuilder: (context, index) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final address = addressesController.addresses[index];
              final isSelected =
                  addressesController.selectedAddress.value?.id == address.id;

              return _buildAddressOption(
                address: address,
                isSelected: isSelected,
                onTap: () {
                  addressesController.selectAddress(address);
                  
                  if (onAddressSelected != null) {
                    onAddressSelected!(address);
                  }
                  
                  Get.back();
                },
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildAddNewAddressButton() {
    return OutlinedButton.icon(
      onPressed: () {
        Get.back();
        Get.dialog(
          AddAddressModal(),
          barrierDismissible: false,
        );
      },
      icon: Icon(Icons.add_location),
      label: Text('Agregar nueva dirección'),
      style: OutlinedButton.styleFrom(
        foregroundColor: GerenaColors.primaryColor,
        side: BorderSide(color: GerenaColors.primaryColor),
        minimumSize: Size(double.infinity, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildAddressOption({
    required AddressesEntity address,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final fullAddress = '${address.street} ${address.exteriorNumber}'
        '${address.interiorNumber.isNotEmpty ? ', Int. ${address.interiorNumber}' : ''}, '
        '${address.neighborhood}, ${address.city}, ${address.state}, '
        'C.P. ${address.postalCode}';

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? GerenaColors.primaryColor : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: isSelected
            ? GerenaColors.primaryColor.withOpacity(0.05)
            : Colors.white,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: isSelected ? GerenaColors.primaryColor : Colors.grey[600],
                    size: 40,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address.fullName,
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: GerenaColors.textPrimaryColor,
                          ),
                        ),
                        Text(
                          address.phone,
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          fullAddress,
                          style: GoogleFonts.rubik(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: GerenaColors.primaryColor,
                      size: 28,
                    )
                  else
                    Icon(
                      Icons.radio_button_unchecked,
                      color: Colors.grey[400],
                      size: 28,
                    ),
                ],
              ),
            ),
          ),
          
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      addressesController.prepareForEdit(address);
                      Get.dialog(
                        AddAddressModal(),
                        barrierDismissible: false,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey[200]!, width: 1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/edit.png',
                            width: 18,
                            height: 18,
                            color: GerenaColors.primaryColor,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.edit, 
                                size: 18, 
                                color: GerenaColors.primaryColor,
                              );
                            },
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Editar',
                            style: GoogleFonts.rubik(
                              color: GerenaColors.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (address.id != null) {
                        addressesController.deleteAddress(address.id!, closeSelector: true);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/delete.png',
                            width: 18,
                            height: 18,
                            color: Colors.red,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.delete_outline, 
                                size: 18, 
                                color: Colors.red,
                              );
                            },
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Eliminar',
                            style: GoogleFonts.rubik(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}