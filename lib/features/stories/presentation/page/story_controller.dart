import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:video_player/video_player.dart';

class StoryController extends GetxController with GetTickerProviderStateMixin {
  final FetchStoriesUsecase fetchStoriesUsecase;
  final AddLikeToStoryUsecase addLikeToStoryUsecase;
  final FetchStoriesByIdUsecase fetchStoriesByIdUsecase;
  final RemoveStoryUsecase removeStoryUsecase;
  final CreateStroryUsecase createStroryUsecase;
  final SetStoryAsSeenUsecase setStoryAsSeenUsecase;
  AuthService authService = AuthService();

  // ── Flag para evitar operaciones post-dispose ──
  bool _isDisposing = false;

  final RxBool isModalActive = false.obs;

  StoryController({
    required this.fetchStoriesUsecase,
    required this.addLikeToStoryUsecase,
    required this.fetchStoriesByIdUsecase,
    required this.removeStoryUsecase,
    required this.createStroryUsecase,
    required this.setStoryAsSeenUsecase,
  });

  final RxList<GetStoriesEntity> allStories = <GetStoriesEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool isViewingMyStory = false.obs;

  final RxList<StoryEntity> myStories = <StoryEntity>[].obs;
  final RxBool isLoadingMyStory = false.obs;
  final RxBool hasMyStory = false.obs;

  final RxInt currentMyStoryIndex = 0.obs;
  final RxInt currentUserIndex = 0.obs;
  final RxInt currentStoryIndex = 0.obs;
  final RxBool isCreatingStory = false.obs;

  // ── Video actual ────────────────────────────
  // ✅ Rx para que la UI reaccione cuando cambia el controller
  final Rx<VideoPlayerController?> videoControllerRx =
      Rx<VideoPlayerController?>(null);

  VideoPlayerController? get videoController => videoControllerRx.value;
  set videoController(VideoPlayerController? v) => videoControllerRx.value = v;

  final RxBool isVideoInitialized = false.obs;

  // ── Cache de videos precargados ─────────────
  final Map<String, VideoPlayerController> _videoCache = {};
  final Set<String> _initializingUrls = {};

  // ── Progreso ────────────────────────────────
  AnimationController? progressController;
  Animation<double>? progressAnimation;

  // ── Flag de carga del contenido actual ──────
  final RxBool isContentLoading = false.obs;

  static const Duration _defaultImageDuration = Duration(seconds: 5);
  static const int _preloadAhead = 2;

  // ── Getters ─────────────────────────────────

  GetStoriesEntity? get currentUser =>
      allStories.isNotEmpty && currentUserIndex.value >= 0
          ? allStories[currentUserIndex.value]
          : null;

  StoryEntity? get currentStory {
    if (!isModalActive.value) return null;
    if (currentUser == null || currentUser!.historias.isEmpty) return null;
    if (currentStoryIndex.value >= currentUser!.historias.length) return null;
    return currentUser!.historias[currentStoryIndex.value];
  }

  StoryEntity? get currentMyStory {
    if (!isModalActive.value) return null;
    if (myStories.isEmpty) return null;
    if (currentMyStoryIndex.value >= myStories.length) return null;
    return myStories[currentMyStoryIndex.value];
  }

  List<StoryEntity> get currentUserStories {
    if (!isModalActive.value) return [];
    return currentUser?.historias ?? [];
  }

  List<GetStoriesEntity> getStoriesForDisplay() => allStories;
  bool get isMyStoryActive => isViewingMyStory.value;
  StoryEntity? get activeStory =>
      isViewingMyStory.value ? currentMyStory : currentStory;

  // ── Lifecycle ───────────────────────────────

  @override
  void onInit() {
    super.onInit();
    fetchStories();
    fetchMyStory();
  }

  @override
  void onClose() {
    progressController?.dispose();
    _disposeAllCachedVideos();
    videoControllerRx.value?.dispose();
    super.onClose();
  }

  // ────────────────────────────────────────────
  // Inicialización del modal
  // ────────────────────────────────────────────

  void initializeMyStoryModal(TickerProvider vsync) {
    _isDisposing = false;
    isModalActive.value = true;
    isViewingMyStory.value = true;
    currentUserIndex.value = -1;
    currentStoryIndex.value = 0;
    currentMyStoryIndex.value = 0;
    _setupProgressController(vsync);
    _loadCurrentContent();
  }

