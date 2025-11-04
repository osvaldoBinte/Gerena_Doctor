import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gerena/app.dart';
import 'package:gerena/common/settings/enviroment.dart';
import 'package:gerena/framework/preferences_service.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io' show Platform;

String enviromentSelect = Enviroment.testing.value;

void main() async {
  
  await dotenv.load(fileName: enviromentSelect);
  await PreferencesUser().initiPrefs();
 FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exception.toString().contains('KeyDownEvent') ||
        details.exception.toString().contains('hardware_keyboard') ||
        details.exception.toString().contains('MouseTracker') ||
        details.exception.toString().contains('mouse_tracker') ||
        details.exception.toString().contains('_debugDuringDeviceUpdate')) {
      print('INFO: Error de entrada ignorado en desarrollo: ${details.exception}');
      return;
    }
    FlutterError.presentError(details);
  };

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    final screenSize = await windowManager.getSize();
    
    final windowWidth = (screenSize.width * 0.8).clamp(1200.0, 1920.0); 
    final windowHeight = (screenSize.height * 0.8).clamp(800.0, 1080.0);
    
    final minWidth = (screenSize.width * 0.8).clamp(1000.0, 1400.0);
    final minHeight = (screenSize.height * 0.8).clamp(700.0, 900.0);

    WindowOptions windowOptions = const WindowOptions(
      center: true,
      title: "Gerena",
      backgroundColor: Color.fromARGB(100, 33, 33, 33),
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal, // Cambiado de hidden a normal
      windowButtonVisibility: true,
      
    );

    await windowManager.setSize(Size(windowWidth, windowHeight));
    await windowManager.setMinimumSize(Size(minWidth, minHeight)); // Corregido para usar las variables correctas

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
       await windowManager.maximize(); 
    });
  }

  runApp(const App());
}