import 'package:flutter/material.dart';
import 'package:gerena/features/marketplace/domain/entities/categories/categories_entity.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_category_usecase.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final GetCategoryUsecase getCategoryUsecase;
  
  CategoryController({required this.getCategoryUsecase});

  var categories = <CategoriesEntity>[].obs;
  var filteredCategories = <CategoriesEntity>[].obs; // ✅ NUEVO
  var selectedCategories = <String>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  
  // ✅ NUEVO: Controller para el search
  final TextEditingController searchController = TextEditingController();
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final result = await getCategoryUsecase.execute();
      categories.value = result;
      filteredCategories.value = result; // ✅ Inicializar con todas las categorías
      
    } catch (e) {
      errorMessage.value = 'Error al cargar categorías: $e';
      print('Error en fetchCategories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ NUEVO: Método para filtrar categorías
  void filterCategories(String query) {
    searchQuery.value = query;
    
    if (query.isEmpty) {
      filteredCategories.value = categories;
    } else {
      filteredCategories.value = categories.where((category) {
        final categoryName = category.category?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();
        return categoryName.contains(searchLower);
      }).toList();
    }
    
    print('🔍 Búsqueda: "$query" - Resultados: ${filteredCategories.length}');
  }

  // ✅ NUEVO: Limpiar búsqueda
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    filteredCategories.value = categories;
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  bool isCategorySelected(String category) {
    return selectedCategories.contains(category);
  }

  void clearFilters() {
    selectedCategories.clear();
  }

  void retryFetch() {
    fetchCategories();
  }
}