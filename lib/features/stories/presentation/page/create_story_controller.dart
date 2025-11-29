import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class CreateStoryController extends GetxController {
  // Camera
  CameraController? cameraController;
  final RxList<CameraDescription> cameras = <CameraDescription>[].obs;
  final RxBool isCameraInitialized = false.obs;
  final RxBool isFrontCamera = true.obs;

  // Recording
  final RxBool isRecording = false.obs;
  final RxInt recordingSeconds = 0.obs;
  Timer? recordingTimer;
  static const int maxRecordingSeconds = 30;

  // Captured content
  final Rx<File?> capturedFile = Rx<File?>(null);
  final Rx<String?> contentType = Rx<String?>(null);
  VideoPlayerController? videoController;

  // Gallery
  final RxList<AssetEntity> galleryAssets = <AssetEntity>[].obs;
  final RxBool isLoadingGallery = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
    loadGalleryAssets();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    videoController?.dispose();
    recordingTimer?.cancel();
    super.onClose();
  }

  // Inicializar cámara
  Future<void> initializeCamera() async {
    try {
      final availableCameras = await availableCameras();
      if (availableCameras.isEmpty) return;

      cameras.value = availableCameras;
      final camera = isFrontCamera.value ? cameras.last : cameras.first;

      cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  // Cargar assets de galería
  Future<void> loadGalleryAssets() async {
    isLoadingGallery.value = true;

    final PermissionState permission = await PhotoManager.requestPermissionExtend();

    if (permission.isAuth) {
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.common,
        onlyAll: true,
      );

      if (albums.isNotEmpty) {
        final List<AssetEntity> media = await albums[0].getAssetListRange(
          start: 0,
          end: 20,
        );
        galleryAssets.value = media;
      }
    }

    isLoadingGallery.value = false;
  }

  // Cambiar cámara
  Future<void> switchCamera() async {
    if (cameras.length < 2) return;

    isFrontCamera.value = !isFrontCamera.value;
    isCameraInitialized.value = false;

    await cameraController?.dispose();
    await initializeCamera();
  }

  // Iniciar grabación
  Future<void> startRecording() async {
    if (cameraController == null || !cameraController!.value.isInitialized) return;
    if (isRecording.value) return;

    try {
      await cameraController!.startVideoRecording();

      isRecording.value = true;
      recordingSeconds.value = 0;

      recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (recordingSeconds.value >= maxRecordingSeconds) {
          stopRecording();
        } else {
          recordingSeconds.value++;
        }
      });
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  // Detener grabación
  Future<void> stopRecording() async {
    if (!isRecording.value) return;

    try {
      recordingTimer?.cancel();
      final XFile video = await cameraController!.stopVideoRecording();

      // Convertir .temp a .mp4
      final String originalPath = video.path;
      final String mp4Path = originalPath.replaceAll('.temp', '.mp4');

      final File tempFile = File(originalPath);
      final File mp4File = await tempFile.copy(mp4Path);
      await tempFile.delete();

      isRecording.value = false;
      recordingSeconds.value = 0;
      capturedFile.value = mp4File;
      contentType.value = 'video';

      await initializeVideoController();
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  // Tomar foto
  Future<void> takePicture() async {
    if (cameraController == null || !cameraController!.value.isInitialized) return;

    try {
      final XFile photo = await cameraController!.takePicture();

      capturedFile.value = File(photo.path);
      contentType.value = 'imagen';
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  // Inicializar video controller
  Future<void> initializeVideoController() async {
    if (capturedFile.value == null || contentType.value != 'video') return;

    videoController?.dispose();
    videoController = VideoPlayerController.file(capturedFile.value!);

    try {
      await videoController!.initialize();
      videoController!.setLooping(true);
      videoController!.play();
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  // Seleccionar de galería
  Future<void> selectFromGallery(AssetEntity asset) async {
    try {
      final File? file = await asset.file;
      if (file == null) return;

      capturedFile.value = file;
      contentType.value = asset.type == AssetType.image ? 'imagen' : 'video';

      if (contentType.value == 'video') {
        await initializeVideoController();
      }
    } catch (e) {
      debugPrint('Error selecting from gallery: $e');
    }
  }

  // Limpiar captura
  void clearCapture() {
    capturedFile.value = null;
    contentType.value = null;
    videoController?.dispose();
    videoController = null;
  }

  // Manejar ciclo de vida
  void handleAppLifecycleState(AppLifecycleState state) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initializeCamera();
    }
  }
}