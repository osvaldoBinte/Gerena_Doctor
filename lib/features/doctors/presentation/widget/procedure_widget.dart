import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/doctorprocedures/presentation/page/procedure_card_widget.dart';
import 'package:gerena/features/doctorprocedures/presentation/page/procedures_controller.dart';
import 'package:get/get.dart';

class ProcedureWidget extends StatelessWidget {
  const ProcedureWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProceduresController proceduresController = Get.find<ProceduresController>();

    return Obx(() {
      if (proceduresController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
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