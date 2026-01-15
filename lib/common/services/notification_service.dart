import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gerena/firebase_options.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("📬 Handling a background message: ${message.messageId}");
  
  try {
    final prefs = await SharedPreferences.getInstance();
    
    int currentCount = prefs.getInt('unread_notifications') ?? 0;
    currentCount++;
    
    final saved = await prefs.setInt('unread_notifications', currentCount);
    final savedFlag = await prefs.setBool('has_new_notifications', true);
    
    await prefs.reload();
    
    final verifyCount = prefs.getInt('unread_notifications');
    final verifyFlag = prefs.getBool('has_new_notifications');
    
    print("✅ Background: Contador guardado = $currentCount");
    print("✅ Background: Saved success = $saved && $savedFlag");
    print("✅ Background: Verificación - count=$verifyCount, flag=$verifyFlag");
  } catch (e) {
    print("❌ Error guardando contador en background: $e");
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  String? fcmToken;
  
  final RxInt unreadNotificationsCount = 0.obs;
  final RxBool hasNewNotifications = false.obs;
  
  SharedPreferences? _prefs;
  static const String _keyUnreadCount = 'unread_notifications';
  static const String _keyHasNew = 'has_new_notifications';

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    
    await _loadPersistedCount();
    
    // 🆕 iOS requiere configuración diferente
    if (Platform.isIOS) {
      await _setupiOSNotifications();
    }
    
    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _generateFCMToken();
    _listenToTokenRefresh();
    _setupMessageListeners();
  }

  // 🆕 Configuración específica para iOS
  Future<void> _setupiOSNotifications() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    // Configurar para recibir notificaciones en foreground
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _loadPersistedCount() async {
    try {
      await _prefs?.reload();
      
      final count = _prefs?.getInt(_keyUnreadCount) ?? 0;
      final hasNew = _prefs?.getBool(_keyHasNew) ?? false;
      
      unreadNotificationsCount.value = count;
      hasNewNotifications.value = hasNew;
      
      print('📱 Contador cargado desde almacenamiento: $count');
      print('🔔 Tiene notificaciones nuevas: $hasNew');
    } catch (e) {
      print('❌ Error cargando contador: $e');
    }
  }

  Future<void> _saveCount() async {
    try {
      final savedCount = await _prefs?.setInt(_keyUnreadCount, unreadNotificationsCount.value);
      final savedFlag = await _prefs?.setBool(_keyHasNew, hasNewNotifications.value);
      
      await _prefs?.reload();
      
      print('💾 Contador guardado: ${unreadNotificationsCount.value} (success: $savedCount && $savedFlag)');
    } catch (e) {
      print('❌ Error guardando contador: $e');
    }
  }

  Future<void> _generateFCMToken() async {
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
      
      if (fcmToken != null) {
        print('✅ FCM Token generado: $fcmToken');
      } else {
        print('❌ No se pudo generar el token FCM');
      }
    } catch (e) {
      print('❌ Error al generar token FCM: $e');
    }
  }

  void _listenToTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      fcmToken = newToken;
      print('🔄 Token FCM actualizado: $newToken');
    }).onError((error) {
      print('❌ Error al actualizar token: $error');
    });
  }

  Future<String?> getToken() async {
    if (fcmToken != null) {
      return fcmToken;
    }
    
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
      return fcmToken;
    } catch (e) {
      print('❌ Error al obtener token: $e');
      return null;
    }
  }

  Future<void> sendTokenToServer(String token) async {
    try {
      print('📤 Token enviado al servidor: $token');
    } catch (e) {
      print('❌ Error al enviar token al servidor: $e');
    }
  }

  Future<void> deleteToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
      fcmToken = null;
      print('🗑️ Token FCM eliminado');
    } catch (e) {
      print('❌ Error al eliminar token: $e');
    }
  }

  void _setupMessageListeners() {
    // 🆕 Para iOS: manejar notificaciones cuando la app está en foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // 🆕 Para iOS: manejar cuando el usuario toca la notificación (app en background)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    
    _checkInitialMessage();
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('📨 Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('📬 Message also contained a notification: ${message.notification}');
      incrementUnreadCount();
    }
  }

  // 🆕 En iOS, este se llama cuando el usuario toca la notificación
  void _handleMessageOpenedApp(RemoteMessage message) {
    print('📱 Message opened app from background: ${message.data}');
    
    // 🆕 IMPORTANTE: Incrementar el contador aquí también para iOS
    incrementUnreadCount();
  }

  Future<void> _checkInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print('🚀 App opened from terminated state by notification: ${initialMessage.data}');
      
      // 🆕 Incrementar contador si la app se abrió desde una notificación
      await incrementUnreadCount();
    }
  }

  Future<void> incrementUnreadCount() async {
    unreadNotificationsCount.value++;
    hasNewNotifications.value = true;
    await _saveCount();
    print('📬 Notificaciones no leídas: ${unreadNotificationsCount.value}');
  }

  Future<void> clearUnreadCount() async {
    unreadNotificationsCount.value = 0;
    hasNewNotifications.value = false;
    await _saveCount();
    print('✅ Notificaciones marcadas como leídas');
  }

  Future<void> markAsRead(int count) async {
    unreadNotificationsCount.value = (unreadNotificationsCount.value - count).clamp(0, 999);
    if (unreadNotificationsCount.value == 0) {
      hasNewNotifications.value = false;
    }
    await _saveCount();
    print('✅ $count notificaciones marcadas como leídas. Restantes: ${unreadNotificationsCount.value}');
  }

  Future<void> reloadFromStorage() async {
    await _loadPersistedCount();
  }

  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    print('📢 Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    print('🔇 Unsubscribed from topic: $topic');
  }
}