  void initializeStoryModal(int userIndex, TickerProvider vsync) {
    _isDisposing = false;
    isModalActive.value = true;
    isViewingMyStory.value = false;
    currentUserIndex.value = userIndex;
    currentStoryIndex.value = 0;
    _setupProgressController(vsync);
    _loadCurrentContent();
    _markCurrentStoryAsSeen();
  }

  // ────────────────────────────────────────────
  // Carga del contenido actual
  // ────────────────────────────────────────────

  Future<void> _loadCurrentContent() async {
    if (_isDisposing || !isModalActive.value) return;

    final story = isViewingMyStory.value ? currentMyStory : currentStory;
    if (story == null) return;

    _stopProgress();
    isContentLoading.value = true;

    final isVideo = story.tipoContenido.toLowerCase() == 'video';

    if (isVideo) {
      await _showVideo(story.urlContenido);
    } else {
      await _warmupImage(story.urlContenido);
      if (_isDisposing || !isModalActive.value) return;
      isContentLoading.value = false;
      _startProgress(_defaultImageDuration);
    }

    _preloadNextStories();
  }

  // ────────────────────────────────────────────
  // Precarga en background
  // ────────────────────────────────────────────

  void _preloadNextStories() {
    if (_isDisposing) return;
    final upcoming = _getUpcomingStories(_preloadAhead);
    for (final story in upcoming) {
      final url = story.urlContenido;
      final isVideo = story.tipoContenido.toLowerCase() == 'video';
      if (isVideo) {
        if (!_videoCache.containsKey(url) &&
            !_initializingUrls.contains(url)) {
          _preloadVideoInBackground(url);
        }
      } else {
        _preloadImageInBackground(url);
      }
    }
  }

  List<StoryEntity> _getUpcomingStories(int count) {
    final result = <StoryEntity>[];

    if (isViewingMyStory.value) {
      for (int i = 1; i <= count; i++) {
        final idx = currentMyStoryIndex.value + i;
        if (idx < myStories.length) result.add(myStories[idx]);
      }
    } else {
      int storyIdx = currentStoryIndex.value + 1;
      int userIdx = currentUserIndex.value;

      while (result.length < count) {
        if (userIdx >= allStories.length) break;
        final stories = allStories[userIdx].historias;

        if (storyIdx < stories.length) {
          result.add(stories[storyIdx]);
          storyIdx++;
        } else {
          userIdx++;
          storyIdx = 0;
        }
      }
    }

    return result;
  }

  Future<void> _preloadVideoInBackground(String url) async {
    _initializingUrls.add(url);
    debugPrint('⏬ [Preload] Video: $url');

    try {
      final ctrl = VideoPlayerController.networkUrl(Uri.parse(url));
      await ctrl.initialize();

      if (_isDisposing || !isModalActive.value) {
        ctrl.dispose();
        _initializingUrls.remove(url);
        return;
      }

      ctrl.setLooping(true);
      _videoCache[url] = ctrl;
      _initializingUrls.remove(url);
      debugPrint('✅ [Preload] Video listo: $url');
    } catch (e) {
      _initializingUrls.remove(url);
      debugPrint('⚠️ [Preload] Error video: $e');
    }
  }

  void _preloadImageInBackground(String url) {
    try {
      CachedNetworkImageProvider(url).resolve(const ImageConfiguration());
    } catch (_) {}
  }

  Future<void> _warmupImage(String url) async {
    try {
      CachedNetworkImageProvider(url).resolve(const ImageConfiguration());
      await Future.delayed(const Duration(milliseconds: 150));
    } catch (_) {}
  }

  // ────────────────────────────────────────────
  // Mostrar video (cache-first)
  // ────────────────────────────────────────────

