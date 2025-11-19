import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/features/notification/data/datasources/notification_data_sources_imp.dart';
import 'package:gerena/features/notification/domain/entities/notification_entity.dart';
import 'package:gerena/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImp extends NotificationRepository {
  final NotificationDataSourcesImp notificationDataSourcesImp;
  AuthService authService = AuthService();
  NotificationRepositoryImp({required this.notificationDataSourcesImp});
  @override
  Future<List<NotificationEntity>> getNotification() async {
    final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await notificationDataSourcesImp.getnotification(token);
  }
}
