import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/doctorprocedures/presentation/page/procedure_card_widget.dart';
import 'package:gerena/features/doctors/presentation/page/doctorProfilePage/doctor_profilebyid_controller.dart';
import 'package:gerena/features/doctors/presentation/widget/loading/share_and_procedures_loading.dart';
import 'package:get/get.dart';

class ProceduresDoctorbyidWidget extends StatelessWidget {

  const ProceduresDoctorbyidWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DoctorProfilebyidController proceduresController = Get.find<DoctorProfilebyidController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      
        
        _buildProceduresGrid(proceduresController),
      ],
    );
  }

  Widget _buildProceduresGrid(DoctorProfilebyidController proceduresController) {
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
                      showActions: false,
                      showAddImageButton: false,
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (i + 1 < proceduresController.procedures.length)
                    Expanded(
                      child: ProcedureCardWidget(
                        procedure: proceduresController.procedures[i + 1],
                        showActions: false,
                        showAddImageButton: false,
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