  Future<void> _showVideo(String url) async {
    try {
      // 1. Cache hit → instantáneo
      if (_videoCache.containsKey(url)) {
        debugPrint('⚡ [Cache hit] Video: $url');

        await _disposeVideoController();
        if (_isDisposing || !isModalActive.value) return;

        final cached = _videoCache.remove(url)!;
        await cached.seekTo(Duration.zero);
        if (_isDisposing || !isModalActive.value) {
          cached.dispose();
          return;
        }
        await cached.play();
        if (_isDisposing || !isModalActive.value) {
          cached.pause();
          cached.dispose();
          return;
        }

        // ✅ Asignar al Rx para que la UI reaccione
        videoControllerRx.value = cached;
        isVideoInitialized.value = true;
        isContentLoading.value = false;

        final dur = cached.value.duration;
        _startProgress(
            dur.inMilliseconds > 0 ? dur : _defaultImageDuration);
        return;
      }

      // 2. Siendo precargado → esperar hasta 3s
      if (_initializingUrls.contains(url)) {
        debugPrint('⏳ [Preload] Esperando: $url');
        for (int i = 0; i < 15; i++) {
          await Future.delayed(const Duration(milliseconds: 200));
          if (_isDisposing || !isModalActive.value) return;
          if (_videoCache.containsKey(url)) {
            await _showVideo(url);
            return;
          }
        }
        debugPrint('⏱️ Timeout, inicializando desde cero: $url');
      }

      // 3. Sin cache → inicializar normal
      await _initializeVideo(url);
    } catch (e) {
      debugPrint('💥 _showVideo error: $e');
      if (!_isDisposing) {
        isContentLoading.value = false;
        _startProgress(_defaultImageDuration);
      }
    }
  }

  Future<void> _initializeVideo(String videoUrl) async {
    try {
      await _disposeVideoController();
      if (_isDisposing || !isModalActive.value) return;

      final ctrl =
          VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await ctrl.initialize();

      if (_isDisposing || !isModalActive.value) {
        ctrl.dispose();
        return;
      }

      ctrl.setLooping(true);
      await ctrl.play();

      if (_isDisposing || !isModalActive.value) {
        ctrl.pause();
        ctrl.dispose();
        return;
      }

      // ✅ Asignar al Rx para que la UI reaccione
      videoControllerRx.value = ctrl;
      isVideoInitialized.value = true;
      isContentLoading.value = false;

      final dur = ctrl.value.duration;
      _startProgress(
          dur.inMilliseconds > 0 ? dur : _defaultImageDuration);
    } catch (e) {
      debugPrint('Error initializing video: $e');
      if (!_isDisposing) {
        isContentLoading.value = false;
        _startProgress(_defaultImageDuration);
      }
    }
  }

  // ────────────────────────────────────────────
  // Progress controller
  // ────────────────────────────────────────────

