import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:gerena/common/theme/App_Theme.dart';

class GerenaModalBot extends StatelessWidget {
  const GerenaModalBot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.bottomLeft,
      insetPadding: const EdgeInsets.only(left: 16, bottom: 0),
      child: Container(
        width: 330,
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: GerenaColors.backgroundColor,
          borderRadius: GerenaColors.mediumBorderRadius,
          boxShadow: [GerenaColors.mediumShadow],
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: Image.asset(
                              'assets/icons/close.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildOptionItem(
                      context,
                      title: '👋 ¡Hola, Pedro! ¿En qué área necesitas ayuda hoy?',
                      bubbleNip: BubbleNip.leftBottom,
                      onTap: () {},
                    ),
                    _buildOptionItem(
                      context,
                      title: 'Comprar productos',
                      bubbleNip: BubbleNip.no,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    _buildOptionItem(
                      context,
                      title: 'Conocer promociones',
                      bubbleNip: BubbleNip.no,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    _buildOptionItem(
                      context,
                      title: 'Soporte técnico',
                      bubbleNip: BubbleNip.no,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    _buildOptionItem(
                      context,
                      title: 'Otra opción',
                      bubbleNip: BubbleNip.no,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildOptionItem(
                      context,
                      title: 'Gestionar agenda de pacientes',
                      backgroundColor: GerenaColors.textchatAnswer,
                      textColor: GerenaColors.textchat,
                      isRightAligned: true,
                      bubbleNip: BubbleNip.rightBottom,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Bubble(
                      margin: const BubbleEdges.only(top: 2),
                      alignment: Alignment.topLeft,
                      nip: BubbleNip.leftBottom,
                      color: GerenaColors.textchatDefault,
                      padding: const BubbleEdges.all(4),
                      child: SizedBox(
                        width: double.infinity,
                        child: const Text(
                          '...',
                          style: TextStyle(
                            color: GerenaColors.textchat,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: GerenaColors.backgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/headset_mic.png',
                    width: 20,
                    height: 20,
                    color: GerenaColors.primaryColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                      decoration: BoxDecoration(
                        color: GerenaColors.primaryColor,
                        borderRadius: GerenaColors.smallBorderRadius,
                      ),
                      child: const SizedBox(height: 20),
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

  Widget _buildOptionItem(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
    Color? backgroundColor,
    Color? textColor,
    bool isRightAligned = false,
    BubbleNip? bubbleNip,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isRightAligned
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Bubble(
              margin: const BubbleEdges.only(top: 2),
              alignment: isRightAligned ? Alignment.topRight : Alignment.topLeft,
              nip: bubbleNip ?? (isRightAligned ? BubbleNip.rightTop : BubbleNip.leftTop),
              color: backgroundColor ?? GerenaColors.textchatDefault,
              padding: const BubbleEdges.all(4),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isRightAligned ? 250 : 200,
                ),
                child: Text(
                  title,
                  style: GerenaColors.bodyMedium.copyWith(
                    color: textColor ?? GerenaColors.textchat,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
