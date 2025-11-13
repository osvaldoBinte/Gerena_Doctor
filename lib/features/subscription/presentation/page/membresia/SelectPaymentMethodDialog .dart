import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/presentation/page/paymentcard/payment_cart_controller.dart';
import 'package:gerena/features/subscription/domain/entities/view_all_plans_entity.dart';
import 'package:gerena/features/subscription/presentation/page/subscription_controller.dart';
import 'package:get/get.dart';

class SelectPaymentMethodDialog extends StatelessWidget {
  final ViewAllPlansEntity plan;

  const SelectPaymentMethodDialog({
    Key? key,
    required this.plan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paymentController = Get.find<PaymentCartController>();
    final subscriptionController = Get.find<SubscriptionController>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirmar suscripción',
                        style: GerenaColors.headingMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${plan.name} - \$${plan.price.toStringAsFixed(2)} MXN/${plan.interval}',
                        style: GerenaColors.bodyMedium.copyWith(
                          color: GerenaColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Título de selección
            Text(
              'Selecciona un método de pago',
              style: GerenaColors.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Lista de tarjetas
            Expanded(
              child: Obx(() {
                if (paymentController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (paymentController.paymentMethods.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.credit_card_off,
                          size: 48,
                          color: GerenaColors.textSecondaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tienes tarjetas guardadas',
                          style: GerenaColors.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            // Navegar a la pantalla de agregar tarjeta
                            Navigator.pop(context);
                            // Get.toNamed('/add-payment-method');
                          },
                          child: Text('Agregar tarjeta'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: paymentController.paymentMethods.length,
                  itemBuilder: (context, index) {
                    final paymentMethod = paymentController.paymentMethods[index];
                    final isSelected = subscriptionController.selectedPaymentMethodId.value == paymentMethod.id;

                    return Obx(() => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected 
                              ? GerenaColors.primaryColor 
                              : GerenaColors.primaryColor,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected 
                            ? GerenaColors.primaryColor.withOpacity(0.05)
                            : Colors.transparent,
                      ),
                      child: ListTile(
                        leading: Icon(
                          _getCardIcon(paymentMethod.brand),
                          color: isSelected 
                              ? GerenaColors.primaryColor 
                              : GerenaColors.textSecondaryColor,
                        ),
                        title: Text(
                          paymentController.formatCardNumber(
                            paymentMethod.last4,
                            paymentMethod.brand,
                          ),
                          style: GerenaColors.bodyMedium.copyWith(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          '${paymentMethod.expMonth.toString().padLeft(2, '0')}/${paymentMethod.expYear}',
                          style: GerenaColors.bodySmall,
                        ),
                        trailing: Radio<String>(
                          value: paymentMethod.id,
                          groupValue: subscriptionController.selectedPaymentMethodId.value,
                          onChanged: (value) {
                            subscriptionController.selectedPaymentMethodId.value = value ?? '';
                          },
                          activeColor: GerenaColors.primaryColor,
                        ),
                        onTap: () {
                          subscriptionController.selectedPaymentMethodId.value = paymentMethod.id;
                        },
                      ),
                    ));
                  },
                );
              }),
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: GerenaColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: GerenaColors.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Obx(() => ElevatedButton(
                    onPressed: subscriptionController.isLoading.value
                        ? null
                        : () async {
                            if (subscriptionController.selectedPaymentMethodId.value.isEmpty) {
                              Get.snackbar(
                                'Error',
                                'Por favor selecciona un método de pago',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            await subscriptionController.subscribeToPlan(plan.id);
                            
                            if (!subscriptionController.isLoading.value) {
                              Navigator.pop(context);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GerenaColors.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: subscriptionController.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Confirmar suscripción',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCardIcon(String brand) {
    switch (brand.toLowerCase()) {
      case 'visa':
        return Icons.credit_card;
      case 'mastercard':
        return Icons.credit_card;
      case 'amex':
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }
}