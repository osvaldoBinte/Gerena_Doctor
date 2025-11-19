import 'package:gerena/common/errors/convert_message.dart';
import 'package:gerena/features/notification/domain/entities/notification_entity.dart';
import 'package:gerena/features/notification/domain/usecase/get_notification_usecase.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final GetNotificationUsecase getNotificationUsecase;
  
  NotificationController({required this.getNotificationUsecase});
  
  final RxList<NotificationEntity> notifications = <NotificationEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final result = await getNotificationUsecase.execute();
      notifications.value = result;
    } catch (e) {
      error.value =cleanExceptionMessage(e) ;
      print('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearAllNotifications() {
    notifications.clear();
  }

  void markAsRead(int notificationId) {
    final index = notifications.indexWhere((n) => n.notificationId == notificationId);
    if (index != -1) {
    }
  }
}