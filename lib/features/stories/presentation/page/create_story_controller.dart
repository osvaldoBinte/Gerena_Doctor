import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class CreateStoryController extends GetxController {
  // Camera
  Rx<CameraController?> cameraController = Rx<CameraController?>(null);
  final RxList<CameraDescription> cameras = <CameraDescription>[].obs;
  final RxBool isCameraInitialized = false.obs;
  final RxBool isFrontCamera = false.obs;

  // Recording
  final RxBool isRecording = false.obs;
  final RxInt recordingSeconds = 0.obs;
  Timer? recordingTimer;
  static const int maxRecordingSeconds = 30;

  // Captured content
  final Rx<File?> capturedFile = Rx<File?>(null);
  final Rx<String?> contentType = Rx<String?>(null);
  VideoPlayerController? videoController;
  
  // ✅ NUEVO: Flag para saber si el video está listo
  final RxBool isVideoReady = false.obs;

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
    cameraController.value?.dispose();
    videoController?.dispose();
    recordingTimer?.cancel();
    super.onClose();
  }

  // Inicializar cámara con orientación correcta
  Future<void> initializeCamera() async {
    try {
      isCameraInitialized.value = false;
      
      final availableCamerasList = await availableCameras();
      if (availableCamerasList.isEmpty) {
        debugPrint('No cameras available');
        return;
      }

      cameras.value = availableCamerasList;
      final camera = isFrontCamera.value ? cameras.last : cameras.first;

      final newController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await newController.initialize();
      
      // Bloquear orientación a portrait
      await newController.lockCaptureOrientation(DeviceOrientation.portraitUp);
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      if (newController.value.isInitialized) {
        cameraController.value = newController;
        
        await Future.delayed(const Duration(milliseconds: 50));
        isCameraInitialized.value = true;
        
        debugPrint('Camera initialized successfully');
        debugPrint('Preview size: ${newController.value.previewSize}');
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      isCameraInitialized.value = false;
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
    
    await cameraController.value?.dispose();
    cameraController.value = null;
    
    await initializeCamera();
  }

  // Iniciar grabación
  Future<void> startRecording() async {
    if (cameraController.value == null || !cameraController.value!.value.isInitialized) return;
    if (isRecording.value) return;

    try {
      await cameraController.value!.startVideoRecording();

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
      final XFile video = await cameraController.value!.stopVideoRecording();

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

      // Inicializar video antes de cambiar a preview
      await initializeVideoController();
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      isRecording.value = false;
    }
  }

  // Tomar foto
  Future<void> takePicture() async {
    if (cameraController.value == null || !cameraController.value!.value.isInitialized) return;

    try {
      final XFile photo = await cameraController.value!.takePicture();

      capturedFile.value = File(photo.path);
      contentType.value = 'imagen';
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  // Inicializar video controller
  Future<void> initializeVideoController() async {
    if (capturedFile.value == null || contentType.value != 'video') return;

    try {
      isVideoReady.value = false; // ✅ Marcar como no listo
      
      videoController?.dispose();
      videoController = VideoPlayerController.file(capturedFile.value!);

      debugPrint('Initializing video: ${capturedFile.value!.path}');
      
      await videoController!.initialize();
      
      // Verificar que se inicializó correctamente
      if (videoController!.value.isInitialized) {
        videoController!.setLooping(true);
        videoController!.play();
        
        isVideoReady.value = true; // ✅ Marcar como listo
        
        debugPrint('Video initialized successfully');
        debugPrint('Duration: ${videoController!.value.duration}');
        debugPrint('Size: ${videoController!.value.size}');
      } else {
        debugPrint('Video failed to initialize');
        isVideoReady.value = false;
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
      // Limpiar si hay error
      videoController?.dispose();
      videoController = null;
      isVideoReady.value = false;
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
        // Inicializar video antes de mostrar preview
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
    isVideoReady.value = false; // ✅ Resetear flag
  }

  // Manejar ciclo de vida
  void handleAppLifecycleState(AppLifecycleState state) {
    if (cameraController.value == null || !cameraController.value!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.value?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initializeCamera();
    }
  }
}