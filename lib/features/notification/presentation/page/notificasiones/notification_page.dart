import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/notification/domain/entities/notification_entity.dart';
import 'package:gerena/features/notification/presentation/page/notification_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

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
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.error.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.notifications_none,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'No tienes notificaciones',
                          style: GoogleFonts.rubik(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.notifications_none,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'No tienes notificaciones',
                          style: GoogleFonts.rubik(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchNotifications(),
                  child: ListView.separated(
                    itemCount: controller.notifications.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final notification = controller.notifications[index];
                      return _buildNotificationItem(
                        notification: notification,
                        controller: controller,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required NotificationEntity notification,
    required NotificationController controller,
  }) {
    // Determinar icono según el tipo
    String iconPath;
    switch (notification.type.toLowerCase()) {
      case 'solicitudvideollamada':
        iconPath = 'assets/icons/phone.png';
        break;
      case 'recordatorio':
        iconPath = 'assets/icons/warning.png';
        break;
      case 'alertawebinar':
        iconPath = 'assets/icons/campaigndart.png';
        break;
      case 'promocionflash':
        iconPath = 'assets/icons/campaigndart.png';
        break;
      default:
        iconPath = 'assets/icons/warning.png';
    }

    // Determinar si tiene botones de acción (para videollamadas)
    bool hasActionButtons =
        notification.type.toLowerCase() == 'solicitudvideollamada';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          GerenaColors.mediumShadow,
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  iconPath,
                  width: 30,
                  height: 30,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.notifications,
                      size: 30,
                      color: Colors.grey,
                    );
                  },
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
                              notification.type.toUpperCase(),
                              style: GoogleFonts.rubik(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: GerenaColors.textTertiaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (notification.createdAt != null)
                            Expanded(
                              flex: 1,
                              child: Text(
                                _formatDateShort(notification.createdAt!),
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
                        notification.message,
                        style: GoogleFonts.rubik(
                          fontSize: 12,
                          color: GerenaColors.textTertiaryColor,
                        ),
                      ),
                      // Mostrar metadata si existe
                      if (notification.metadata.containsKey('Tema')) ...[
                        const SizedBox(height: 4),
                        Text(
                          notification.metadata['Tema'] ?? '',
                          style: GoogleFonts.rubik(
                            fontSize: 11,
                            color: GerenaColors.textTertiaryColor,
                          ),
                        ),
                      ],
                      // Mostrar fecha del evento si existe
                      if (notification.metadata.containsKey('FechaEvento')) ...[
                        const SizedBox(height: 4),
                        Text(
                          _formatDateLong(
                              notification.metadata['FechaEvento']),
                          style: GoogleFonts.rubik(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: GerenaColors.textTertiaryColor,
                          ),
                        ),
                      ],
                      // Imagen si existe
                      if (notification.imageUrl != null &&
                          notification.imageUrl!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: GerenaColors.smallBorderRadius,
                          child: Image.network(
                            notification.imageUrl!,
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 100,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.image_not_supported),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      if (hasActionButtons) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  print('Cancelar videollamada');
                                },
                                child: GerenaColors.widgetButton(
                                  text: 'Cancelar',
                                  showShadow: false,
                                  fontSize: 10,
                                  borderRadius: 40,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  print('Abrir chat');
                                },
                                child: GerenaColors.widgetButton(
                                  text: 'Chat',
                                  showShadow: false,
                                  borderRadius: 40,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  print('Aceptar videollamada');
                                  controller.markAsRead(
                                      notification.notificationId);
                                },
                                child: GerenaColors.widgetButton(
                                  text: 'Aceptar',
                                  backgroundColor:
                                      GerenaColors.backgroundlogin,
                                  showShadow: false,
                                  fontSize: 10,
                                  borderRadius: 40,
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

  String _formatDateShort(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _formatDateLong(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'Enero',
        'Febrero',
        'Marzo',
        'Abril',
        'Mayo',
        'Junio',
        'Julio',
        'Agosto',
        'Septiembre',
        'Octubre',
        'Noviembre',
        'Diciembre'
      ];
      return '${date.day} de ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}