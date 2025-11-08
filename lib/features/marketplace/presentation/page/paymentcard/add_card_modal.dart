import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/presentation/page/paymentcard/payment_cart_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class AddCardModal extends StatelessWidget {
  const AddCardModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaymentCartController>();

    return Container(
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Agregar Tarjeta',
                    style: GoogleFonts.rubik(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: GerenaColors.textPrimaryColor,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ⚠️ Mensaje para plataforma desktop
              if (GetPlatform.isDesktop)
                _buildDesktopWarning()
              else
                // 📱 Formulario completo para móvil
                _buildMobileForm(controller, context),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget de advertencia para desktop
  Widget _buildDesktopWarning() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: GerenaColors.warningColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: GerenaColors.warningColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.smartphone,
                size: 64,
                color: GerenaColors.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Agregar tarjetas solo en móvil',
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: GerenaColors.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Por seguridad y cumplimiento con las políticas  '
                'la función de agregar tarjetas solo está disponible en la aplicación móvil.',
                style: GoogleFonts.rubik(
                  fontSize: 14,
                  color: GerenaColors.textSecondaryColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: GerenaColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: GerenaColors.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Descarga la app móvil de Gerena para gestionar tus métodos de pago',
                        style: GoogleFonts.rubik(
                          fontSize: 12,
                          color: GerenaColors.textPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: GerenaColors.createPrimaryButton(
            text: 'Entendido',
            onPressed: () => Get.back(),
            isFullWidth: true,
            height: 45,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// Formulario completo para móvil
  Widget _buildMobileForm(PaymentCartController controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nombre del titular
        Text(
          'Nombre del titular (opcional)',
          style: GoogleFonts.rubik(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: GerenaColors.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.nameController,
          textCapitalization: TextCapitalization.words,
          style: GoogleFonts.rubik(fontSize: 16, color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Nombre completo',
            hintStyle: GoogleFonts.rubik(color: Colors.grey, fontSize: 16),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: GerenaColors.colorinput),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: GerenaColors.secondaryColor, width: 2),
            ),
            isDense: true,
          ),
        ),
        const SizedBox(height: 20),

        Text(
          'Datos de la tarjeta',
          style: GoogleFonts.rubik(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: GerenaColors.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),

        // CardFormField para móvil
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: GerenaColors.colorinput,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: CardFormField(
            onCardChanged: (details) => controller.updateCardDetails(details),
            style: CardFormStyle(
              borderColor: Colors.transparent,
              textColor: Colors.black,
              fontSize: 16,
              placeholderColor: Colors.grey.shade600,
              backgroundColor: Colors.white,
              cursorColor: Colors.black,
            ),
            enablePostalCode: false,
          ),
        ),
        const SizedBox(height: 15),

        // Indicador de validez
        Obx(() {
          final isValid = controller.isCardValid;
          if (!isValid && controller.cardDetails.value == null) {
            return const SizedBox.shrink();
          }

          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isValid 
                  ? GerenaColors.successColor.withOpacity(0.1)
                  : GerenaColors.warningColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isValid ? Icons.check_circle : Icons.info_outline,
                  color: isValid 
                      ? GerenaColors.successColor 
                      : GerenaColors.warningColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isValid 
                        ? '✓ Tarjeta válida'
                        : 'Completa todos los campos',
                    style: GoogleFonts.rubik(
                      fontSize: 12,
                      color: isValid 
                          ? GerenaColors.successColor 
                          : GerenaColors.warningColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 25),

        // Información de seguridad
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: GerenaColors.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: GerenaColors.primaryColor.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.security, size: 18, color: GerenaColors.primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tu información está protegida con encriptación de nivel bancario',
                  style: GoogleFonts.rubik(
                    fontSize: 11,
                    color: GerenaColors.textPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Botones
        Obx(() => Row(
          children: [
            Expanded(
              child: GerenaColors.createSecondaryButton(
                text: 'Cancelar',
                onPressed: controller.isProcessing.value 
                    ? () {} 
                    : () => Navigator.pop(context),
                isFullWidth: true,
                height: 45,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Opacity(
                opacity: (controller.isCardValid && !controller.isProcessing.value) 
                    ? 1.0 
                    : 0.5,
                child: GerenaColors.createPrimaryButton(
                  text: controller.isProcessing.value 
                      ? 'Procesando...' 
                      : 'Agregar',
                  onPressed: (controller.isCardValid && !controller.isProcessing.value)
                      ? () async {
                          final success = await controller.handleAddCard();
                          if (success && context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      : () {},
                  isFullWidth: true,
                  height: 45,
                ),
              ),
            ),
          ],
        )),
        const SizedBox(height: 20),
      ],
    );
  }
}

// Formateador para número de tarjeta (ya no se usa en móvil, pero lo dejo por si acaso)
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }
    
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Formateador para fecha de expiración (ya no se usa en móvil, pero lo dejo por si acaso)
class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    
    // Validar mes mientras el usuario escribe
    if (text.length >= 2) {
      final month = int.tryParse(text.substring(0, 2));
      if (month != null && month > 12) {
        return oldValue;
      }
    }
    
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && text.length > 2) {
        buffer.write('/');
      }
    }
    
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}