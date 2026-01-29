import 'package:flutter/material.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/user/domain/entities/getuser/search_profile_entity.dart';
import 'package:gerena/features/user/domain/entities/getuser/search_profile_request_entity.dart';
import 'package:gerena/features/user/domain/usecase/search_profile_usecase.dart';
import 'package:get/get.dart';

class SearchProfileController extends GetxController {
  final SearchProfileUsecase searchProfileUsecase;
  
  SearchProfileController({required this.searchProfileUsecase});

  // Observable lists
  final RxList<SearchProfileEntity> searchResults = <SearchProfileEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxInt currentPage = 1.obs;
  final RxString currentSearchQuery = ''.obs;
  final RxString currentRol = ''.obs;
  final RxInt registrosPorPagina = 10.obs; // Cantidad de registros por página
  
  // ScrollController para detectar el scroll
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    // Agregar listener al scroll
    scrollController.addListener(_onScroll);
    // Cargar todos los perfiles al iniciar
    loadAllProfiles();
  }

  // Detectar cuando se llega al final del scroll
  void _onScroll() {
    // Cuando llega al 80% del scroll, cargar más
    if (scrollController.position.pixels >= 
        scrollController.position.maxScrollExtent * 0.8) {
      if (!isLoading.value && hasMore.value) {
        loadMoreProfiles();
      }
    }
  }

  // Cargar todos los perfiles (búsqueda vacía)
  Future<void> loadAllProfiles() async {
    await searchProfiles(
      busqueda: '', 
      rol: '', 
      refresh: true,
    );
  }

  // Buscar perfiles (primera carga o refresh)
  Future<void> searchProfiles({
    String? busqueda,
    String? rol,
    bool refresh = false,
  }) async {
    if (refresh) {
      currentPage.value = 1;
      searchResults.clear();
      hasMore.value = true;
      currentSearchQuery.value = busqueda ?? '';
      currentRol.value = rol ?? '';
    }

    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final request = SearchProfileRequestEntity(
        busqueda: busqueda ?? currentSearchQuery.value,
        rol: rol ?? currentRol.value,
        pagina: currentPage.value,
        registrosPorPagina: registrosPorPagina.value,
      );

      final results = await searchProfileUsecase.searchProfile(request);

      if (results.isEmpty || results.length < registrosPorPagina.value) {
        hasMore.value = false;
      }
      
      if (results.isNotEmpty) {
        if (refresh) {
          searchResults.value = results;
        } else {
          searchResults.addAll(results);
        }
        currentPage.value++;
      } else {
        if (refresh) {
          searchResults.clear();
        }
        hasMore.value = false;
      }
      
    } catch (e) {
      showErrorSnackbar('Error al buscar perfiles');
      print('Error en searchProfiles: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Cargar más perfiles (paginación)
  Future<void> loadMoreProfiles() async {
    if (isLoading.value || !hasMore.value) return;

    await searchProfiles(
      busqueda: currentSearchQuery.value,
      rol: currentRol.value,
      refresh: false,
    );
  }

  // Pull to refresh
  Future<void> refreshProfiles() async {
    await searchProfiles(
      busqueda: currentSearchQuery.value,
      rol: currentRol.value,
      refresh: true,
    );
  }

  // Buscar con nuevo filtro
  Future<void> searchWithFilter({
    required String busqueda,
    String? rol,
  }) async {
    await searchProfiles(
      busqueda: busqueda,
      rol: rol,
      refresh: true,
    );
  }

  // Limpiar búsqueda y volver a cargar todo
  Future<void> clearSearch() async {
    currentSearchQuery.value = '';
    currentRol.value = '';
    await loadAllProfiles();
  }
Map<String, dynamic> entityToMap(SearchProfileEntity entity) {
  return {
    'userId': entity.userId,
    'doctorName': entity.fullName,
    'username': entity.username, // ✨ AGREGAR ESTO
    'specialty': entity.specialty ?? '',
    'profileImage': entity.profilePictureUrl ?? '',
    'rating': entity.averagerating ?? 0.0,
    'reviews': '', 
    'location': entity.address ?? '',
    'info': entity.bibliography ?? '',
    'experienceTime': entity.expreriecetime,
    'rol': entity.rol,
  };
}

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}