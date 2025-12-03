import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

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
