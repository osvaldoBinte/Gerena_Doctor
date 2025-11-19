import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/notification/domain/entities/notification_entity.dart';
import 'package:gerena/features/notification/presentation/page/notification_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationModal extends StatelessWidget {
  const NotificationModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();
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
                  GestureDetector(
                    onTap: () => controller.clearAllNotifications(),
                    child: Text(
                      'Limpiar bandeja',
                      style: GoogleFonts.rubik(
                        fontSize: 14,
                        color: GerenaColors.accentColor,
                        fontWeight: FontWeight.w500,
                      ),
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

                // Mostrar lista vacía
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

                // Mostrar lista de notificaciones
                return RefreshIndicator(
                  onRefresh: () => controller.fetchNotifications(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: controller.notifications.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final notification = controller.notifications[index];
                      return _buildNotificationItem(
                        notification: notification,
                        onTap: () {
                          controller.markAsRead(notification.notificationId);
                          // Si tiene enlace, puedes manejarlo aquí
                          if (notification.linkUrl != null &&
                              notification.linkUrl!.isNotEmpty) {
                            print('Abrir: ${notification.linkUrl}');
                            // Aquí puedes usar url_launcher o navegar
                          }
                        },
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
    required VoidCallback onTap,
  }) {
    // Determinar icono según el tipo
    String iconPath;
    switch (notification.type.toLowerCase()) {
      case 'recordatorio':
        iconPath = 'assets/icons/warning.png';
        break;
      case 'alertawebinar':
        iconPath = 'assets/icons/campaign.png';
        break;
      case 'promocionflash':
        iconPath = 'assets/icons/campaign.png';
        break;
      default:
        iconPath = 'assets/icons/warning.png';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: notification.read
              ? Colors.white
              : GerenaColors.backgroundColorFondo,
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
                        Text(
                          notification.type.toUpperCase(),
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: GerenaColors.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          style: GoogleFonts.rubik(
                            fontSize: 12,
                            color: GerenaColors.textPrimaryColor,
                          ),
                        ),
                        if (notification.createdAt != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(notification.createdAt!),
                            style: GoogleFonts.rubik(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: GerenaColors.textPrimaryColor,
                            ),
                          ),
                        ],
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
                        
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
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