
import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  final String text;
  final void Function(bool isAscending)? onChanged;

  const FilterButton({
    super.key,
    required this.text,
    this.onChanged,
  });

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  bool isAscending = true;

  void _toggleOrder() {
    setState(() {
      isAscending = !isAscending;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(isAscending);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _toggleOrder,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isAscending ? Icons.arrow_drop_down : Icons.arrow_drop_up,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}