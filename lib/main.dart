import 'package:flutter/material.dart';
import 'package:managegym/main_screen/widgets/titlebar_widget.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    center: true,
    title: "ManageGym",
    backgroundColor: const Color.fromARGB(100, 33, 33, 33),
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  static const List<Widget> screens = <Widget>[
    Text('Home Screen', style: TextStyle(color: Colors.white, fontSize: 24)),
    Text('Store Screen', style: TextStyle(color: Colors.white, fontSize: 24)),
    Text('Clients Screen', style: TextStyle(color: Colors.white, fontSize: 24)),
    Text('Statistics Screen', style: TextStyle(color: Colors.white, fontSize: 24)),
    Text('Settings Screen', style: TextStyle(color: Colors.white, fontSize: 24)),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Construir los botones aquí, no como una constante estática
    List<CustomButtonHeader> customButtons = [
      CustomButtonHeader(
        icon: Icons.home,
        index: 0,
        active: _selectedIndex == 0,
        onPressed: onItemTapped,
      ),
      CustomButtonHeader(
        icon: Icons.storefront_outlined,
        index: 1,
        active: _selectedIndex == 1,
        onPressed: onItemTapped,
      ),
      CustomButtonHeader(
        icon: Icons.group_outlined,
        index: 2,
        active: _selectedIndex == 2,
        onPressed: onItemTapped,
      ),
      CustomButtonHeader(
        icon: Icons.bar_chart,
        index: 3,
        active: _selectedIndex == 3,
        onPressed: onItemTapped,
      ),
      CustomButtonHeader(
        icon: Icons.settings_outlined,
        index: 4,
        active: _selectedIndex == 4,
        onPressed: onItemTapped,
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ManageGym',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            TitlebarWidget(
              customButtons: customButtons,
              selectedIndex: _selectedIndex,
              onButtonPressed: onItemTapped,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  width: double.infinity,
                  child: screens[_selectedIndex],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
