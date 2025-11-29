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

  // Para las historias del usuario actual
  final Rx<StoryEntity?> myStory = Rx<StoryEntity?>(null);
  final RxBool isLoadingMyStory = false.obs;
  final RxBool hasMyStory = false.obs;

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
      
  List<GetStoriesEntity> getStoriesForDisplay() {
    return allStories;
  }
  
  bool get isMyStoryActive => isViewingMyStory.value;
  
  StoryEntity? get activeStory {
    if (isViewingMyStory.value) {
      return myStory.value;
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

  Future<void> fetchMyStory() async {
    try {
      isLoadingMyStory.value = true;
      final userId = await authService.getUsuarioId();
      
      if (userId == null) {
        isLoadingMyStory.value = false;
        hasMyStory.value = false;
        return;
      }

      final story = await fetchStoriesByIdUsecase.execute(userId);
      myStory.value = story;
      hasMyStory.value = true;
      isLoadingMyStory.value = false;
    } catch (e) {
      myStory.value = null;
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

  Future<void> deleteMyStory() async {
    if (myStory.value == null) return;

    try {
      await removeStoryUsecase.execute(myStory.value!.id);
      myStory.value = null;
      hasMyStory.value = false;
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
    
    // Marcar la primera historia como vista
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
          goToFirstUserStory();
        } else {
          nextStory();
        }
      }
    });
  }

  void goToFirstUserStory() {
    if (allStories.isNotEmpty) {
      isViewingMyStory.value = false;
      currentUserIndex.value = 0;
      currentStoryIndex.value = 0;
      progressController?.reset();
      progressController?.forward();
      
      // Marcar como vista la primera historia del primer usuario
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
      
      // Marcar la nueva historia como vista
      _markCurrentStoryAsSeen();
    } else {
      if (currentUserIndex.value + 1 < allStories.length) {
        currentUserIndex.value++;
        currentStoryIndex.value = 0;
        progressController?.reset();
        progressController?.forward();
        
        // Marcar la nueva historia como vista
        _markCurrentStoryAsSeen();
      } else {
        Get.back();
      }
    }
  }

  void previousStory() {
    if (currentUserIndex.value == 0 && currentStoryIndex.value == 0 && myStory.value != null) {
      isViewingMyStory.value = true;
      currentUserIndex.value = -1;
      currentStoryIndex.value = 0;
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

  // Marcar la historia actual como vista
  Future<void> _markCurrentStoryAsSeen() async {
    if (isViewingMyStory.value) return; // No marcar mi propia historia
    if (currentStory == null) return;
    if (currentStory!.yaVista) return; // Ya está vista

    try {
      await setStoryAsSeenUsecase.execute(currentStory!.id);
      
      // Actualizar el estado local
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
        yaVista: true, // Marcar como vista
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

  double getMyStoryProgress() {
    if (isViewingMyStory.value) {
      return progressAnimation?.value ?? 0.0;
    }
    return 0.0;
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