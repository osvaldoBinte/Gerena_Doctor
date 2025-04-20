import 'package:flutter/material.dart';
import 'package:managegym/main_screen/widgets/custom_button_widget.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:math';

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

class _TitlebarWidgetState extends State<TitlebarWidget> with WindowListener, SingleTickerProviderStateMixin {
  bool isMaximized = false;

  // Animation for wave effect
  late final AnimationController _waveController;

  @override
  void initState() {
    windowManager.addListener(this);
    _init();
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  void _init() async {
    isMaximized = await windowManager.isMaximized();
    setState(() {});
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _waveController.dispose();
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
          // Área arrastrable con logo y animación
          Expanded(
            child: GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    return ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return _buildWaveGradient(bounds, _waveController.value);
                      },
                      child: const Text(
                        'AESTHETIC GYM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Botones de navegación
          Row(
            children: widget.customButtons,
          ),
          // Botones de ventana (minimizar y cerrar)
          Row(
            children: [
              // Botón Minimizar
              IconButton(
                icon: const Icon(Icons.minimize),
                color: Colors.white,
                onPressed: () => windowManager.minimize(),
              ),
              // Botón Cerrar
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

  // Wave gradient builder
  Shader _buildWaveGradient(Rect bounds, double animValue) {
    // Crea un gradiente desplazado tipo ola
    final List<Color> rainbowColors = [
      Colors.pinkAccent,
      Colors.orangeAccent,
      Colors.yellowAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.purpleAccent,
      Colors.pinkAccent,
    ];

    // Parámetros para el efecto de ola
    double waveSpeed = animValue * 2 * pi;
    List<double> stops = List.generate(
      rainbowColors.length,
      (i) => 0.1 + 0.8 * (i / (rainbowColors.length - 1)),
    );

    // La posición del gradiente se mueve "en ola"
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: List.generate(
        rainbowColors.length,
        (i) {
          double wave = sin(waveSpeed + i * pi / 3) * 0.08;
          return rainbowColors[i].withOpacity(0.9 + wave);
        },
      ),
      stops: stops,
      tileMode: TileMode.mirror,
      transform: GradientRotation(animValue * 2 * pi),
    ).createShader(bounds);
  }
}