import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  // List of product categories
  final categories = [
    'Toxinas',
    'Relleno facial',
    'Relleno corporal',
    'Enzimas',
    'Bioestimuladores',
    'Skin booster',
    'Anestesia',
    'Antiobesidad',
    'Insumos'
  ];

  // Selected categories
  final selectedCategories = <String>[].obs;

  // Toggle category selection
  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  // Filter products
  void filterProducts() {
    // Implement filtering logic
    print('Filtering products with: ${selectedCategories.join(", ")}');
  }

  // Clear all filters
  void clearFilters() {
    selectedCategories.clear();
  }
}
