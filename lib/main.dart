import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:managegym/db/database_connection.dart';
import 'package:managegym/main_screen/screens/administradores_screen.dart';
import 'package:managegym/main_screen/screens/clients_screen.dart';
import 'package:managegym/main_screen/screens/inicio_sesion.dart';
import 'package:managegym/main_screen/screens/store_screen.dart';
import 'package:managegym/main_screen/screens/venta_screen.dart';
import 'package:managegym/main_screen/widgets/custom_button_widget.dart';
import 'package:managegym/main_screen/widgets/titlebar_widget.dart';
import 'package:managegym/main_screen/screens/home_screen.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  // Configurar un manejador de errores global
  FlutterError.onError = (FlutterErrorDetails details) {
    // Si el error está relacionado con teclas, solo lo registramos sin detener la app
    if (details.exception.toString().contains('KeyDownEvent') || 
        details.exception.toString().contains('hardware_keyboard')) {
      // Solo registrar sin mostrar el error completo
      print('INFO: Se detectó un error de teclado que puede ignorarse en desarrollo');
      return;
    }
    // Para otros errores, comportamiento normal
    FlutterError.presentError(details);
  };
  
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configura la orientación preferida
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  await windowManager.ensureInitialized();

  // Configuración de ventana
  WindowOptions windowOptions = const WindowOptions(
    center: true,
    title: "ManageGym",
    backgroundColor: Color.fromARGB(100, 33, 33, 33),
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );

  // Establecemos un tamaño inicial razonable
  await windowManager.setSize(Size(1024, 768));
  
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    // No maximizamos aquí para que el login no inicie maximizado
  });

  try {
    await Database.connect();
  } catch (e) {
    print('Error al conectar a la base de datos: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ManageGym',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const PantallaInicial(),
        '/venta': (context) => const ScreenVenta(),
      },
    );
  }
}

class PantallaInicial extends StatefulWidget {
  const PantallaInicial({super.key});

  @override
  State<PantallaInicial> createState() => _PantallaInicialState();
}

class _PantallaInicialState extends State<PantallaInicial> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    // Maximizar la ventana al entrar a esta pantalla
    _maximizeWindow();
  }

  Future<void> _maximizeWindow() async {
    await windowManager.maximize();
  }

  static const List<Widget> screens = <Widget>[
    AdministradoresScreen(),
    HomeScreen(),
    StoreScreen(),
    // ClientsScreen(),
    // Text('Statistics Screen',
    //     style: TextStyle(color: Colors.white, fontSize: 24)),
    // Text('Settings Screen',
    //     style: TextStyle(color: Colors.white, fontSize: 24)),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<CustomButtonHeader> customButtons = [
      CustomButtonHeader(
        icon: Icons.badge_outlined,
        index: 0,
        active: _selectedIndex == 0,
        onPressed: onItemTapped,
      ),
      CustomButtonHeader(
        icon: Icons.home,
        index: 1,
        active: _selectedIndex == 1,
        onPressed: onItemTapped,
      ),
      CustomButtonHeader(
        icon: Icons.storefront,
        index: 2,
        active: _selectedIndex == 2,
        onPressed: onItemTapped,
      ),
      CustomButtonHeader(
        icon: Icons.group_add_outlined,
        index: 3,
        active: _selectedIndex == 3,
        onPressed: onItemTapped,
      ),
      CustomButtonHeader(
        icon: Icons.bar_chart_rounded,
        index: 4,
        active: _selectedIndex == 4,
        onPressed: onItemTapped,
      ),
      CustomButtonHeader(
        icon: Icons.settings_outlined,
        index: 5,
        active: _selectedIndex == 5,
        onPressed: onItemTapped,
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          TitlebarWidget(
            customButtons: customButtons,
            selectedIndex: _selectedIndex,
            onButtonPressed: onItemTapped,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              child: screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}