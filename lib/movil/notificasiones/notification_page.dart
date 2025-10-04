import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: GerenaColors.backgroundColorFondo,
          elevation: 4,
          shadowColor: GerenaColors.shadowColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
           Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'NOTIFICACIONES',
                style: GoogleFonts.rubik(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: GerenaColors.textTertiaryColor,
                ),
              ),
            ),
            const SizedBox(height: GerenaColors.paddingLarge),

            _buildNotificationItem(
              icon: 'assets/icons/phone.png',
              title: 'SOLICITUD DE VIDEOLLAMADA',
              description: 'Adrianna Arellanos',
              actionText: 'Haz clic aquí',
              notificationDate: '11/04/2025', 
            ),
            const SizedBox(height: 16),
            _buildNotificationItem(
              icon: 'assets/icons/warning.png',
              title: 'RECORDATORIO',
              description: 'Domicilia tu pago antes del 05/05/2024 para evitar la suspensión de tus servicios.',
              notificationDate: '11/04/2025', 
            ),
            const SizedBox(height: 16),
            _buildNotificationItem(
              icon: 'assets/icons/campaigndart.png',
              title: 'ALERTA WEBINAR',
              description: '"Aplicaciones clínicas de la toxina botulínica en la medicina estética"',
              subtitle: 'Miembros Elite y Black',
              date: '25 de Abril 2025',
              imagePath: 'assets/Webinar.png',
              notificationDate: '11/04/2025', 
            ),
            const SizedBox(height: 16),
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
    String? notificationDate,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          GerenaColors.mediumShadow,
        ]
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
                     Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3, 
                              child: Text(
                                title,
                                style: GoogleFonts.rubik(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: GerenaColors.textTertiaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (notificationDate != null)
                              Expanded(
                                flex: 1,
                                child: Text(
                                  notificationDate,
                                  style: GoogleFonts.rubik(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    color: GerenaColors.textTertiary,
                                  ),
                                  textAlign: TextAlign.end, 
                                ),
                              ),
                          ],
                        ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.rubik(
                          fontSize: 12,
                          color: GerenaColors.textTertiaryColor,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: GoogleFonts.rubik(
                            fontSize: 11,
                            color: GerenaColors.textTertiaryColor,
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
                            color: GerenaColors.textTertiaryColor,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  print('Acción: $actionText');
                                },
                                child: GerenaColors.widgetButton(
                                  text: 'Cancelar',
                                  showShadow: false,
                                   fontSize:10,
                                  borderRadius: 40
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  print('Botón 2 presionado');
                                },
                                child: GerenaColors.widgetButton(
                                  text: 'chat',
                                  showShadow: false,
                                  borderRadius: 40,
                                  fontSize:10
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  print('Botón 3 presionado');
                                },
                                child: GerenaColors.widgetButton(
                                  text: 'Aceptar',
                                  backgroundColor: GerenaColors.backgroundlogin,
                                  showShadow: false,
                                   fontSize:10,
                                  borderRadius: 40
                                ),
                              ),
                            ),
                          ],
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