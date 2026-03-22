import 'package:gerena/features/notification/domain/repositories/notification_repository.dart';

class DeleteAllNotificationsUsecase {
  final NotificationRepository notificationRepository;

  DeleteAllNotificationsUsecase({ required this.notificationRepository});

  Future<void> execute() async {
    await notificationRepository.deleteAllNotifications();
  }
}