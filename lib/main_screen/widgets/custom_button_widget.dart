import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double padding;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.borderRadius = 10,
    this.padding = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(padding),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
