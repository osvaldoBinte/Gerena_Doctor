import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/notification/domain/entities/notification_entity.dart';
import 'package:gerena/features/notification/presentation/page/notification_controller.dart';
import 'package:gerena/features/notification/presentation/widget/notification_modal_loading.dart';
import 'package:gerena/features/publications/presentation/page/postbyid/post_byId_page.dart';
import 'package:gerena/movil/home/start_controller.dart';
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
                    onTap: () => controller.deleteAllNotifications(),
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
                    icon: Image.asset(
                      'assets/icons/close.png',
                      width: 20,
                      height: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const NotificatioLoading();
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
                              fontSize: 16, color: Colors.grey),
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
                              fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchNotifications(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: controller.notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final notification = controller.notifications[index];
                      return _buildNotificationItem(
                        context: context,
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
    required BuildContext context,
    required NotificationEntity notification,
    required NotificationController controller,
  }) {
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
      onTap: () async {
        try {
          controller.markAsRead(notification.notificationId);

          dynamic rawMetadata = notification.metadata;
          Map metadata = {};
          if (rawMetadata is String && rawMetadata.isNotEmpty) {
            metadata = jsonDecode(rawMetadata);
          } else if (rawMetadata is Map) {
            metadata = rawMetadata;
          }

          // ── Reacción → cerrar modal + abrir post en bottom sheet ──
          if (notification.type.toLowerCase() == 'reaccion') {
            final int? publicacionId = metadata['PublicacionId'];
            if (publicacionId != null) {
              Get.back(); // cierra el modal
              await Future.delayed(const Duration(milliseconds: 200));
              _openPostBottomSheet(context, postId: publicacionId);
            }
            return;
          }

          // ── Comentario → cerrar modal + abrir post con highlight ──
          if (notification.type.toLowerCase() == 'comentario') {
            final int? publicacionId = metadata['PublicacionId'];
            final int? comentarioId = metadata['ComentarioId'];
            if (publicacionId != null) {
              Get.back(); // cierra el modal
              await Future.delayed(const Duration(milliseconds: 200));
              _openPostBottomSheet(
                context,
                postId: publicacionId,
                commentId: comentarioId,
              );
            }
            return;
          }

          // ── Navegar a perfil ──────────────────────────────────────
          final int? userId = metadata['SeguidorId'] ??
              metadata['UsuarioReacciono'] ??
              metadata['UsuarioComenta'];
          final String? rol = metadata['RolUsuario'] ??
              metadata['UsuarioReaccionoRol'] ??
              metadata['RolUsuarioComenta'];

          if (userId != null && rol != null) {
            Get.back(); // cierra el modal
            await Future.delayed(const Duration(milliseconds: 200));
            final startController = Get.find<StartController>();
            if (rol == 'cliente') {
              startController.showUserProfilePage(userData: {'userId': userId});
            } else if (rol == 'doctor') {
              startController
                  .showDoctorProfilePage(doctorData: {'userId': userId});
            }
          }

          // ── Link genérico ─────────────────────────────────────────
          if (notification.linkUrl != null &&
              notification.linkUrl!.isNotEmpty) {
            print('Abrir: ${notification.linkUrl}');
          }
        } catch (e) {
          print("Error procesando notificación: $e");
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: notification.read
              ? Colors.white
              : GerenaColors.backgroundColorFondo,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.asset(
                iconPath,
                width: 30,
                height: 30,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.notifications,
                  size: 30,
                  color: Colors.grey,
                ),
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
                          errorBuilder: (_, __, ___) => Container(
                            height: 100,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported),
                            ),
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
      ),
    );
  }

  void _openPostBottomSheet(
    BuildContext context, {
    required int postId,
    int? commentId,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.92,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // ── Handle + header ──────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close,
                        color: GerenaColors.textPrimaryColor),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Publicación',
                    style:
                        GerenaColors.headingMedium.copyWith(fontSize: 18),
                  ),
                ],
              ),
            ),
            // ── Contenido del post ───────────────────────────────
            Expanded(
              child: PostByIdPage(
                postId: postId,
                commentId: commentId,
              ),
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
        'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
        'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
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