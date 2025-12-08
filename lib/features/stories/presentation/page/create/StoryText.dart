import 'package:flutter/material.dart';

class StoryText {
  final String text;
  final Color color;
  Offset position;
  double scale;
  final String id;

  StoryText({
    required this.text,
    required this.color,
    required this.position,
    this.scale = 1.0,
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  StoryText copyWith({
    String? text,
    Color? color,
    Offset? position,
    double? scale,
  }) {
    return StoryText(
      text: text ?? this.text,
      color: color ?? this.color,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      id: id,
    );
  }
}