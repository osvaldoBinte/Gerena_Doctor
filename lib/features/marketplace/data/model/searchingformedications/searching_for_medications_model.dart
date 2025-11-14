import 'dart:convert';
import 'package:gerena/features/marketplace/domain/entities/medications/medications_entity.dart';

class SearchingForMedicationsModel extends MedicationsEntity {
  SearchingForMedicationsModel({
    required super.id,
    required super.name,
    required super.description,
    required super.features,
    required super.price,
    super.previousPrice,
    required super.onSale,
    super.discountPercentage,
    required super.stock,
    required super.images,
    super.technicalSheetUrl,
    super.termsUrl,
    required super.category,
    required super.isActive,
  });

  factory SearchingForMedicationsModel.fromJson(Map<String, dynamic> json) {
    return SearchingForMedicationsModel(
      id: json['id'] ?? 0,
      name: json['nombre'] ?? '',
      description: json['descripcion'] ?? '',
      features: _parseStringList(json['caracteristicas']),
      price: (json['precio'] is num) ? (json['precio'] as num).toDouble() : 0.0,
      previousPrice: json['precioAnterior'] != null
          ? (json['precioAnterior'] as num).toDouble()
          : null,
      onSale: json['oferta'] ?? false,
      discountPercentage: json['porcentajeDescuento'] != null
          ? (json['porcentajeDescuento'] as num).toDouble()
          : null,
      stock: json['stock'] ?? 0,
      images: _parseStringList(json['imagen']),
      technicalSheetUrl: json['urL_FichaTecnica'],
      termsUrl: json['urL_Terminos'],
      category: json['categoria'] ?? '',
      isActive: json['activo'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': name,
      'descripcion': description,
      'caracteristicas': features,
      'precio': price,
      'precioAnterior': previousPrice,
      'oferta': onSale,
      'porcentajeDescuento': discountPercentage,
      'stock': stock,
      'imagen': images,
      'urL_FichaTecnica': technicalSheetUrl,
      'urL_Terminos': termsUrl,
      'categoria': category,
      'activo': isActive,
    };
  }

  /// Helper method to convert a JSON string or List to List<String>
  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    if (value is String) {
      try {
        final decoded = value.replaceAll("\\", "");
        final list = List<String>.from(jsonDecode(decoded));
        return list;
      } catch (_) {
        return [value];
      }
    }
    return [];
  }
}
