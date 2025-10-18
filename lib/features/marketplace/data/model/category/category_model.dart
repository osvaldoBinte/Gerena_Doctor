import 'package:gerena/features/marketplace/domain/entities/categories/categories_entity.dart';

class CategoryModel extends CategoriesEntity {
  CategoryModel({super.foto, required super.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      foto: json['foto'],  
      name: json['nombre'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foto': foto,
      'nombre': name
    };
  }
}