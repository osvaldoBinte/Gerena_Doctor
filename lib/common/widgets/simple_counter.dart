import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleCounter extends StatefulWidget {
  final int initialValue;
  final Function(int)? onChanged;
  final int minValue;
  final int maxValue;
  final bool enabled;

  const SimpleCounter({
    Key? key,
    this.initialValue = 1,
    this.onChanged,
    this.minValue = 1,
    this.maxValue = 999,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<SimpleCounter> createState() => _SimpleCounterState();
}

class _SimpleCounterState extends State<SimpleCounter> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = widget.initialValue;
  }

  @override
  void didUpdateWidget(SimpleCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      count = widget.initialValue;
    }
  }

  void _increment() {
    if (!widget.enabled) return;
    
    if (count < widget.maxValue) {
      setState(() {
        count++;
      });
      widget.onChanged?.call(count);
    }
  }

  void _decrement() {
    if (!widget.enabled) return;
    
    if (count > widget.minValue) {
      setState(() {
        count--;
      });
      widget.onChanged?.call(count);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _decrement,
          child: Text(
            '−',
            style: GoogleFonts.rubik(
              fontSize: 12,
              color: widget.enabled && count > widget.minValue
                  ? Colors.grey
                  : Colors.grey.withOpacity(0.3),
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '$count',
            style: GoogleFonts.rubik(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: widget.enabled 
                ? Colors.black
                : Colors.grey,
            ),
          ),
        ),
        
        GestureDetector(
          onTap: _increment,
          child: Text(
            '+',
            style: GoogleFonts.rubik(
              fontSize: 12,
              color: widget.enabled && count < widget.maxValue
                  ? Colors.grey
                  : Colors.grey.withOpacity(0.3),
            ),
          ),
        ),
      ],
    );
  }
}

// Función helper para mantener compatibilidad con código existente
Widget simpleCounter({
  int initialValue = 1,
  Function(int)? onChanged,
  int minValue = 1,
  int maxValue = 999,
  bool enabled = true,
}) {
  return SimpleCounter(
    initialValue: initialValue,
    onChanged: onChanged,
    minValue: minValue,
    maxValue: maxValue,
    enabled: enabled,
  );
}