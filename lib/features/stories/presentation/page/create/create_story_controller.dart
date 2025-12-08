import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

// Modelo para textos
class StoryText {
  final String text;
  final Color color;
  Offset position;
  double scale;
  final String id;

  StoryText({
    required this.text,
    required this.color,
    required this.position,
    this.scale = 1.0,
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  StoryText copyWith({
    String? text,
    Color? color,
    Offset? position,
    double? scale,
  }) {
    return StoryText(
      text: text ?? this.text,
      color: color ?? this.color,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      id: id,
    );
  }
}

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
  
  // Video ready flag
  final RxBool isVideoReady = false.obs;

  // Gallery
  final RxList<AssetEntity> galleryAssets = <AssetEntity>[].obs;
  final RxBool isLoadingGallery = false.obs;

  // Textos sobre la historia
  final RxList<StoryText> storyTexts = <StoryText>[].obs;
  final Rx<String?> selectedTextId = Rx<String?>(null);

  // Key para capturar la imagen con textos
  final GlobalKey repaintBoundaryKey = GlobalKey();

  // Flag para indicar si se está procesando el video
  final RxBool isProcessingVideo = false.obs;

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

  // Agregar texto
  void addText(String text, Color color, Offset position, double scale) {
    final newText = StoryText(
      text: text,
      color: color,
      position: position,
      scale: scale,
    );
    storyTexts.add(newText);
  }

  // Actualizar posición de texto
  void updateTextPosition(String textId, Offset newPosition) {
    final index = storyTexts.indexWhere((t) => t.id == textId);
    if (index != -1) {
      storyTexts[index].position = newPosition;
      storyTexts.refresh();
    }
  }

  // Actualizar escala de texto
  void updateTextScale(String textId, double newScale) {
    final index = storyTexts.indexWhere((t) => t.id == textId);
    if (index != -1) {
      storyTexts[index].scale = newScale;
      storyTexts.refresh();
    }
  }

  // Eliminar texto
  void removeText(String textId) {
    storyTexts.removeWhere((t) => t.id == textId);
  }

  // Seleccionar texto
  void selectText(String? textId) {
    selectedTextId.value = textId;
  }

  // Capturar imagen con textos
  Future<File?> captureStoryWithTexts() async {
    try {
      // Si no hay textos, devolver el archivo original
      if (storyTexts.isEmpty) {
        return capturedFile.value;
      }

      // Para videos, usar FFmpeg
      if (contentType.value == 'video') {
        return await processVideoWithTexts();
      }

      // Para imágenes, capturar el RepaintBoundary
      await Future.delayed(const Duration(milliseconds: 100));

      RenderRepaintBoundary? boundary = repaintBoundaryKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint('RepaintBoundary not found');
        return capturedFile.value;
      }

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) {
        debugPrint('Failed to convert image to bytes');
        return capturedFile.value;
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imagePath = '${directory.path}/story_with_text_$timestamp.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(pngBytes);

      debugPrint('Story with texts saved: $imagePath');
      return imageFile;
    } catch (e) {
      debugPrint('Error capturing story with texts: $e');
      return capturedFile.value;
    }
  }

