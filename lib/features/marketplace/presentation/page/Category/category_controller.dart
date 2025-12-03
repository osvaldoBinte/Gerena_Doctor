import 'package:flutter/material.dart';
import 'package:gerena/features/marketplace/domain/entities/categories/categories_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/medications/medications_entity.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_category_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/searching_for_medications_usecase.dart';
import 'package:get/get.dart';
import 'dart:async';

class CategoryController extends GetxController {
  final GetCategoryUsecase getCategoryUsecase;
  final SearchingForMedicationsUsecase searchingForMedicationsUsecase; // ✅ NUEVO
  
  CategoryController({
    required this.getCategoryUsecase,
    required this.searchingForMedicationsUsecase, // ✅ NUEVO
  });

  var categories = <CategoriesEntity>[].obs;
  var filteredCategories = <CategoriesEntity>[].obs;
  var medications = <MedicationsEntity>[].obs; // ✅ NUEVO: Productos encontrados
  
  var selectedCategories = <String>[].obs;
  var isLoading = false.obs;
  var isLoadingProducts = false.obs; // ✅ NUEVO
  var errorMessage = ''.obs;
  
  final TextEditingController searchController = TextEditingController();
  var searchQuery = ''.obs;
  
  Timer? _debounce; // ✅ NUEVO: Para debounce
  var showingSearchResults = false.obs; // ✅ NUEVO

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    searchController.addListener(_onSearchChanged); // ✅ NUEVO
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }

  // ✅ NUEVO: Listener para búsqueda con debounce
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = searchController.text.trim();
      if (query.isEmpty) {
        clearSearch();
      } else {
        searchInBoth(query);
      }
    });
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final result = await getCategoryUsecase.execute();
      categories.value = result;
      filteredCategories.value = result;
      
    } catch (e) {
      errorMessage.value = 'Error al cargar categorías: $e';
      print('Error en fetchCategories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ NUEVO: Buscar en categorías y productos simultáneamente
  Future<void> searchInBoth(String query) async {
    searchQuery.value = query;
    showingSearchResults.value = true;
    
    try {
      // 1. Filtrar categorías localmente
      filteredCategories.value = categories.where((category) {
        final categoryName = category.category?.toLowerCase() ?? '';
        return categoryName.contains(query.toLowerCase());
      }).toList();
      
      // 2. Buscar productos en todas las categorías
      isLoadingProducts.value = true;
      medications.clear();
      
      // Buscar en cada categoría
      for (var category in categories) {
        if (category.category != null && category.category!.isNotEmpty) {
          try {
            final result = await searchingForMedicationsUsecase.execute(
              category.category!,
              query,
            );
            
            // Agregar productos únicos
            for (var medication in result) {
              if (!medications.any((m) => m.id == medication.id)) {
                medications.add(medication);
              }
            }
          } catch (e) {
            print('Error buscando en categoría ${category.category}: $e');
          }
        }
      }
      
      print('🔍 Búsqueda: "$query"');
      print('📁 Categorías encontradas: ${filteredCategories.length}');
      print('📦 Productos encontrados: ${medications.length}');
      
    } catch (e) {
      errorMessage.value = 'Error en búsqueda: $e';
      print('Error en searchInBoth: $e');
    } finally {
      isLoadingProducts.value = false;
    }
  }

  // Método original para filtrar solo categorías (mantener compatibilidad)
  void filterCategories(String query) {
    searchQuery.value = query;
    
    if (query.isEmpty) {
      showingSearchResults.value = false;
      filteredCategories.value = categories;
      medications.clear();
    } else {
      showingSearchResults.value = true;
      filteredCategories.value = categories.where((category) {
        final categoryName = category.category?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();
        return categoryName.contains(searchLower);
      }).toList();
    }
    
    print('🔍 Búsqueda: "$query" - Resultados: ${filteredCategories.length}');
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    showingSearchResults.value = false;
    filteredCategories.value = categories;
    medications.clear();
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