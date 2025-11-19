import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/presentation/page/addresses/addresses_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddAddressModal extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  AddAddressModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddressesController controller = Get.find<AddressesController>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 600 ? 100 : 20,
        vertical: 40,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: GerenaColors.backgroundColor,
          borderRadius: GerenaColors.mediumBorderRadius,
          boxShadow: [GerenaColors.mediumShadow],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Header dinámico según si es crear o editar
            Container(
              padding: EdgeInsets.all(GerenaColors.paddingMedium),
              decoration: BoxDecoration(
                color: GerenaColors.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(GerenaColors.mediumRadius),
                  topRight: Radius.circular(GerenaColors.mediumRadius),
                ),
              ),
              child: Row(
                children: [
                  Obx(() => Icon(
                    controller.isEditing.value 
                        ? Icons.edit_location_alt 
                        : Icons.add_location_alt,
                    color: GerenaColors.textLightColor,
                    size: 24,
                  )),
                  SizedBox(width: GerenaColors.paddingSmall),
                  Expanded(
                    child: Obx(() => Text(
                      controller.isEditing.value 
                          ? 'Editar Dirección' 
                          : 'Agregar Nueva Dirección',
                      style: GoogleFonts.rubik(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: GerenaColors.textLightColor,
                      ),
                    )),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: GerenaColors.textLightColor,
                    ),
                    onPressed: () {
                      controller.clearForm();
                      Get.back();
                    },
                  ),
                ],
              ),
            ),

            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(GerenaColors.paddingMedium),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Información Personal'),
                      SizedBox(height: GerenaColors.paddingSmall),
                      
                      _buildTextFormField(
                        label: 'Nombre Completo *',
                        controller: controller.fullNameController,
                        hintText: 'Ej. Juan Pérez García',
                        validator: (value) => controller.validateRequired(value, 'Nombre completo'),
                      ),
                      SizedBox(height: GerenaColors.paddingMedium),

                      _buildTextFormField(
                        label: 'Teléfono *',
                        controller: controller.phoneController,
                        hintText: 'Ej. 3312345678',
                        keyboardType: TextInputType.phone,
                        inputFormatters: controller.phoneFormatters,
                        validator: controller.validatePhone,
                      ),
                      SizedBox(height: GerenaColors.paddingLarge),

                      _buildSectionTitle('Dirección'),
                      SizedBox(height: GerenaColors.paddingSmall),

                      _buildTextFormField(
                        label: 'Calle *',
                        controller: controller.streetController,
                        hintText: 'Ej. Av. Chapultepec',
                        validator: (value) => controller.validateRequired(value, 'Calle'),
                      ),
                      SizedBox(height: GerenaColors.paddingMedium),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextFormField(
                              label: 'Número Exterior *',
                              controller: controller.exteriorNumberController,
                              hintText: 'Ej. 123',
                              keyboardType: TextInputType.number,
                              inputFormatters: controller.numberFormatters,
                              validator: (value) => controller.validateRequired(value, 'Número exterior'),
                            ),
                          ),
                          SizedBox(width: GerenaColors.paddingMedium),
                          Expanded(
                            child: _buildTextFormField(
                              label: 'Número Interior',
                              controller: controller.interiorNumberController,
                              hintText: 'Ej. 4B',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: GerenaColors.paddingMedium),

                      _buildTextFormField(
                        label: 'Colonia *',
                        controller: controller.neighborhoodController,
                        hintText: 'Ej. Centro',
                        validator: (value) => controller.validateRequired(value, 'Colonia'),
                      ),
                      SizedBox(height: GerenaColors.paddingMedium),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextFormField(
                              label: 'Ciudad *',
                              controller: controller.cityController,
                              hintText: 'Ej. Guadalajara',
                              validator: (value) => controller.validateRequired(value, 'Ciudad'),
                            ),
                          ),
                          SizedBox(width: GerenaColors.paddingMedium),
                          Expanded(
                            child: _buildTextFormField(
                              label: 'Estado *',
                              controller: controller.stateController,
                              hintText: 'Ej. Jalisco',
                              validator: (value) => controller.validateRequired(value, 'Estado'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: GerenaColors.paddingMedium),

                      _buildTextFormField(
                        label: 'Código Postal *',
                        controller: controller.postalCodeController,
                        hintText: 'Ej. 44100',
                        keyboardType: TextInputType.number,
                        inputFormatters: controller.postalCodeFormatters,
                        validator: controller.validatePostalCode,
                      ),
                      SizedBox(height: GerenaColors.paddingMedium),

                      _buildTextFormField(
                        label: 'Referencias',
                        controller: controller.referencesController,
                        hintText: 'Ej. Entre calle X y Y, casa color azul',
                        maxLines: 3,
                      ),
                      SizedBox(height: GerenaColors.paddingSmall),

                      Text(
                        '* Campos obligatorios',
                        style: GoogleFonts.rubik(
                          fontSize: 12,
                          color: GerenaColors.textSecondaryColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.all(GerenaColors.paddingMedium),
              decoration: BoxDecoration(
                color: GerenaColors.backgroundColorfondo,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(GerenaColors.mediumRadius),
                  bottomRight: Radius.circular(GerenaColors.mediumRadius),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GerenaColors.widgetButton(
                    onPressed: () {
                      controller.clearForm();
                      Get.back();
                    },
                    text: 'CANCELAR',
                    backgroundColor: GerenaColors.colorCancelar,
                    textColor: GerenaColors.textPrimaryColor,
                    borderRadius: GerenaColors.smallRadius,
                    showShadow: false,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  SizedBox(width: GerenaColors.paddingMedium),
                  Obx(() => GerenaColors.widgetButton(
                    onPressed: controller.isSaving.value 
                        ? null 
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              await controller.saveAddress();
                            }
                          },
                    text: controller.isEditing.value ? 'ACTUALIZAR' : 'GUARDAR',
                    backgroundColor: GerenaColors.secondaryColor,
                    textColor: GerenaColors.textLightColor,
                    borderRadius: GerenaColors.smallRadius,
                    showShadow: true,
                    isLoading: controller.isSaving.value,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: GerenaColors.accentColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: GerenaColors.paddingSmall),
        Text(
          title,
          style: GoogleFonts.rubik(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: GerenaColors.textPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.rubik(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: GerenaColors.textPrimaryColor,
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          validator: validator,
          style: GoogleFonts.rubik(
            fontSize: 16,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.rubik(
              color: GerenaColors.textSecondaryColor.withOpacity(0.6),
              fontSize: 16,
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 9,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(
                color: GerenaColors.colorinput,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(
                color: GerenaColors.colorinput,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(
                color: GerenaColors.errorColor,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(
                color: GerenaColors.errorColor,
                width: 1.5,
              ),
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }
}