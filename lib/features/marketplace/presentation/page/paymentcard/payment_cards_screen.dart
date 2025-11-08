import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/domain/entities/payment/payment_method_entity.dart';
import 'package:gerena/features/marketplace/presentation/page/paymentcard/add_card_modal.dart';
import 'package:gerena/features/marketplace/presentation/page/paymentcard/payment_cart_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class PaymentCardsScreen extends StatelessWidget {
  const PaymentCardsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaymentCartController>();
    
    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorFondo,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: GerenaColors.secondaryColor,
                    ),
                  );
                }
                
                return ListView(
                  children: [
                    Container(
                      color: GerenaColors.backgroundColor,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            color: GerenaColors.dividerColor,
                            thickness: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'BILLETERA',
                                style: GoogleFonts.rubik(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: GerenaColors.textTertiaryColor,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => controller.loadPaymentMethods(),
                                icon: Icon(Icons.refresh, size: 18),
                                label: Text('Actualizar'),
                                style: TextButton.styleFrom(
                                  foregroundColor: GerenaColors.secondaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Lista de tarjetas
                          if (controller.paymentMethods.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Text(
                                  'No tienes tarjetas guardadas',
                                  style: GoogleFonts.rubik(
                                    color: GerenaColors.textSecondaryColor,
                                  ),
                                ),
                              ),
                            )
                          else
                            ...controller.paymentMethods.map((pm) {
                              return Column(
                                children: [
                                  _buildPaymentCard(
                                    cardNumber: controller.formatCardNumber(
                                      pm.last4,
                                      pm.brand,
                                    ),
                                    brand: pm.brand,
                                    expiry: '${pm.expMonth}/${pm.expYear}',
                                    onEdit: () => _showEditOptions(context, controller, pm),
                                  ),
                                  Divider(
                                    color: GerenaColors.dividerColor,
                                    thickness: 2,
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              );
                            }).toList(),
                          
                          _buildAddCardButton(context, controller),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard({
    required String cardNumber,
    required String brand,
    required String expiry,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/payment_card.png',
            width: 100,
            height: 100,
            fit: BoxFit.contain,
            color: GerenaColors.secondaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brand.toUpperCase(),
                  style: GerenaColors.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: GerenaColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cardNumber,
                  style: GerenaColors.bodySmall.copyWith(
                    color: GerenaColors.textTertiaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Expira: $expiry',
                  style: GerenaColors.bodySmall.copyWith(
                    color: GerenaColors.textSecondaryColor,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                'assets/icons/edit.png',
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCardButton(BuildContext context, PaymentCartController controller) {
    return GestureDetector(
      onTap: () {
      // Donde llamas al modal, cambia de showModalBottomSheet a showDialog:
showDialog(
  context: context,
  builder: (context) => Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 500, // Ancho máximo para escritorio
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: AddCardModal(),
    ),
  ),
);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: GerenaColors.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: GerenaColors.textSecondaryColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Text(
            '+Agregar tarjeta',
            style: GerenaColors.bodyMedium.copyWith(
              color: GerenaColors.textTertiaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
  
  void _showEditOptions(
    BuildContext context,
    PaymentCartController controller,
    PaymentMethodEntity pm,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.delete, color: GerenaColors.errorColor),
              title: Text('Eliminar tarjeta'),
              onTap: () {
                Navigator.pop(context);
                Get.dialog(
                  AlertDialog(
                    title: Text('Confirmar'),
                    content: Text('¿Deseas eliminar esta tarjeta?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.deletePaymentMethod(pm.id);
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GerenaColors.errorColor,
                        ),
                        child: Text('Eliminar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}