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
      
      result.sort((a, b) {
        if (a.createdAt != null && b.createdAt != null) {
          try {
            final dateA = DateTime.parse(a.createdAt!);
            final dateB = DateTime.parse(b.createdAt!);
            return dateB.compareTo(dateA);
          } catch (e) {
            print('Error parseando fechas: $e');
            return 0;
          }
        }
        
        if (a.createdAt != null) return -1;
        
        if (b.createdAt != null) return 1;
        
        return 0;
      });
      
      notifications.value = result;
      
    } catch (e) {
      error.value = cleanExceptionMessage(e);
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
  
  void sortByDate({bool descending = true}) {
    notifications.sort((a, b) {
      if (a.createdAt != null && b.createdAt != null) {
        try {
          final dateA = DateTime.parse(a.createdAt!);
          final dateB = DateTime.parse(b.createdAt!);
          return descending 
              ? dateB.compareTo(dateA)
              : dateA.compareTo(dateB); 
        } catch (e) {
          return 0;
        }
      }
      
      if (a.createdAt != null) return descending ? -1 : 1;
      if (b.createdAt != null) return descending ? 1 : -1;
      
      return 0;
    });
    
    notifications.refresh();
  }
}