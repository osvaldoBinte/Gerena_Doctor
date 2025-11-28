import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/blog/domain/entities/blog_social_entity.dart';
import 'package:gerena/features/blog/presentation/page/blogGerena/blog_controller.dart';
import 'package:get/get.dart';

class DialogoAbierto extends StatelessWidget {
  const DialogoAbierto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BlogController>();
    
    return Obx(() {
      if (controller.isLoadingDetail.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      final selectedArticle = controller.selectedSocialArticle.value;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Diálogo Abierto',
            style: GerenaColors.headingLarge.copyWith(
              color: GerenaColors.primaryColor,
            ),
          ),
          
          const SizedBox(height: 16),
          
          _buildQuestionCard(
            context: context,
            doctorName: "Dr. Usuario",
            question: selectedArticle?.titulo ?? controller.selectedQuestionTitle.value,
            description: selectedArticle?.descripcion ?? '',
            hasAnswer: (selectedArticle?.respuestas?.isNotEmpty ?? false) || 
                       controller.selectedAnswers.isNotEmpty,
            showRespondButton: true,
            questionId: selectedArticle?.id,
          ),
          
          const SizedBox(height: GerenaColors.paddingMedium),
          
          if (selectedArticle?.respuestas != null && selectedArticle!.respuestas!.isNotEmpty)
            ...selectedArticle.respuestas!.map((respuesta) => Column(
              children: [
                const SizedBox(height: 10),
                Divider(
                  color: GerenaColors.primaryColor.withOpacity(0.3),
                  thickness: 1,
                ),
                const SizedBox(height: 10),
                _buildAnswerCardFromEntity(respuesta),
                const SizedBox(height: GerenaColors.paddingMedium),
              ],
            )).toList()
          else if (controller.selectedAnswers.isNotEmpty)
            ...controller.selectedAnswers.map((answer) => Column(
              children: [
                const SizedBox(height: 10),
                Divider(
                  color: GerenaColors.primaryColor.withOpacity(0.3),
                  thickness: 1,
                ),
                const SizedBox(height: 10),
                _buildAnswerCard(
                  doctorName: answer.contenido!,
                  answer: answer.contenido!,
                  date:  answer.contenido!,
                ),
                const SizedBox(height: GerenaColors.paddingMedium),
              ],
            )).toList(),
        ],
      );
    });
  }

  Widget _buildQuestionCard({
    required BuildContext context,
    required String doctorName,
    required String question,
    String? description,
    required bool hasAnswer,
    bool showRespondButton = false,
    int? questionId,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: GerenaColors.cardColor,
        borderRadius: GerenaColors.mediumBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.all(GerenaColors.paddingMedium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: GerenaColors.smallBorderRadius,
                image: const DecorationImage(
                  image: AssetImage('assets/perfil.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            const SizedBox(width: GerenaColors.paddingMedium),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorName,
                    style: GerenaColors.headingSmall.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    question,
                    style: GerenaColors.bodyMedium.copyWith(
                      color: GerenaColors.textSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  if (description != null && description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: GerenaColors.bodyMedium.copyWith(
                        color: GerenaColors.textSecondaryColor,
                      ),
                    ),
                  ],
                  
                  if (showRespondButton) ...[
                    const SizedBox(height: GerenaColors.paddingMedium),
                    
                    Align(
                      alignment: Alignment.centerRight,
                      child: GerenaColors.createPrimaryButton(
                        text: "RESPONDER",
                        onPressed: () => _showResponseDialog(context, questionId),
                        height: 35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerCardFromEntity(RespuestaEntity respuesta) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(GerenaColors.paddingMedium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: GerenaColors.smallBorderRadius,
                image: const DecorationImage(
                  image: AssetImage('assets/perfil.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            const SizedBox(width: GerenaColors.paddingMedium),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        respuesta.usuarioNombre??'', 
                        style: GerenaColors.headingSmall.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (respuesta.actualizadoEn != null)
                        Text(
                          _formatDate(respuesta.actualizadoEn!),
                          style: GerenaColors.bodySmall.copyWith(
                            color: GerenaColors.textSecondaryColor,
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    respuesta.contenido ?? '',
                    style: GerenaColors.bodyMedium.copyWith(
                      color: GerenaColors.textPrimaryColor,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerCard({
    required String doctorName,
    required String answer,
    String? date,
  }) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(GerenaColors.paddingMedium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: GerenaColors.smallBorderRadius,
                image: const DecorationImage(
                  image: AssetImage('assets/perfil.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            const SizedBox(width: GerenaColors.paddingMedium),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        doctorName,
                        style: GerenaColors.headingSmall.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (date != null)
                        Text(
                          date,
                          style: GerenaColors.bodySmall.copyWith(
                            color: GerenaColors.textSecondaryColor,
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    answer,
                    style: GerenaColors.bodyMedium.copyWith(
                      color: GerenaColors.textPrimaryColor,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

String _formatDate(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  } catch (e) {
    return dateString;
  }
}
  void _showResponseDialog(BuildContext context, int? questionId) async {
  final controller = Get.find<BlogController>();
  final responseController = TextEditingController();
  
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          'Responder Pregunta',
          style: GerenaColors.headingMedium,
        ),
        content: SizedBox(
          width: 700,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: responseController,
                    maxLines: 4,
                    maxLength: 280,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu respuesta en 280 caracteres',
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${responseController.text.length}/280',
                      style: GerenaColors.bodySmall.copyWith(
                        color: GerenaColors.textSecondaryColor,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'CANCELAR',
              style: TextStyle(color: GerenaColors.textSecondaryColor),
            ),
          ),
          Obx(() => controller.isLoadingDetail.value
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )
              : GerenaColors.createPrimaryButton(
                  text: "ENVIAR",
                  onPressed: () async {
                    if (responseController.text.trim().isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Por favor escribe una respuesta',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    if (questionId == null) {
                      Get.snackbar(
                        'Error',
                        'No se pudo identificar la pregunta',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    try {
                      await controller.sendAnswer(
                        questionId: questionId,
                        answer: responseController.text.trim(),
                      );
                      
                      Navigator.of(context).pop();
                    } catch (e) {
                    }
                  },
                  height: 35,
                ),
          ),
        ],
      );
    },
  );
}
}