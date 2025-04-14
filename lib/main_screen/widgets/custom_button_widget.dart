import 'package:flutter/material.dart';

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



