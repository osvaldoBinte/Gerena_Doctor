import 'package:flutter/material.dart';
import 'package:managegym/main_screen/widgets/custom_button_widget.dart';
import 'package:window_manager/window_manager.dart';

class TitlebarWidget extends StatefulWidget {
  final List<CustomButtonHeader> customButtons;
  final int selectedIndex;
  final Function(int) onButtonPressed;

  const TitlebarWidget({
    super.key,
    required this.customButtons,
    required this.selectedIndex,
    required this.onButtonPressed,
  });

  @override
  State<TitlebarWidget> createState() => _TitlebarWidgetState();
}

class _TitlebarWidgetState extends State<TitlebarWidget> with WindowListener {
  bool isMaximized = false;

  @override
  void initState() {
    windowManager.addListener(this);
    ();
    super.initState();
  }

  void _init() async {
    isMaximized = await windowManager.isMaximized();
    setState(() {});
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowMaximize() {
    setState(() => isMaximized = true);
  }

  @override
  void onWindowUnmaximize() {
    setState(() => isMaximized = false);
  }

 @override
Widget build(BuildContext context) {
  return Container(
    height: 55,
    decoration: BoxDecoration(
      color: Colors.grey[900],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Área arrastrable con logo
        Expanded(
          child: GestureDetector(
            onPanStart: (_) => windowManager.startDragging(),
            child: const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'ManageGym',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        // Botones de navegación
        Row(
          children: widget.customButtons,
        ),
        // Botones de ventana
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.minimize),
              color: Colors.white,
              onPressed: () => windowManager.minimize(),
            ),
            IconButton(
              icon: Icon(
                isMaximized ? Icons.fullscreen_exit : Icons.fullscreen,
              ),
              color: Colors.white,
              onPressed: () {
                if (isMaximized) {
                  windowManager.unmaximize();
                } else {
                  windowManager.maximize();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.close),
              color: Colors.white,
              onPressed: () => windowManager.close(),
            ),
            const SizedBox(width: 8), // Espacio al final
          ],
        ),
      ],
    ),
  );
}
}














