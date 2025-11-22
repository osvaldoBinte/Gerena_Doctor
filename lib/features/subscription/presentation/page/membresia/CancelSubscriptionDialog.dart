import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/subscription/presentation/page/subscription_controller.dart';
import 'package:get/get.dart';

class CancelSubscriptionDialog extends StatefulWidget {
  const CancelSubscriptionDialog({Key? key}) : super(key: key);

  @override
  State<CancelSubscriptionDialog> createState() => _CancelSubscriptionDialogState();
}

class _CancelSubscriptionDialogState extends State<CancelSubscriptionDialog> {
  final reasonController = TextEditingController();
  bool cancelImmediately = false;

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionController>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Obx(() {
          // 👇 Mostrar loading mientras se cancela
          if (controller.isCancelling.value) {
            return Container(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: GerenaColors.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Procesando cancelación...',
                      style: GerenaColors.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Cancelar suscripción',
                      style: GerenaColors.headingMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
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

              // Advertencia
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Esta acción cancelará tu suscripción y perderás los beneficios del plan.',
                        style: GerenaColors.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Motivo de cancelación
              Text(
                '¿Por qué deseas cancelar?',
                style: GerenaColors.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                maxLines: 4,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: 'Cuéntanos el motivo de tu cancelación...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: GerenaColors.primaryColor),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Opción de cancelación inmediata
              CheckboxListTile(
                value: cancelImmediately,
                onChanged: (value) {
                  setState(() {
                    cancelImmediately = value ?? false;
                  });
                },
                title: Text(
                  'Cancelar inmediatamente',
                  style: GerenaColors.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  cancelImmediately
                      ? 'Tu suscripción se cancelará ahora y perderás el acceso de inmediato'
                      : 'Tu suscripción se mantendrá hasta el final del período actual',
                  style: GerenaColors.bodySmall.copyWith(
                    color: cancelImmediately ? Colors.red : GerenaColors.textSecondaryColor,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: GerenaColors.primaryColor,
                contentPadding: EdgeInsets.zero,
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
                        'Mantener suscripción',
                        style: TextStyle(color: GerenaColors.primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final reason = reasonController.text.trim();
                        
                        if (reason.isEmpty) {
                          Get.snackbar(
                            'Campo requerido',
                            'Por favor indica el motivo de la cancelación',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.orange,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        // Cerrar diálogo
                        Navigator.pop(context);
                        
                        // Ejecutar cancelación
                        await controller.cancelSubscription(cancelImmediately, reason);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Cancelar suscripción',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}