import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/stories/domain/entities/getstories/get_stories_entity.dart';
import 'package:gerena/features/stories/domain/entities/getstories/story_entity.dart';
import 'package:gerena/features/stories/domain/entities/post/post_stories_entity.dart';
import 'package:gerena/features/stories/domain/usecase/add_like_to_story_usecase.dart';
import 'package:gerena/features/stories/domain/usecase/create_strory_usecase.dart';
import 'package:gerena/features/stories/domain/usecase/fetch_stories_by_id_usecase.dart';
import 'package:gerena/features/stories/domain/usecase/fetch_stories_usecase.dart';
import 'package:gerena/features/stories/domain/usecase/remove_story_usecase.dart';
import 'package:gerena/features/stories/domain/usecase/set_story_as_seen_usecase.dart';
import 'package:get/get.dart';

class StoryController extends GetxController with GetTickerProviderStateMixin {
  final FetchStoriesUsecase fetchStoriesUsecase;
  final AddLikeToStoryUsecase addLikeToStoryUsecase;
  final FetchStoriesByIdUsecase fetchStoriesByIdUsecase;
  final RemoveStoryUsecase removeStoryUsecase;
  final CreateStroryUsecase createStroryUsecase;
  final SetStoryAsSeenUsecase setStoryAsSeenUsecase;
  AuthService authService = AuthService();

  StoryController({
    required this.fetchStoriesUsecase,
    required this.addLikeToStoryUsecase,
    required this.fetchStoriesByIdUsecase,
    required this.removeStoryUsecase,
    required this.createStroryUsecase,
    required this.setStoryAsSeenUsecase
  });

  final RxList<GetStoriesEntity> allStories = <GetStoriesEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool isViewingMyStory = false.obs;

  // ✅ CAMBIO: Ahora es una lista de historias
  final RxList<StoryEntity> myStories = <StoryEntity>[].obs;
  final RxBool isLoadingMyStory = false.obs;
  final RxBool hasMyStory = false.obs;

  // ✅ NUEVO: Índice para navegar entre mis historias
  final RxInt currentMyStoryIndex = 0.obs;

  final RxInt currentUserIndex = 0.obs;
  final RxInt currentStoryIndex = 0.obs;
  final RxBool isCreatingStory = false.obs;

  AnimationController? progressController;
  Animation<double>? progressAnimation;

  GetStoriesEntity? get currentUser =>
      allStories.isNotEmpty ? allStories[currentUserIndex.value] : null;

  StoryEntity? get currentStory => currentUser != null &&
          currentUser!.historias.isNotEmpty
      ? currentUser!.historias[currentStoryIndex.value]
      : null;

  List<StoryEntity> get currentUserStories =>
      currentUser?.historias ?? [];
      
  // ✅ NUEVO: Getter para obtener la historia actual del usuario
  StoryEntity? get currentMyStory => 
      myStories.isNotEmpty && currentMyStoryIndex.value < myStories.length
          ? myStories[currentMyStoryIndex.value]
          : null;
      
  List<GetStoriesEntity> getStoriesForDisplay() {
    return allStories;
  }
  
  bool get isMyStoryActive => isViewingMyStory.value;
  
  StoryEntity? get activeStory {
    if (isViewingMyStory.value) {
      return currentMyStory; // ✅ CAMBIO: Usar currentMyStory
    }
    return currentStory;
  }

  @override
  void onInit() {
    super.onInit();
    fetchStories();
    fetchMyStory();
  }

  @override
  void onClose() {
    progressController?.dispose();
    super.onClose();
  }

  void initializeMyStoryModal(TickerProvider vsync) {
    isViewingMyStory.value = true;
    currentUserIndex.value = -1;
    currentStoryIndex.value = 0;
    currentMyStoryIndex.value = 0; // ✅ NUEVO: Inicializar índice
    _setupProgressController(vsync);
  }

  bool hasUnviewedStories(int index) {
    if (index >= allStories.length) return false;
    final stories = allStories[index].historias;
    return stories.any((story) => !story.yaVista);
  }

  String? getUserProfileImage(int index) {
    if (index >= allStories.length) return null;
    return allStories[index].fotoPerfilUrl;
  }

  String? getUserName(int index) {
    if (index >= allStories.length) return null;
    return allStories[index].nombreDoctor;
  }

  String get activeUserName {
    if (isViewingMyStory.value) {
      return "Mi historia";
    }
    return currentUser?.nombreDoctor ?? "";
  }

  String get activeUserImage {
    if (isViewingMyStory.value) {
      return "";
    }
    return currentUser?.fotoPerfilUrl ?? "";
  }

  void closeStoryModal() {
    isViewingMyStory.value = false;
    progressController?.dispose();
    Get.back();
  }

  Future<void> fetchStories() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final stories = await fetchStoriesUsecase.execute();
      allStories.value = stories;
      
