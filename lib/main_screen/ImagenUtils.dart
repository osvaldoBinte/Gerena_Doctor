import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class ImagenUtils {
  // Verifica si una cadena es Base64 válido
  static bool isBase64(String str) {
    try {
      if (str.isEmpty || str.length % 4 != 0 || str.contains('/') || str.contains('\\')) {
        return false;
      }
      
      // Solo verificamos una muestra para eficiencia
      final sample = str.length > 100 ? str.substring(0, 100) : str;
      base64Decode(sample);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Convierte un archivo a Base64
  static Future<String?> convertirImagenABase64(File file) async {
    try {
      List<int> imageBytes = await file.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      return base64Image;
    } catch (e) {
      print('❌ Error al convertir imagen a Base64: $e');
      return null;
    }
  }
}