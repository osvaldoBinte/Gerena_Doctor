import 'dart:convert';

import 'package:http/http.dart' as http;
class SubscripcionInactivaException implements Exception {
  final String error;
  final String mensaje;
  final String codigo;

  SubscripcionInactivaException({
    required this.error,
    required this.mensaje,
    required this.codigo,
  });

  // 👇 Parsea directo desde el response
  factory SubscripcionInactivaException.fromResponse(http.Response response) {
    try {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      return SubscripcionInactivaException(
        error: body['error'] ?? 'Acceso denegado',
        mensaje: body['mensaje'] ?? 'Tu suscripción ha vencido o no está activa.',
        codigo: body['codigo'] ?? 'SUSCRIPCION_INACTIVA',
      );
    } catch (_) {
      return SubscripcionInactivaException(
        error: 'Acceso denegado',
        mensaje: 'Tu suscripción ha vencido o no está activa.',
        codigo: 'SUSCRIPCION_INACTIVA',
      );
    }
  }

  @override
  String toString() => mensaje;
}