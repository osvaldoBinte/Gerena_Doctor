import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/subscription/domain/entities/view_all_plans_entity.dart';
import 'package:gerena/features/subscription/presentation/page/subscription_controller.dart';
import 'package:get/get.dart';

class ChangePlanDialog extends StatelessWidget {
  final ViewAllPlansEntity newPlan;

  const ChangePlanDialog({
    Key? key,
    required this.newPlan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionController>();
    final currentSub = controller.currentSubscription.value;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
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
                  child: Text(
                    'Cambiar plan de suscripción',
                    style: GerenaColors.headingMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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

            // Información del cambio
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: GerenaColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: GerenaColors.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Resumen del cambio',
                        style: GerenaColors.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Plan actual:', currentSub?.planname ?? 'N/A'),
                  _buildInfoRow(
                    'Precio actual:',
                    '\$${currentSub?.planprice.toStringAsFixed(2) ?? '0.00'} MXN',
                  ),
                  const Divider(height: 24),
                  _buildInfoRow('Nuevo plan:', newPlan.name),
                  _buildInfoRow(
                    'Nuevo precio:',
                    '\$${newPlan.price.toStringAsFixed(2)} MXN',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Opciones de cambio
            Text(
              '¿Cuándo deseas aplicar el cambio?',
              style: GerenaColors.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            _buildChangeOption(
              context: context,
              title: 'Al final del período actual',
              description: 'El cambio se aplicará el ${_formatDate(currentSub?.currentPeriodEnddate ?? '')}',
              icon: Icons.schedule,
              onTap: () async {
                Navigator.pop(context);
                await controller.changeSubscriptionPlan(newPlan.id, false);
              },
            ),

            const SizedBox(height: 12),

            _buildChangeOption(
              context: context,
              title: 'Inmediatamente',
              description: 'El cambio se aplicará ahora y se ajustará el cobro',
              icon: Icons.flash_on,
              onTap: () async {
                Navigator.pop(context);
                await controller.changeSubscriptionPlan(newPlan.id, true);
              },
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Botón cancelar
            SizedBox(
              width: double.infinity,
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
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GerenaColors.bodySmall),
          Text(
            value,
            style: GerenaColors.bodySmall.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeOption({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: GerenaColors.primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: GerenaColors.primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GerenaColors.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GerenaColors.bodySmall.copyWith(
                      color: GerenaColors.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: GerenaColors.textSecondaryColor),
          ],
        ),
      ),
    );
  }

  String _formatDate(String date) {
    if (date.isEmpty) return 'N/A';
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    } catch (e) {
      return date;
    }
  }
}