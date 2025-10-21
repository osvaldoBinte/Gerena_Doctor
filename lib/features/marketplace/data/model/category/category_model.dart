import 'package:gerena/features/marketplace/domain/entities/categories/categories_entity.dart';

class CategoryModel extends CategoriesEntity {
  CategoryModel({super.image, required super.category});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      image: json['imagen'],  
      category: json['categoria'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imagen': image,
      'categoria': category
    };
  }
}