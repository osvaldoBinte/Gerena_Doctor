import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/presentation/page/paymentcard/payment_cart_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class AddCardModal extends StatefulWidget {
  const AddCardModal({Key? key}) : super(key: key);

  @override
  State<AddCardModal> createState() => _AddCardModalState();
}

class _AddCardModalState extends State<AddCardModal> {
  bool _isProcessing = false;
  CardFieldInputDetails? _cardDetails;
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: BorderRadius.only(
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
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Nombre del titular (opcional)
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
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                style: GoogleFonts.rubik(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Nombre completo',
                  hintStyle: GoogleFonts.rubik(color: Colors.grey, fontSize: 16),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

              // Formulario NATIVO de Stripe - Maneja TODO automáticamente
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: GerenaColors.colorinput),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: CardFormField(
                  onCardChanged: (details) {
                    setState(() {
                      _cardDetails = details;
                    });
                    print('📝 Card changed: complete=${details?.complete}');
                  },
                  style: CardFormStyle(
                    borderColor: Colors.transparent,
                    textColor: Colors.black,
                    fontSize: 16,
                    placeholderColor: Colors.grey,
                    backgroundColor: Colors.white,
                  ),
                  enablePostalCode: false,
                ),
              ),
              const SizedBox(height: 15),

              // Indicador de validez
              if (_cardDetails != null)
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _cardDetails!.complete 
                        ? GerenaColors.successColor.withOpacity(0.1)
                        : GerenaColors.warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _cardDetails!.complete ? Icons.check_circle : Icons.info_outline,
                        color: _cardDetails!.complete 
                            ? GerenaColors.successColor 
                            : GerenaColors.warningColor,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _cardDetails!.complete 
                              ? '✓ Tarjeta válida'
                              : 'Completa todos los campos',
                          style: GoogleFonts.rubik(
                            fontSize: 12,
                            color: _cardDetails!.complete 
                                ? GerenaColors.successColor 
                                : GerenaColors.warningColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 25),

              // Información de seguridad
              Row(
                children: [
                  Icon(Icons.lock_outline, size: 16, color: Colors.grey),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Tu información está protegida y encriptada',
                      style: GoogleFonts.rubik(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: GerenaColors.createSecondaryButton(
                      text: 'Cancelar',
                      onPressed: () => Navigator.pop(context),
                      isFullWidth: true,
                      height: 45,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Opacity(
                      opacity: (_cardDetails?.complete == true && !_isProcessing) ? 1.0 : 0.5,
                      child: GerenaColors.createPrimaryButton(
                        text: _isProcessing ? 'Procesando...' : 'Agregar',
                        onPressed: (_cardDetails?.complete == true && !_isProcessing)
                            ? _handleAddCard
                            : () {},
                        isFullWidth: true,
                        height: 45,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddCard() async {
    if (_cardDetails?.complete != true) {
      Get.snackbar(
        'Error',
        'Por favor completa todos los datos de la tarjeta',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: GerenaColors.errorColor,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final controller = Get.find<PaymentCartController>();
      
      print('💳 Creando payment method con CardFormField...');
      
      // El CardFormField ya tiene los datos, solo crear el payment method
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              name: _nameController.text.isNotEmpty ? _nameController.text : null,
            ),
          ),
        ),
      );
      
      print('✅ Payment method creado: ${paymentMethod.id}');

      // Adjuntar al customer
      print('🔗 Adjuntando al customer...');
      await controller.attachPaymentMethodToCustomer(paymentMethod.id);
      print('✅ Adjuntado correctamente');

      // Recargar lista
      print('🔄 Recargando lista...');
      await controller.loadPaymentMethods();
      print('✅ Lista actualizada');

      Navigator.pop(context);
      
      Get.snackbar(
        'Éxito',
        'Tarjeta agregada correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: GerenaColors.successColor,
        colorText: Colors.white,
      );
      
    } catch (e) {
      print('❌ Error adding card: $e');
      Get.snackbar(
        'Error',
        'No se pudo agregar la tarjeta. Verifica los datos.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: GerenaColors.errorColor,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }
}