import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/appointment/presentation/page/addappointment/appointment_controller.dart';
import 'package:get/get.dart';

class ModalCompletarCita {
  static void show(int appointmentId) {
    final TextEditingController notasController = TextEditingController();
    final TextEditingController diagnosticoController = TextEditingController();
    final controller = Get.find<AppointmentController>();
    
    controller.resetCompleteValidations();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: GerenaColors.mediumBorderRadius,
        ),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: GerenaColors.mediumBorderRadius,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Completar Cita',
                      style: GerenaColors.headingMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        controller.resetCompleteValidations();
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
                    color: GerenaColors.successColor.withOpacity(0.1),
                    borderRadius: GerenaColors.smallBorderRadius,
                    border: Border.all(
                      color: GerenaColors.successColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: GerenaColors.successColor,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Complete la información del paciente para finalizar la cita.',
                          style: GerenaColors.bodySmall.copyWith(
                            color: GerenaColors.successColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Obx(() => GerenaColors.buildLabeledTextField(
                  'Notas del Doctor *',
                  '',
                  controller: notasController,
                  hintText: 'Ingrese las notas de la consulta...',
                  maxLines: 4,
                  showError: controller.showNotasError.value,
                  errorText: controller.notasError.value,
                  onChanged: (value) => controller.validateNotas(value),
                )),
                
                const SizedBox(height: 20),

                Obx(() => GerenaColors.buildLabeledTextField(
                  'Diagnóstico *',
                  '',
                  controller: diagnosticoController,
                  hintText: 'Ingrese el diagnóstico del paciente...',
                  maxLines: 4,
                  showError: controller.showDiagnosticoError.value,
                  errorText: controller.diagnosticoError.value,
                  onChanged: (value) => controller.validateDiagnostico(value),
                )),
                
                const SizedBox(height: 24),

                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GerenaColors.createSecondaryButton(
                          text: 'Cancelar',
                          onPressed: controller.isCompletingAppointment.value
                              ? () {}
                              : () {
                                  controller.resetCompleteValidations();
                                  Get.back();
                                },
                        ),
                        const SizedBox(width: 12),
                        GerenaColors.widgetButton(
                          text: 'COMPLETAR CITA',
                          backgroundColor: GerenaColors.successColor,
                          isLoading: controller.isCompletingAppointment.value,
                          onPressed: () {
                            controller.completeAppointment(
                              appointmentId,
                              notasController.text.trim(),
                              diagnosticoController.text.trim(),
                            );
                          },
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}