import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
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

  final selectedCategories = <String>[].obs;

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  void filterProducts() {
    print('Filtering products with: ${selectedCategories.join(", ")}');
  }

  void clearFilters() {
    selectedCategories.clear();
  }
}