      isLoading.value = false;
    } catch (e) {
      error.value = e.toString();
      isLoading.value = false;
    }
  }

  Future<void> createStory(File file, String contentType) async {
    try {
      isCreatingStory.value = true;

      final filePath = file.path;

      final entity = PostStoriesEntity(
        contentType: contentType,
        file: filePath,
      );

      await createStroryUsecase.execute(entity);

      await fetchMyStory();
      await fetchStories();

      isCreatingStory.value = false;
      showSuccessSnackbar('Historia creada exitosamente');
      Get.back();
    } catch (e) {
      isCreatingStory.value = false;
      showErrorSnackbar('No se pudo crear la historia $e');
    }
  }

  // ✅ CAMBIO: Ahora carga una lista de historias
  Future<void> fetchMyStory() async {
    try {
      isLoadingMyStory.value = true;
      final userId = await authService.getUsuarioId();
      
      if (userId == null) {
        isLoadingMyStory.value = false;
        hasMyStory.value = false;
        myStories.clear();
        return;
      }

      final stories = await fetchStoriesByIdUsecase.execute(userId);
      myStories.value = stories;
      hasMyStory.value = stories.isNotEmpty;
      isLoadingMyStory.value = false;
    } catch (e) {
      myStories.clear();
      hasMyStory.value = false;
      isLoadingMyStory.value = false;
    }
  }

  String getContentType(String filePath) {
    final extension = filePath.toLowerCase().split('.').last;
    
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(extension)) {
      return 'imagen';
    }
    
    if (['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv', 'webm', '3gp'].contains(extension)) {
      return 'video';
    }
    
    return 'imagen';
  }

  // ✅ CAMBIO: Eliminar historia específica de mi lista
  Future<void> deleteMyStory() async {
    if (currentMyStory == null) return;

    try {
      await removeStoryUsecase.execute(currentMyStory!.id);
      
      // Eliminar de la lista local
      myStories.removeAt(currentMyStoryIndex.value);
      
      // Si no quedan más historias
      if (myStories.isEmpty) {
        hasMyStory.value = false;
        Get.back(); // Cerrar modal
      } else {
        // Si había más historias, ajustar el índice
        if (currentMyStoryIndex.value >= myStories.length) {
          currentMyStoryIndex.value = myStories.length - 1;
        }
        // Reiniciar el progreso
        progressController?.reset();
        progressController?.forward();
      }
      
      showSuccessSnackbar('Historia eliminada correctamente');
      await fetchStories();
    } catch (e) {
      showErrorSnackbar('No se pudo eliminar la historia');
    }
  }

  void initializeStoryModal(int userIndex, TickerProvider vsync) {
    currentUserIndex.value = userIndex;
    currentStoryIndex.value = 0;
    _setupProgressController(vsync);
    
    _markCurrentStoryAsSeen();
  }

  void _setupProgressController(TickerProvider vsync) {
    progressController?.dispose();
    
    progressController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: vsync,
    );

    progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: progressController!,
      curve: Curves.linear,
    ));

    progressController!.forward();

    progressController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (isViewingMyStory.value) {
          // ✅ CAMBIO: Navegar entre mis historias
          _nextMyStory();
        } else {
          nextStory();
        }
      }
    });
  }

  // ✅ NUEVO: Navegar a la siguiente historia mía
  void _nextMyStory() {
    if (currentMyStoryIndex.value + 1 < myStories.length) {
      currentMyStoryIndex.value++;
      progressController?.reset();
      progressController?.forward();
    } else {
      // Ya terminé todas mis historias, ir a la primera de otros
      goToFirstUserStory();
    }
  }

  // ✅ NUEVO: Navegar a la historia anterior mía
  void _previousMyStory() {
    if (currentMyStoryIndex.value > 0) {
      currentMyStoryIndex.value--;
      progressController?.reset();
      progressController?.forward();
    }
  }

  void goToFirstUserStory() {
    if (allStories.isNotEmpty) {
      isViewingMyStory.value = false;
      currentUserIndex.value = 0;
      currentStoryIndex.value = 0;
      progressController?.reset();
      progressController?.forward();
      
      _markCurrentStoryAsSeen();
    } else {
      Get.back();
    }
  }

  void nextStory() {
    if (currentStoryIndex.value + 1 < currentUserStories.length) {
      currentStoryIndex.value++;
      progressController?.reset();
      progressController?.forward();
      
      _markCurrentStoryAsSeen();
    } else {
      if (currentUserIndex.value + 1 < allStories.length) {
        currentUserIndex.value++;
        currentStoryIndex.value = 0;
        progressController?.reset();
        progressController?.forward();
        
        _markCurrentStoryAsSeen();
      } else {
        Get.back();
      }
    }
  }

  // ✅ CAMBIO: Manejar navegación hacia atrás incluyendo mis historias
  void previousStory() {
    if (isViewingMyStory.value) {
      // Si estoy en mi primera historia, no hacer nada
      if (currentMyStoryIndex.value == 0) {
        return;
      }
      // Si no, ir a mi historia anterior
      _previousMyStory();
    } else if (currentUserIndex.value == 0 && currentStoryIndex.value == 0 && hasMyStory.value) {
      // Si estoy en la primera historia del primer usuario y tengo historias propias
      isViewingMyStory.value = true;
      currentUserIndex.value = -1;
      currentStoryIndex.value = 0;
      currentMyStoryIndex.value = myStories.length - 1; // ✅ Ir a mi última historia
      progressController?.reset();
      progressController?.forward();
    } else if (currentStoryIndex.value > 0) {
      currentStoryIndex.value--;
      progressController?.reset();
      progressController?.forward();
    } else if (currentUserIndex.value > 0) {
      currentUserIndex.value--;
      final previousUserStories = allStories[currentUserIndex.value].historias;
      currentStoryIndex.value = previousUserStories.length - 1;
      progressController?.reset();
      progressController?.forward();
    }
  }

  Future<void> _markCurrentStoryAsSeen() async {
    if (isViewingMyStory.value) return;
    if (currentStory == null) return;
    if (currentStory!.yaVista) return;

    try {
      await setStoryAsSeenUsecase.execute(currentStory!.id);
      
      final userIndex = currentUserIndex.value;
      final storyIndex = currentStoryIndex.value;
      
      final updatedStory = StoryEntity(
        id: currentStory!.id,
        tipoContenido: currentStory!.tipoContenido,
        urlContenido: currentStory!.urlContenido,
        fechaCreacion: currentStory!.fechaCreacion,
        fechaExpiracion: currentStory!.fechaExpiracion,
        vistas: currentStory!.vistas + 1,
        likes: currentStory!.likes,
        yaVista: true,
        yaLikeada: currentStory!.yaLikeada,
      );

      final updatedStories = List<StoryEntity>.from(currentUserStories);
      updatedStories[storyIndex] = updatedStory;

      final updatedUser = GetStoriesEntity(
        doctorId: currentUser!.doctorId,
        nombreDoctor: currentUser!.nombreDoctor,
        fotoPerfilUrl: currentUser!.fotoPerfilUrl,
        historias: updatedStories,
      );

      final updatedAllStories = List<GetStoriesEntity>.from(allStories);
      updatedAllStories[userIndex] = updatedUser;
      allStories.value = updatedAllStories;
    } catch (e) {
      debugPrint('Error marking story as seen: $e');
    }
  }

  void pauseStory() {
    progressController?.stop();
  }

  void resumeStory() {
    progressController?.forward();
  }

  // ✅ CAMBIO: Progreso para mis historias
  double getMyStoryProgress() {
    if (isViewingMyStory.value) {
      return progressAnimation?.value ?? 0.0;
    }
    return 0.0;
  }

  // ✅ NUEVO: Progreso individual para cada una de mis historias
  double getMyStoryProgressAt(int index) {
    if (!isViewingMyStory.value) return 0.0;
    
    if (index < currentMyStoryIndex.value) {
      return 1.0; // Ya vista
    } else if (index == currentMyStoryIndex.value) {
      return progressAnimation?.value ?? 0.0; // Actual
    } else {
      return 0.0; // No vista aún
    }
  }

  Future<void> likeStory() async {
    if (currentStory == null) return;

    try {
      await addLikeToStoryUsecase.execute(currentStory!.id);
      
      final userIndex = currentUserIndex.value;
      final storyIndex = currentStoryIndex.value;
      
      final updatedStory = StoryEntity(
        id: currentStory!.id,
        tipoContenido: currentStory!.tipoContenido,
        urlContenido: currentStory!.urlContenido,
        fechaCreacion: currentStory!.fechaCreacion,
        fechaExpiracion: currentStory!.fechaExpiracion,
        vistas: currentStory!.vistas,
        likes: currentStory!.likes + 1,
        yaVista: currentStory!.yaVista,
        yaLikeada: true,
      );
      final updatedStories = List<StoryEntity>.from(currentUserStories);
      updatedStories[storyIndex] = updatedStory;

      final updatedUser = GetStoriesEntity(
        doctorId: currentUser!.doctorId,
        nombreDoctor: currentUser!.nombreDoctor,
        fotoPerfilUrl: currentUser!.fotoPerfilUrl,
        historias: updatedStories,
      );

      final updatedAllStories = List<GetStoriesEntity>.from(allStories);
      updatedAllStories[userIndex] = updatedUser;
      allStories.value = updatedAllStories;
      showSuccessSnackbar('Te gusta la historia de ${currentUser!.nombreDoctor} ❤️');
    
    } catch (e) {
      showErrorSnackbar('No se pudo dar like a la historia');
    }
  }

  double getStoryProgress(int index) {
    if (index < currentStoryIndex.value) {
      return 1.0;
    } else if (index == currentStoryIndex.value) {
      return progressAnimation?.value ?? 0.0;
    } else {
      return 0.0;
    }
  }

  bool hasStories(int index) {
    return index < allStories.length && allStories[index].historias.isNotEmpty;
  }

  bool hasViewedAllStories(int index) {
    if (index >= allStories.length) return false;
    final stories = allStories[index].historias;
    return stories.every((story) => story.yaVista);
  }
}