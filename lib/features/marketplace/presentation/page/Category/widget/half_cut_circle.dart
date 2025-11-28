import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

class HalfCutCircle extends StatelessWidget {
  final IconData icon;

  const HalfCutCircle({required this.icon});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BottomFlatClipper(),
      child: Container(
        width: 60,
        height: 60,
        color: GerenaColors.secondaryColor,
        child: Icon(icon, color: GerenaColors.textLightColor, size: 28),
      ),
    );
  }
}

class BottomFlatClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    path.addRect(Rect.fromLTWH(0, size.height * 0.8, size.width, size.height * 0.2));
    return Path.combine(PathOperation.difference, path, Path()..addRect(Rect.fromLTWH(0, size.height * 0.8, size.width, size.height)));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
