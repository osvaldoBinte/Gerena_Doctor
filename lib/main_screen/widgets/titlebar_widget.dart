import 'package:flutter/material.dart';
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
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
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
            SizedBox(width: 8), // Espacio al final
          ],
        ),
      ],
    ),
  );
}
}

class CustomButtonHeader extends StatelessWidget {
  final IconData icon;
  final bool active;
  final Function(int) onPressed;
  final int index;
  
  const CustomButtonHeader({
    required this.icon,
    this.active = false,
    required this.onPressed,
    required this.index,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: const Color.fromARGB(255, 167, 85, 85),
      onTap: () => onPressed(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: BoxDecoration(
          color: active ? Colors.orange : Colors.black,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}





















    // return Container(
    //   height: 55,
    //   color: Colors.black,
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Expanded(
    //         child: GestureDetector(
    //           onPanStart: (_) => windowManager.startDragging(),
    //           child: const Text(
    //             'ManageGym',
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontSize: 19,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //         ),
    //       ),
    //       Container(
    //         height: MediaQuery.of(context).size.height * 0.9,
    //         width: 3,
    //         color: const Color.fromARGB(255, 255, 255, 255),
    //       ),
    //       IconButton(
    //         icon: const Icon(Icons.minimize),
    //         color: Colors.white,
    //         onPressed: () {
    //           if (isMaximized) {
    //             windowManager.restore();
    //           } else {
    //             windowManager.minimize();
    //           }
    //         },
    //       ),
    //       IconButton(
    //         icon: Icon(isMaximized ? Icons.fullscreen_exit : Icons.fullscreen),
    //         color: Colors.white,
    //         onPressed: () {
    //           if (isMaximized) {
    //             windowManager.unmaximize();
    //           } else {
    //             windowManager.maximize();
    //           }
    //         },
    //       ),
    //       IconButton(
    //           icon: Icon(Icons.close),
    //           color: Colors.white,
    //           onPressed: () => {
    //                 windowManager.close(),
    //               })
    //     ],
    //   ),
    // );