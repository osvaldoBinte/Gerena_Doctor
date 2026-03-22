import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/shareProcedureWidget/share_procedure_widget.dart';
import 'package:gerena/common/controller/mediacontroller/media_controller.dart';
import 'package:gerena/features/doctorprocedures/presentation/page/procedure_card_widget.dart';
import 'package:gerena/features/doctorprocedures/presentation/page/procedures_controller.dart';
import 'package:gerena/features/doctors/presentation/widget/loading/share_and_procedures_loading.dart';
import 'package:gerena/features/subscription/presentation/page/subscription_controller.dart';
import 'package:get/get.dart';

class ShareAndProceduresWidget extends StatelessWidget {
  final bool showShareSection;
 final bool showProcedures;
  const ShareAndProceduresWidget({
    Key? key,
    this.showShareSection = true, 
    this.showProcedures = true, // por defecto se muestra la sección de procedimientos --- IGNORE ---
  }) : super(key: key);

   @override
  Widget build(BuildContext context) {
    final MediaController mediaController = Get.put(MediaController());
    final ProceduresController proceduresController = Get.find<ProceduresController>();
    final SubscriptionController subscriptionController = Get.find<SubscriptionController>();

    return Obx(() {
      final subscription = subscriptionController.currentSubscription.value;
      final planId = subscription?.subscriptionplanId;
      final shouldShowPortfolio = planId == 3 || planId == 4;

      // Sin acceso al portafolio
      if (!shouldShowPortfolio) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, color: Colors.grey, size: 40),
                const SizedBox(height: 12),
                const Text(
                  'Para poder agregar procedimientos,\nactualiza tu membresía a Elite o Black',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        );
      }

      // Con acceso
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showShareSection) ...[
            Text('Compartir tus procedimientos', style: GerenaColors.headingSmall),
            ShareProcedureWidget(mediaController: mediaController),
            const SizedBox(height: 16),
          ],
          if (showProcedures)
            _buildProceduresGrid(proceduresController),
        ],
      );
    });
  }


  Widget _buildProceduresGrid(ProceduresController proceduresController) {
    return Obx(() {
      if (proceduresController.isLoading.value) {
        return ShareAndProceduresLoading(
        );
      }

      if (proceduresController.errorMessage.isNotEmpty) {
        return Center(
          child: Column(
            children: [
              Text(
                'Error al cargar procedimientos',
                style: GerenaColors.bodyMedium,
              ),
              const SizedBox(height: 8),
              GerenaColors.widgetButton(
                onPressed: () => proceduresController.loadProcedures(),
                text: 'Reintentar',
                showShadow: false,
                borderRadius: 5,
              ),
            ],
          ),
        );
      }

      if (proceduresController.procedures.isEmpty) {
        return Center(
          child: Text(
            'No hay procedimientos para mostrar',
            style: GerenaColors.bodyMedium,
          ),
        );
      }

      return Column(
        children: [
          for (int i = 0; i < proceduresController.procedures.length; i += 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ProcedureCardWidget(
                      procedure: proceduresController.procedures[i],
                      showActions: true,
                      showAddImageButton: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (i + 1 < proceduresController.procedures.length)
                    Expanded(
                      child: ProcedureCardWidget(
                        procedure: proceduresController.procedures[i + 1],
                        showActions: true,
                        showAddImageButton: true,
                      ),
                    )
                  else
                    const Expanded(child: SizedBox()),
                ],
              ),
            ),
        ],
      );
    });
  }
}