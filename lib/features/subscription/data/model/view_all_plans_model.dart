import 'package:gerena/features/subscription/domain/entities/view_all_plans_entity.dart';

class ViewAllPlansModel extends ViewAllPlansEntity {
  ViewAllPlansModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.interval,
    required super.caracteristicas,
    required super.activo,
  });

  factory ViewAllPlansModel.fromJson(Map<String, dynamic> json) {
    return ViewAllPlansModel(
      id: json['id'],
      name: json['nombre'],
      description: json['descripcion'],
      price: (json['precio'] as num).toDouble(),
      interval: json['intervalo'],
      caracteristicas: CaracteristicasModel.fromJson(json['caracteristicas']),
      activo: json['activo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': name,
      'descripcion': description,
      'precio': price,
      'intervalo': interval,
      'caracteristicas': {
        'beneficios': caracteristicas.beneficios,
        'destacados': caracteristicas.destacados,
      },
      'activo': activo,
    };
  }
}

class CaracteristicasModel extends Caracteristicas {
  CaracteristicasModel({
    required super.beneficios,
    super.destacados,
  });

  factory CaracteristicasModel.fromJson(Map<String, dynamic> json) {
    return CaracteristicasModel(
      beneficios: List<String>.from(json['beneficios']),
      destacados: json['destacados'] != null 
          ? List<String>.from(json['destacados']) 
          : null,
    );
  }
}