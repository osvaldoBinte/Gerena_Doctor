import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gerena/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Handling a background message: ${message.messageId}");
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  String? fcmToken;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Generar y obtener el token FCM
    await _generateFCMToken();

    // Escuchar cambios en el token
    _listenToTokenRefresh();

    _setupMessageListeners();
  }

  Future<void> _generateFCMToken() async {
    try {
      // Obtener el token FCM
      fcmToken = await FirebaseMessaging.instance.getToken();
      
      if (fcmToken != null) {
        print('✅ FCM Token generado: $fcmToken');
        // 👉 Aquí puedes enviar el token a tu backend
        // await _sendTokenToServer(fcmToken!);
      } else {
        print('❌ No se pudo generar el token FCM');
      }
    } catch (e) {
      print('❌ Error al generar token FCM: $e');
    }
  }

  void _listenToTokenRefresh() {
    // Escuchar cuando el token se actualice
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      fcmToken = newToken;
      print('🔄 Token FCM actualizado: $newToken');
      // 👉 Envía el nuevo token a tu backend
      // _sendTokenToServer(newToken);
    }).onError((error) {
      print('❌ Error al actualizar token: $error');
    });
  }

  // Método para obtener el token manualmente si lo necesitas
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

  // Método para enviar el token a tu backend (implementa según tu API)
  Future<void> sendTokenToServer(String token) async {
    try {
      // 👉 Implementa aquí la llamada a tu API
      // await apiService.updateFCMToken(token);
      print('📤 Token enviado al servidor: $token');
    } catch (e) {
      print('❌ Error al enviar token al servidor: $e');
    }
  }

  // Método para eliminar el token (útil al cerrar sesión)
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
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    _checkInitialMessage();
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print(
        'Message also contained a notification: ${message.notification}',
      );
      // 👉 Aquí Firebase muestra la notificación automáticamente
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    print('Message opened app: ${message.data}');
    // 👉 Maneja navegación si lo necesitas
  }

  Future<void> _checkInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print(
        'App opened from terminated state by notification: ${initialMessage.data}',
      );
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }
}