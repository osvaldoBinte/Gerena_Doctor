import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/appointment/presentation/page/addappointment/appointment_controller.dart';
import 'package:get/get.dart';

class ModalCancelarCita {
  static void show(int appointmentId) {
    final TextEditingController motivoController = TextEditingController();
    final controller = Get.find<AppointmentController>();
    
    controller.resetCancelValidations();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: GerenaColors.mediumBorderRadius,
        ),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: GerenaColors.mediumBorderRadius,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cancelar Cita',
                    style: GerenaColors.headingMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      controller.resetCancelValidations();
                      Get.back();
                    },
                    color: GerenaColors.textSecondaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: GerenaColors.warningColor.withOpacity(0.1),
                  borderRadius: GerenaColors.smallBorderRadius,
                  border: Border.all(
                    color: GerenaColors.warningColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: GerenaColors.warningColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Esta acción no se puede deshacer. La cita será cancelada permanentemente.',
                        style: GerenaColors.bodySmall.copyWith(
                          color: GerenaColors.warningColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Obx(() => GerenaColors.buildLabeledTextField(
                'Motivo de cancelación *',
                '',
                controller: motivoController,
                hintText: 'Ingrese el motivo de la cancelación...',
                maxLines: 4,
                showError: controller.showMotivoError.value,
                errorText: controller.motivoError.value,
                onChanged: (value) => controller.validateMotivo(value),
              )),
              
              const SizedBox(height: 24),

              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GerenaColors.createSecondaryButton(
                        text: 'Volver',
                        onPressed: controller.isCancelingAppointment.value
                            ? () {}
                            : () {
                                controller.resetCancelValidations();
                                Get.back();
                              },
                      ),
                      const SizedBox(width: 12),
                      GerenaColors.widgetButton(
                        text: 'CANCELAR CITA',
                        backgroundColor: GerenaColors.errorColor,
                        isLoading: controller.isCancelingAppointment.value,
                        onPressed: () {
                          controller.cancelAppointment(
                            appointmentId,
                            motivoController.text.trim(),
                          );
                        },
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}