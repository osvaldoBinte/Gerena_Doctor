import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/shareProcedureWidget/share_procedure_widget.dart';
import 'package:gerena/features/doctorprocedures/presentation/page/procedure_card_widget.dart';
import 'package:gerena/features/doctorprocedures/presentation/page/procedures_controller.dart';
import 'package:gerena/features/doctors/presentation/page/prefil_dortor_controller.dart';
import 'package:gerena/features/doctors/presentation/widget/procedure_widget.dart';
import 'package:gerena/features/doctors/presentation/widget/share_and_procedures_widget.dart';
import 'package:gerena/features/home/dashboard/widget/appbar/gerena_app_bar_controller.dart';
import 'package:gerena/common/controller/mediacontroller/media_controller.dart';
import 'package:gerena/features/review/presentation/page/reviews_widget.dart';
import 'package:gerena/features/subscription/presentation/page/subscription_controller.dart';
import 'package:get/get.dart';

class DoctorProfileContent extends StatefulWidget {
  const DoctorProfileContent({Key? key}) : super(key: key);

  @override
  State<DoctorProfileContent> createState() => _DoctorProfileContentState();
}

class _DoctorProfileContentState extends State<DoctorProfileContent> {
  final TextEditingController _reviewController = TextEditingController();
  final appBarController = Get.put(GerenaAppBarController());
  final MediaController mediaController = Get.put(MediaController());
  final ProceduresController proceduresController = Get.find<ProceduresController>();
  final SubscriptionController subscriptionController = Get.find<SubscriptionController>();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GerenaColors.backgroundColorfondo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDoctorInfoCard(),
          const SizedBox(height: 16),
         
          Obx(() {
            final subscription = subscriptionController.currentSubscription.value;
            final planId = subscription?.subscriptionplanId;
            final shouldShowPortfolio = planId == 3 || planId == 4;
            
            if (!shouldShowPortfolio) {
              return SizedBox.shrink();
            }
            
            return Column(
              children: [
                ShareAndProceduresWidget(),
                const SizedBox(height: 16),
              ],
            );
          }),
          
          Text(
            'Reseñas de tus pacientes',
            style: GerenaColors.headingSmall,
          ),
          const SizedBox(height: 16),
          ReviewsWidget(),
        ],
      ),
    );
  }

  Widget _buildDoctorInfoCard() {
    final PrefilDortorController controller = Get.find<PrefilDortorController>();
    
    return Obx(() {
      final doctor = controller.doctorProfile.value;
      
      if (controller.isLoading.value) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: GerenaColors.cardDecoration,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      
      if (doctor == null) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: GerenaColors.cardDecoration,
          child: const Center(
            child: Text('No se pudo cargar la información del doctor'),
          ),
        );
      }
      
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: GerenaColors.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: GerenaColors.backgroundColorfondo,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: doctor.foto != null && doctor.foto!.isNotEmpty
                        ? Image.network(
                            doctor.foto!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: GerenaColors.backgroundColorfondo,
                                child: const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: GerenaColors.primaryColor,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: GerenaColors.backgroundColorfondo,
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: GerenaColors.primaryColor,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              doctor.nombreCompleto ?? '',
                              style: GerenaColors.headingMedium.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              print('Editando perfil');
                              appBarController.navigateToProfile(); 
                            },
                            child: Image.asset(
                              'assets/icons/edit.png',
                              width: 30,
                              height: 30,
                              color: GerenaColors.accentColor,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 6),
                      
                      Text(
                        doctor.especialidad?? '',
                        style: GerenaColors.subtitleMedium.copyWith(
                          color: GerenaColors.colorSubsCardSecondaryText,
                          fontSize: 14,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        doctor.direccion?? '',
                        style: GerenaColors.bodySmall.copyWith(
                          fontSize: 12,
                          color: Colors.grey[700],
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        'Cédula: ${doctor.numeroLicencia}',
                        style: GerenaColors.bodySmall.copyWith(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  Widget _buildBeforeAfterSection() {
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