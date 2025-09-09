import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/page/store/blogGerena/blog_controller.dart';
import 'package:provider/provider.dart';

class DialogoAbierto extends StatelessWidget {
  const DialogoAbierto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BlogController>(
      builder: (context, controller, child) {
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
              doctorName: "Dr. Juan González",
              question: controller.selectedQuestionTitle,
              hasAnswer: false,
              showRespondButton: true,
            ),
            const SizedBox(height: GerenaColors.paddingMedium),
            
            ...controller.selectedAnswers.map((answer) => Column(
              children: [
                const SizedBox(height: 10),
                Divider(
                  color: GerenaColors.primaryColor.withOpacity(0.3),
                  thickness: 1,
                ),
                const SizedBox(height: 10),

                _buildAnswerCard(
                  doctorName: answer['doctorName']!,
                  answer: answer['answer']!,
                ),
                const SizedBox(height: GerenaColors.paddingMedium),
              ],
            )).toList(),
          ],
        );
      },
    );
  }

  Widget _buildQuestionCard({
    required BuildContext context,
    required String doctorName,
    required String question,
    required bool hasAnswer,
    bool showRespondButton = false,
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
                    ),
                  ),
                  
                  if (showRespondButton) ...[
                    const SizedBox(height: GerenaColors.paddingMedium),
                    
                    Align(
                      alignment: Alignment.centerRight,
                      child: GerenaColors.createPrimaryButton(
                        text: "RESPONDER",
                        onPressed: () => _showResponseDialog(context),
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

  Widget _buildAnswerCard({
    required String doctorName,
    required String answer,
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
                  Text(
                    doctorName,
                    style: GerenaColors.headingSmall.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
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

  void _showResponseDialog(BuildContext context) async {
    
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          content: SizedBox(
            width: 700,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      maxLines: 4,
                      maxLength: 280,
                      decoration: const InputDecoration(
                        hintText: 'Escribe tu respuesta en 280 caracteres',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          respuesta = value;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            GerenaColors.createPrimaryButton(
              text: "ENVIAR",
              onPressed: () {
               
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Respuesta enviada correctamente'),
                    backgroundColor: GerenaColors.primaryColor,
                  ),
                );
              },
              height: 35,
            ),
          ],
        );
      },
    );
  }
}