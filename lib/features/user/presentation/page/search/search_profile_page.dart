import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/user/presentation/page/search/search_profile_controller.dart';
import 'package:gerena/movil/home/start_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchProfilePage extends StatefulWidget {
  const SearchProfilePage({Key? key}) : super(key: key);

  @override
  State<SearchProfilePage> createState() => _SearchProfilePageState();
}

class _SearchProfilePageState extends State<SearchProfilePage> {
  final SearchProfileController controller = Get.find<SearchProfileController>();
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >= 
        scrollController.position.maxScrollExtent * 0.9) {
      controller.searchProfiles();
    }
  }

  void _performSearch(String query) {
    controller.searchProfiles(
      busqueda: query.trim(),
      rol: controller.currentRol.value,
      refresh: true,
    );
  }

  void _onSearchChanged(String value) {
    // Cancelar el timer anterior si existe
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    
    // Crear nuevo timer que se ejecutará después de 500ms
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(value);
    });
  }
    final StartController controller2 = Get.find<StartController>();

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorfondo,
       appBar: AppBar(
        backgroundColor: GerenaColors.backgroundColorFondo,
        elevation: 4,
        shadowColor: GerenaColors.shadowColor,
        title: Row(
          children: [
            IconButton(
              onPressed: () => {controller2.hideSearch()},
              icon: Image.asset(
                'assets/icons/arrow_back.png',
                width: 60,
                height: 40,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
          'Buscar Perfiles',
          style: GoogleFonts.rubik(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: GerenaColors.textPrimaryColor,
          ),
        ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Container(
            color: GerenaColors.backgroundColorfondo,
            padding: const EdgeInsets.all(16),
            child: GerenaColors.createSearchTextField(
              controller: searchController,
              hintText: 'Buscar por nombre o especialidad...',
              onSearchPressed: () => _performSearch(searchController.text),
              onChanged: _onSearchChanged,
            ),
          ),

          // Filtros de rol
          Container(
            color: GerenaColors.backgroundColorfondo,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Todos', ''),
                  const SizedBox(width: 8),
                  _buildFilterChip('Doctores', 'doctor'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pacientes', 'cliente'),
                ],
              ),
            ),
          ),

          // Resultados
          Expanded(
            child: Obx(() {
              // Estado de carga inicial
              if (controller.isLoading.value && controller.searchResults.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: GerenaColors.primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Cargando perfiles...',
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                          color: GerenaColors.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Sin resultados
              if (controller.searchResults.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 80,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontraron resultados',
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          color: GerenaColors.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.currentSearchQuery.value.isNotEmpty
                            ? 'Intenta con otra búsqueda'
                            : 'No hay perfiles disponibles',
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                          color: GerenaColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          searchController.clear();
                          controller.clearSearch();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GerenaColors.primaryColor,
                        ),
                        child: Text(
                          'Recargar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Lista de resultados
              return RefreshIndicator(
                onRefresh: () {
                  if (controller.currentSearchQuery.value.isEmpty) {
                    return controller.loadAllProfiles();
                  }
                  return controller.searchProfiles(
                    busqueda: controller.currentSearchQuery.value,
                    rol: controller.currentRol.value,
                    refresh: true,
                  );
                },
                color: GerenaColors.primaryColor,
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.searchResults.length + 
                      (controller.isLoading.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Loading indicator al final
                    if (index >= controller.searchResults.length) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: GerenaColors.primaryColor,
                          ),
                        ),
                      );
                    }

                    final profile = controller.searchResults[index];
                    final doctorMap = controller.entityToMap(profile);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GerenaColors.createDoctorCard(doctorMap),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String rol) {
    return Obx(() {
      final isSelected = controller.currentRol.value == rol;
      
      return GestureDetector(
        onTap: () {
          controller.searchProfiles(
            busqueda: controller.currentSearchQuery.value,
            rol: rol,
            refresh: true,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected 
                ? GerenaColors.primaryColor 
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected 
                  ? GerenaColors.primaryColor 
                  : Colors.grey.shade300,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.rubik(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected 
                  ? Colors.white 
                  : GerenaColors.textSecondaryColor,
            ),
          ),
        ),
      );
    });
  }
}