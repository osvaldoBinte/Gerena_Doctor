import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/home/dashboard/widget/appbar/gerena_app_bar_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationModal extends StatelessWidget {
  const NotificationModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final appBarHeight = 60.0;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final totalTopOffset = appBarHeight + statusBarHeight;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      alignment: Alignment.topRight,
      child: Container(
        width: 400,
        height: screenSize.height - totalTopOffset,
        margin: EdgeInsets.only(top: totalTopOffset),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
          ),
          boxShadow: [GerenaColors.mediumShadow],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
            
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Limpiar bandeja',
                    style: GoogleFonts.rubik(
                      fontSize: 14,
                      color: GerenaColors.accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Image.asset('assets/icons/close.png'),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildNotificationItem(
                      icon: 'assets/icons/warning.png',
                      title: 'RECORDATORIO',
                      description:
                          'Domicilia tu pago antes del 05/05/2024 para evitar la suspensión de tus servicios.',
                    ),
                    const SizedBox(height: 16),
                    _buildNotificationItem(
                      icon: 'assets/icons/campaign.png',
                      title: 'ALERTA WEBINAR',
                      description:
                          '"Aplicaciones clínicas de la toxina botulínica en la medicina estética"',
                      subtitle: 'Miembros Elite y Black',
                      date: '25 de Abril 2025',
                      imagePath: 'assets/Webinar.png',
                    ),
                    const SizedBox(height: 16),
                    _buildNotificationItem(
                      icon: 'assets/icons/campaign.png',
                      title: 'PROMOCIONES FLASH',
                      description:
                          'Del 25 de Abril al 28 accede a precios únicos de la APP',
                      actionText: 'Haz clic aquí',
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String icon,
    required String title,
    required String description,
    String? subtitle,
    String? date,
    String? imagePath,
    String? actionText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColorFondo,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  icon,
                  width: 30,
                  height: 30,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
  child: Padding(
    padding: const EdgeInsets.all(16.0), 
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.rubik(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: GerenaColors.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: GoogleFonts.rubik(
            fontSize: 12,
            color: GerenaColors.textPrimaryColor,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.rubik(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
        if (date != null) ...[
          const SizedBox(height: 4),
          Text(
            date,
            style: GoogleFonts.rubik(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: GerenaColors.textPrimaryColor,
            ),
          ),
        ],
        if (imagePath != null) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: GerenaColors.smallBorderRadius,
            child: Image.asset(
              imagePath,
             
              fit: BoxFit.fill,
             
            ),
          ),
        ],
        if (actionText != null) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              print('Acción: $actionText');
            },
            child: Text(
              actionText,
              style: GoogleFonts.rubik(
                fontSize: 12,
                color: GerenaColors.accentColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ],
    ),
  ),
),

            ],
          ),
        ],
      ),
    );
  }
}

class NotificationHelper {
  static void showNotificationModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const NotificationModal();
      },
    );
  }
}

extension GerenaAppBarControllerExtension on GerenaAppBarController {
  void showNotificationModal() {
    if (Get.context != null) {
      NotificationHelper.showNotificationModal(Get.context!);
    }
  }
}
