import 'package:flutter/material.dart';
import 'package:gerena/features/marketplace/domain/entities/medications/medications_entity.dart';
import 'package:gerena/features/marketplace/domain/usecase/searching_for_medications_usecase.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_medicines_on_sale_usecase.dart';
import 'package:get/get.dart';
import 'dart:async';

class GetMedicationsController extends GetxController {
  final SearchingForMedicationsUsecase searchingForMedicationsUsecase;
  final GetMedicinesOnSaleUsecase getMedicinesOnSaleUsecase;
  
  GetMedicationsController({
    required this.searchingForMedicationsUsecase,
    required this.getMedicinesOnSaleUsecase,
  });
  
  late TextEditingController searchController;
  
  Timer? _debounce;
  
  var medications = <MedicationsEntity>[].obs;
  var medicationsOnSale = <MedicationsEntity>[].obs;
  var isLoading = false.obs;
  var isLoadingOffers = false.obs;
  var errorMessage = ''.obs;
  var errorMessageOffers = ''.obs;
  
  var currentCategoryName = ''.obs;
  
  var searchQuery = ''.obs;
  
  var showOffers = true.obs;
  
  var selectedCategoriesForFilter = <String>[].obs;
  
@override
void onInit() {
  super.onInit();
  
  searchController = TextEditingController();
  
  searchController.addListener(_onSearchChanged);
  
  final args = Get.arguments;
  if (args != null) {
    currentCategoryName.value = args['categoryName'] ?? '';
    showOffers.value = args['showOffers'] ?? true;
    print('currentCategoryName: "$currentCategoryName"');
  }
  
  if (showOffers.value) {
    fetchMedicationsOnSale();
  }
  
  fetchMedicationsByCategory(currentCategoryName.value);
}
  
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = searchController.text.trim();
      searchQuery.value = query;
      
      if (query.isEmpty) {
        fetchMedicationsByCategory(currentCategoryName.value);
      } else {
        fetchMedicationsByCategory(currentCategoryName.value, search: query);
      }
    });
  }
  
  Future<void> fetchMedicationsOnSale() async {
    try {
      isLoadingOffers.value = true;
      errorMessageOffers.value = '';
      
      final result = await getMedicinesOnSaleUsecase.execute();
      medicationsOnSale.value = result;
      
    } catch (e) {
      errorMessageOffers.value = 'Error al cargar ofertas: $e';
      print('Error en fetchMedicationsOnSale: $e');
    } finally {
      isLoadingOffers.value = false;
    }
  }
  
  Future<void> fetchMedicationsByCategory(String categoryName, {String search = ''}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final result = await searchingForMedicationsUsecase.execute(categoryName, search);
      print('result $result');
      medications.value = result;
      
    } catch (e) {
      errorMessage.value = 'Error al cargar productos: $e';
      print('Error en fetchMedicationsByCategory: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> filterByCategories(List<String> categories) async {
    selectedCategoriesForFilter.value = categories;
    
    if (categories.isEmpty) {
      fetchMedicationsByCategory(currentCategoryName.value, search: searchQuery.value);
      return;
    }
    
    try {
      isLoading.value = true;
      errorMessage.value = '';
      medications.clear();
      
      for (String category in categories) {
        print('🔍 Buscando en categoría: $category');
        final result = await searchingForMedicationsUsecase.execute(
          category, 
          searchQuery.value
        );
        
        for (var medication in result) {
          if (!medications.any((m) => m.id == medication.id)) {
            medications.add(medication);
          }
        }
      }
      
      print('✅ Total productos encontrados: ${medications.length}');
      
    } catch (e) {
      errorMessage.value = 'Error al filtrar productos: $e';
      print('❌ Error en filterByCategories: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void clearCategoryFilters() {
    selectedCategoriesForFilter.clear();
    fetchMedicationsByCategory(currentCategoryName.value, search: searchQuery.value);
  }
  
  void searchMedications(String query) {
    searchQuery.value = query;
    
    if (selectedCategoriesForFilter.isEmpty) {
      fetchMedicationsByCategory(currentCategoryName.value, search: query);
    } else {
      filterByCategories(selectedCategoriesForFilter.toList());
    }
  }
  
  void toggleShowOffers(bool value) {
    showOffers.value = value;
    if (value && medicationsOnSale.isEmpty) {
      fetchMedicationsOnSale();
    }
  }
  
  void retryFetch() {
    if (selectedCategoriesForFilter.isEmpty) {
      fetchMedicationsByCategory(currentCategoryName.value, search: searchQuery.value);
    } else {
      filterByCategories(selectedCategoriesForFilter.toList());
    }
  }
  
  void retryFetchOffers() {
    fetchMedicationsOnSale();
  }
  
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    
    if (selectedCategoriesForFilter.isEmpty) {
      fetchMedicationsByCategory(currentCategoryName.value);
    } else {
      filterByCategories(selectedCategoriesForFilter.toList());
    }
  }
  
  Future<void> refreshAll() async {
    if (showOffers.value) {
      await fetchMedicationsOnSale();
    }
    
    if (selectedCategoriesForFilter.isEmpty) {
      await fetchMedicationsByCategory(currentCategoryName.value, search: searchQuery.value);
    } else {
      await filterByCategories(selectedCategoriesForFilter.toList());
    }
  }
  
  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}