  void _setupProgressController(TickerProvider vsync) {
    progressController?.stop();
    progressController?.dispose();
    progressController = null;
    progressAnimation = null;

    progressController = AnimationController(
      duration: _defaultImageDuration,
      vsync: vsync,
    );

    progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: progressController!, curve: Curves.linear),
    );

    progressController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_isDisposing || !isModalActive.value) return;
        if (isViewingMyStory.value) {
          nextMyStory();
        } else {
          nextStory();
        }
      }
    });
  }

  void _startProgress(Duration duration) {
    if (progressController == null) return;
    if (_isDisposing || !isModalActive.value) return;
    progressController!.stop();
    progressController!.duration = duration;
    progressController!.reset();
    progressController!.forward();
  }

  void _stopProgress() {
    progressController?.stop();
  }

  // ────────────────────────────────────────────
  // Pause / Resume
  // ────────────────────────────────────────────

  void pauseStory() {
    if (isContentLoading.value) return;
    progressController?.stop();
    videoControllerRx.value?.pause();
  }

  void resumeStory() {
    if (isContentLoading.value) return;
    progressController?.forward();
    videoControllerRx.value?.play();
  }

  // ────────────────────────────────────────────
  // Navegación
  // ────────────────────────────────────────────

  void nextMyStory() async {
    if (_isDisposing || !isModalActive.value) return;

    if (currentMyStoryIndex.value + 1 < myStories.length) {
      currentMyStoryIndex.value++;
      await _disposeVideoController();
      await _loadCurrentContent();
    } else {
      goToFirstUserStory();
    }
  }

  void previousMyStory() async {
    if (_isDisposing || !isModalActive.value) return;

    if (currentMyStoryIndex.value > 0) {
      currentMyStoryIndex.value--;
      await _disposeVideoController();
      await _loadCurrentContent();
    }
  }

  void goToFirstUserStory() {
    if (_isDisposing || !isModalActive.value) return;

    if (allStories.isNotEmpty) {
      isViewingMyStory.value = false;
      currentUserIndex.value = 0;
      currentStoryIndex.value = 0;
      _loadCurrentContent();
      _markCurrentStoryAsSeen();
    } else {
      _disposeVideoController();
      if (isModalActive.value) Get.back();
    }
  }

  void nextStory() async {
    if (_isDisposing || !isModalActive.value) return;

    if (currentStoryIndex.value + 1 < currentUserStories.length) {
      currentStoryIndex.value++;
      await _disposeVideoController();
      await _loadCurrentContent();
      _markCurrentStoryAsSeen();
    } else if (currentUserIndex.value + 1 < allStories.length) {
      currentUserIndex.value++;
      currentStoryIndex.value = 0;
      await _disposeVideoController();
      await _loadCurrentContent();
      _markCurrentStoryAsSeen();
    } else {
      await _disposeVideoController();
      if (!_isDisposing && isModalActive.value) Get.back();
    }
  }

  void previousStory() async {
    if (_isDisposing || !isModalActive.value) return;

    if (isViewingMyStory.value) {
      if (currentMyStoryIndex.value == 0) return;
      previousMyStory();
    } else if (currentUserIndex.value == 0 &&
        currentStoryIndex.value == 0 &&
        hasMyStory.value) {
      isViewingMyStory.value = true;
      currentUserIndex.value = -1;
      currentStoryIndex.value = 0;
      currentMyStoryIndex.value = myStories.length - 1;
      await _disposeVideoController();
      await _loadCurrentContent();
    } else if (currentStoryIndex.value > 0) {
      currentStoryIndex.value--;
      await _disposeVideoController();
      await _loadCurrentContent();
    } else if (currentUserIndex.value > 0) {
      currentUserIndex.value--;
      final prevStories = allStories[currentUserIndex.value].historias;
      currentStoryIndex.value = prevStories.length - 1;
      await _disposeVideoController();
      await _loadCurrentContent();
    }
  }

  // ────────────────────────────────────────────
  // Video helpers
  // ────────────────────────────────────────────

  Future<void> _disposeVideoController() async {
    final ctrl = videoControllerRx.value;
    if (ctrl != null) {
      videoControllerRx.value = null; // ✅ limpiar Rx primero
      isVideoInitialized.value = false;
      try {
        await ctrl.pause();
        await ctrl.dispose();
      } catch (_) {}
    } else {
      isVideoInitialized.value = false;
    }
  }

  void disposeVideo() {
    final ctrl = videoControllerRx.value;
    videoControllerRx.value = null;
    isVideoInitialized.value = false;
    ctrl?.pause();
    ctrl?.dispose();
  }

  void _disposeAllCachedVideos() {
    for (final ctrl in _videoCache.values) {
      try {
        ctrl.dispose();
      } catch (_) {}
    }
    _videoCache.clear();
    _initializingUrls.clear();
  }

  // ────────────────────────────────────────────
  // Dispose modal
  // ────────────────────────────────────────────

  void disposeStoryModal() {
    if (_isDisposing) return; // evitar doble dispose
    _isDisposing = true;
    isModalActive.value = false;

    final ctrl = videoControllerRx.value;
    videoControllerRx.value = null;
    isVideoInitialized.value = false;
    isContentLoading.value = false;

    try {
      ctrl?.pause();
      ctrl?.dispose();
    } catch (_) {}

    _disposeAllCachedVideos();

    progressController?.stop();
    progressController?.dispose();
    progressController = null;
    progressAnimation = null;

    isViewingMyStory.value = false;
    currentStoryIndex.value = 0;
    currentMyStoryIndex.value = 0;
    currentUserIndex.value = 0;
  }

  void closeStoryModal() {
    disposeStoryModal();
    Get.back();
  }

  // ────────────────────────────────────────────
  // Progress getters para la UI
  // ────────────────────────────────────────────

  double getStoryProgress(int index) {
    if (index < currentStoryIndex.value) return 1.0;
    if (index == currentStoryIndex.value) {
      if (isContentLoading.value) return 0.0;
      return progressAnimation?.value ?? 0.0;
    }
    return 0.0;
  }

  double getMyStoryProgressAt(int index) {
    if (!isViewingMyStory.value) return 0.0;
    if (index < currentMyStoryIndex.value) return 1.0;
    if (index == currentMyStoryIndex.value) {
      if (isContentLoading.value) return 0.0;
      return progressAnimation?.value ?? 0.0;
    }
    return 0.0;
  }

  // ────────────────────────────────────────────
  // Fetch / CRUD
  // ────────────────────────────────────────────

  Future<void> fetchStories() async {
    try {
      isLoading.value = true;
      error.value = '';

      final stories = await fetchStoriesUsecase.execute();

      final sortedStories = stories.map((userStory) {
        return GetStoriesEntity(
          doctorId: userStory.doctorId,
          nombreDoctor: userStory.nombreDoctor,
          fotoPerfilUrl: userStory.fotoPerfilUrl,
          historias: _sortStoriesByDate(userStory.historias),
        );
      }).toList();

      allStories.value = sortedStories;
      isLoading.value = false;
    } catch (e) {
      error.value = e.toString();
      isLoading.value = false;
    }
  }

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
      myStories.value = _sortStoriesByDate(stories);
      hasMyStory.value = stories.isNotEmpty;
      isLoadingMyStory.value = false;
    } catch (e) {
      myStories.clear();
      hasMyStory.value = false;
      isLoadingMyStory.value = false;
    }
  }

  Future<void> createStory(File file, String contentType) async {
    try {
      isCreatingStory.value = true;

      final entity = PostStoriesEntity(
        contentType: contentType,
        file: file.path,
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

  Future<void> deleteMyStory() async {
    if (currentMyStory == null) return;

    try {
      await removeStoryUsecase.execute(currentMyStory!.id);
      myStories.removeAt(currentMyStoryIndex.value);

      if (myStories.isEmpty) {
        hasMyStory.value = false;
        disposeVideo();
        Get.back();
      } else {
        if (currentMyStoryIndex.value >= myStories.length) {
          currentMyStoryIndex.value = myStories.length - 1;
        }
        await _disposeVideoController();
        await _loadCurrentContent();
      }

      showSuccessSnackbar('Historia eliminada correctamente');
      await fetchStories();
    } catch (e) {
      showErrorSnackbar('No se pudo eliminar la historia');
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
    } catch (e) {
      showErrorSnackbar('No se pudo dar like a la historia');
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

  // ────────────────────────────────────────────
  // Helpers
  // ────────────────────────────────────────────

  List<StoryEntity> _sortStoriesByDate(List<StoryEntity> stories) {
    final sorted = List<StoryEntity>.from(stories);
    sorted.sort((a, b) {
      try {
        return a.fechaCreacion.compareTo(b.fechaCreacion);
      } catch (_) {
        return 0;
      }
    });
    return sorted;
  }

  String getTimeAgo(DateTime fechaCreacion) {
    try {
      final diff = DateTime.now().difference(fechaCreacion);
      if (diff.inDays > 0) return '${diff.inDays}d';
      if (diff.inHours > 0) return '${diff.inHours}h';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m';
      return 'Ahora';
    } catch (_) {
      return '';
    }
  }

  String getContentType(String filePath) {
    final ext = filePath.toLowerCase().split('.').last;
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext)) {
      return 'imagen';
    }
    if (['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv', 'webm', '3gp']
        .contains(ext)) {
      return 'video';
    }
    return 'imagen';
  }

  bool hasStories(int index) =>
      index < allStories.length && allStories[index].historias.isNotEmpty;

  bool hasViewedAllStories(int index) {
    if (index >= allStories.length) return false;
    return allStories[index].historias.every((s) => s.yaVista);
  }

  bool hasUnviewedStories(int index) {
    if (index >= allStories.length) return false;
    return allStories[index].historias.any((s) => !s.yaVista);
  }

  String? getUserProfileImage(int index) {
    if (index >= allStories.length) return null;
    return allStories[index].fotoPerfilUrl;
  }

  String? getUserName(int index) {
    if (index >= allStories.length) return null;
    return allStories[index].nombreDoctor;
  }

  String get activeUserName =>
      isViewingMyStory.value ? 'Mi historia' : currentUser?.nombreDoctor ?? '';

  String get activeUserImage =>
      isViewingMyStory.value ? '' : currentUser?.fotoPerfilUrl ?? '';
}