  // ✅ SOLUCIÓN FINAL: Procesar video con FUENTE especificada
  Future<File?> processVideoWithTexts() async {
    if (capturedFile.value == null || storyTexts.isEmpty) {
      debugPrint('❌ No file or no texts to process');
      return capturedFile.value;
    }

    try {
      isProcessingVideo.value = true;
      debugPrint('🎬 Starting video processing with ${storyTexts.length} texts');

      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final outputPath = '${directory.path}/story_video_$timestamp.mp4';

      // Obtener resolución real del video
      double videoWidth = 1080;
      double videoHeight = 1920;
      
      if (videoController != null && videoController!.value.isInitialized) {
        videoWidth = videoController!.value.size.width;
        videoHeight = videoController!.value.size.height;
        debugPrint('📐 Video resolution: ${videoWidth}x$videoHeight');
      }

      // ✅ CLAVE: Especificar fuente de Android
      const fontPath = '/system/fonts/Roboto-Regular.ttf';
      
      // Construir filtros de texto
      List<String> textFilters = [];
      
      for (int i = 0; i < storyTexts.length; i++) {
        final storyText = storyTexts[i];
        
        // Calcular posición en píxeles
        final xPos = (storyText.position.dx * videoWidth).toInt();
        final yPos = (storyText.position.dy * videoHeight).toInt();
        
        // Convertir color a formato FFmpeg (RRGGBB sin alpha)
        final colorHex = storyText.color.value.toRadixString(16).padLeft(8, '0').substring(2);
        
        // Calcular tamaño de fuente
        final baseFontSize = (videoHeight / 1920) * 28;
        final fontSize = (baseFontSize * storyText.scale).toInt();
        
        // Limpiar el texto
        String cleanText = storyText.text
            .replaceAll('\\', '')
            .replaceAll("'", '')
            .replaceAll('"', '')
            .replaceAll(':', ' ')
            .replaceAll('%', ' ')
            .trim();
        
        debugPrint('📝 Text $i: "$cleanText" at ($xPos, $yPos) size:$fontSize color:$colorHex');
        
        // ✅ Filtro CON fuente especificada
        final filter = "drawtext="
    "fontfile=$fontPath:"
    "text='$cleanText':"
    "fontsize=$fontSize:"
    "fontcolor=$colorHex:"
    "x=$xPos:"
    "y=$yPos:"
    "shadowcolor=black@0.8:"      // Sombra más fuerte
    "shadowx=2:"                   // Desplazamiento sombra X
    "shadowy=2:"                   // Desplazamiento sombra Y
    "borderw=3:"                   // Borde grueso
    "bordercolor=black@0.9";
        
        textFilters.add(filter);
      }

      // Unir todos los filtros
      final allFilters = textFilters.join(',');
      
      debugPrint('🔧 Filter chain: $allFilters');

      // Comando FFmpeg
      final inputPath = capturedFile.value!.path;
      
      final command = '-i "$inputPath" '
          '-vf "$allFilters" '
          '-c:v libx264 '
          '-preset ultrafast '
          '-c:a copy '
          '-y "$outputPath"';
      
      debugPrint('🚀 Executing FFmpeg');
      debugPrint('   Input: $inputPath');
      debugPrint('   Output: $outputPath');

      // Ejecutar FFmpeg
      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();
      final output = await session.getOutput();

      debugPrint('📊 FFmpeg Return Code: ${returnCode?.getValue()}');
      
      if (ReturnCode.isSuccess(returnCode)) {
        debugPrint('✅ Video processing completed');
        
        final outputFile = File(outputPath);
        if (await outputFile.exists()) {
          final fileSize = await outputFile.length();
          debugPrint('📦 File size: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB');
          
          isProcessingVideo.value = false;
          return outputFile;
        } else {
          debugPrint('❌ Output file not found');
          debugPrint('📋 Output: $output');
          isProcessingVideo.value = false;
          return capturedFile.value;
        }
      } else {
        debugPrint('❌ FFmpeg failed: ${returnCode?.getValue()}');
        debugPrint('📋 Output: $output');
        
        isProcessingVideo.value = false;
        return capturedFile.value;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error: $e');
      debugPrint('📚 Stack: $stackTrace');
      isProcessingVideo.value = false;
      return capturedFile.value;
    }
  }

  // Inicializar cámara
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
      await newController.lockCaptureOrientation(DeviceOrientation.portraitUp);
      await Future.delayed(const Duration(milliseconds: 100));
      
      if (newController.value.isInitialized) {
        cameraController.value = newController;
        await Future.delayed(const Duration(milliseconds: 50));
        isCameraInitialized.value = true;
        
        debugPrint('Camera initialized');
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
      isVideoReady.value = false;
      
      videoController?.dispose();
      videoController = VideoPlayerController.file(capturedFile.value!);

      await videoController!.initialize();
      
      if (videoController!.value.isInitialized) {
        videoController!.setLooping(true);
        videoController!.play();
        
        isVideoReady.value = true;
        
        debugPrint('Video initialized');
        debugPrint('Duration: ${videoController!.value.duration}');
        debugPrint('Size: ${videoController!.value.size}');
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
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
    isVideoReady.value = false;
    storyTexts.clear();
    selectedTextId.value = null;
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