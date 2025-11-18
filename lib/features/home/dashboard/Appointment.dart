import 'dart:ui';

class Appointment {
  final String subject;
  final DateTime startTime;
  final DateTime endTime;
  final String? notes;
  final String? location;
  final Color color;

  Appointment({
    required this.subject,
    required this.startTime,
    required this.endTime,
    this.notes,
    this.location,
    this.color = const Color(0xFF0F8644),
  });
}