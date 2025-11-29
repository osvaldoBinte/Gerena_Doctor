import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/stories/presentation/page/story_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'dart:typed_data'; // Agregar esta línea

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({Key? key}) : super(key: key);

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen>
    with WidgetsBindingObserver {
  final StoryController controller = Get.find<StoryController>();

  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  bool _isFrontCamera = true;

  // Para preview
  File? _capturedFile;
  String? _contentType;
  VideoPlayerController? _videoController;

  // Para galería
  List<AssetEntity> _galleryAssets = [];
  bool _isLoadingGallery = false;

  // Para el timer de grabación
  Timer? _recordingTimer;
  int _recordingSeconds = 0;
  static const int maxRecordingSeconds = 30;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    _loadGalleryAssets();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _videoController?.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) return;

      final camera = _isFrontCamera ? _cameras!.last : _cameras!.first;
      
      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _cameraController!.initialize();
      
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _loadGalleryAssets() async {
    setState(() => _isLoadingGallery = true);

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

        if (mounted) {
          setState(() {
            _galleryAssets = media;
            _isLoadingGallery = false;
          });
        }
      }
    } else {
      setState(() => _isLoadingGallery = false);
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    setState(() {
      _isFrontCamera = !_isFrontCamera;
      _isCameraInitialized = false;
    });

    await _cameraController?.dispose();
    await _initializeCamera();
  }

 void _startRecording() async {
  if (_cameraController == null || !_cameraController!.value.isInitialized) return;
  if (_isRecording) return;

  try {
    await _cameraController!.startVideoRecording();
    
    setState(() {
      _isRecording = true;
      _recordingSeconds = 0;
    });

    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_recordingSeconds >= maxRecordingSeconds) {
        _stopRecording();
      } else {
        setState(() => _recordingSeconds++);
      }
    });
  } catch (e) {
    debugPrint('Error starting recording: $e');
  }
}

void _stopRecording() async {
  if (!_isRecording) return;

  try {
    _recordingTimer?.cancel();
    final XFile video = await _cameraController!.stopVideoRecording();
    
    // 🔹 CONVERTIR .temp a .mp4
    final String originalPath = video.path;
    final String mp4Path = originalPath.replaceAll('.temp', '.mp4');
    
    // Copiar o renombrar el archivo
    final File tempFile = File(originalPath);
    final File mp4File = await tempFile.copy(mp4Path);
    
    // Opcional: eliminar el archivo temporal original
    await tempFile.delete();
    
    setState(() {
      _isRecording = false;
      _recordingSeconds = 0;
      _capturedFile = mp4File; // ✅ Usar el archivo .mp4
      _contentType = 'video';
    });

    await _initializeVideoController();
  } catch (e) {
    debugPrint('Error stopping recording: $e');
  }
}

  void _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      
      setState(() {
        _capturedFile = File(photo.path);
        _contentType = 'imagen';
      });
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  Future<void> _initializeVideoController() async {
    if (_capturedFile == null || _contentType != 'video') return;

    _videoController?.dispose();
    _videoController = VideoPlayerController.file(_capturedFile!);
    
    try {
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.play();
      setState(() {});
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  Future<void> _selectFromGallery(AssetEntity asset) async {
    try {
      final File? file = await asset.file;
      if (file == null) return;

      setState(() {
        _capturedFile = file;
        _contentType = asset.type == AssetType.image ? 'imagen' : 'video';
      });

      if (_contentType == 'video') {
        await _initializeVideoController();
      }
    } catch (e) {
      debugPrint('Error selecting from gallery: $e');
    }
  }

  void _clearCapture() {
    setState(() {
      _capturedFile = null;
      _contentType = null;
      _videoController?.dispose();
      _videoController = null;
    });
  }

  Future<void> _publishStory() async {
    if (_capturedFile == null || _contentType == null) return;
    await controller.createStory(_capturedFile!, _contentType!);
  }

  @override
  Widget build(BuildContext context) {
    if (_capturedFile != null) {
      return _buildPreviewScreen();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Vista de la cámara
          if (_isCameraInitialized && _cameraController != null)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),

          // Overlay oscuro al grabar
          if (_isRecording)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 4),
                ),
              ),
            ),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón de cerrar
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),

                    // Timer de grabación
                    if (_isRecording)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${_recordingSeconds}s',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Botón de cambiar cámara
                    GestureDetector(
                      onTap: _switchCamera,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.flip_camera_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Galería en miniatura (abajo)
// Galería en miniatura (abajo)
Positioned(
  bottom: 140,
  left: 0,
  right: 0,
  child: SizedBox(
    height: 80,
    child: _isLoadingGallery
        ? const Center(
            child: CircularProgressIndicator(color: Colors.white),
          )
        : ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _galleryAssets.length,
            itemBuilder: (context, index) {
              final asset = _galleryAssets[index];
              return GestureDetector(
                onTap: () => _selectFromGallery(asset),
                child: Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: FutureBuilder<Uint8List?>(
                      future: asset.thumbnailDataWithSize(
                        const ThumbnailSize(200, 200),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          );
                        }
                        return Container(
                          color: Colors.grey[800],
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
  ),
),

          // Botón de captura
         // Botón de captura
Positioned(
  bottom: 40,
  left: 0,
  right: 0,
  child: Center(
    child: GestureDetector(
      onTap: _isRecording ? null : _takePicture, // ✅ No permitir foto mientras graba
      onLongPressStart: (_) => _startRecording(),
      onLongPressEnd: (_) => _stopRecording(), // ✅ Se detiene al soltar
      onLongPressCancel: () => _stopRecording(), // ✅ Por si cancela el gesto
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Círculo de progreso para video
          if (_isRecording)
            SizedBox(
              width: 90,
              height: 90,
              child: CircularProgressIndicator(
                value: _recordingSeconds / maxRecordingSeconds,
                strokeWidth: 4,
                color: Colors.red,
                backgroundColor: Colors.white.withOpacity(0.3),
              ),
            ),
          
          // Botón principal
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              color: _isRecording 
                  ? Colors.red 
                  : Colors.white.withOpacity(0.3),
            ),
            child: _isRecording
                ? const Center(
                    child: Icon(
                      Icons.videocam,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                : null,
          ),
        ],
      ),
    ),
  ),
),
          // Texto de instrucción
          if (!_isRecording)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Toca para foto • Mantén para video',
                  style: GoogleFonts.rubik(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPreviewScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Preview del contenido
          Positioned.fill(
            child: _contentType == 'video'
                ? _buildVideoPreview()
                : _buildImagePreview(),
          ),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón de volver
                    GestureDetector(
                      onTap: _clearCapture,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),

                    // Botón de publicar
                    Obx(() => controller.isCreatingStory.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : GestureDetector(
                            onTap: _publishStory,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: GerenaColors.primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Publicar',
                                    style: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_capturedFile == null) return const SizedBox.shrink();
    
    return Center(
      child: Image.file(
        _capturedFile!,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildVideoPreview() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }
    
    return Center(
      child: AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      ),
    );
  }
}