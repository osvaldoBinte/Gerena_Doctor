
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/stories/presentation/page/create_story_controller.dart';
import 'package:gerena/features/stories/presentation/page/gallery_picker_screen.dart';
import 'package:gerena/features/stories/presentation/page/story_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart'; // ✅ Para DeviceOrientation
class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({Key? key}) : super(key: key);

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen>
    with WidgetsBindingObserver {
  final CreateStoryController controller = Get.put(CreateStoryController());
  final StoryController storyController = Get.find<StoryController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Get.delete<CreateStoryController>();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    controller.handleAppLifecycleState(state);
  }

  Future<void> _publishStory() async {
    if (controller.capturedFile.value == null || controller.contentType.value == null) {
      return;
    }
    await storyController.createStory(
      controller.capturedFile.value!,
      controller.contentType.value!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.capturedFile.value != null) {
        return _buildPreviewScreen();
      }
      return _buildCameraScreen();
    });
  }


  Widget _buildCameraScreen() {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Stack(
      children: [
      // Vista de la cámara - VERSIÓN SIMPLE Y EFECTIVA
Obx(() {
  final camController = controller.cameraController.value;
  
  if (!controller.isCameraInitialized.value || camController == null) {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Iniciando cámara...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  if (!camController.value.isInitialized) {
    return Container(
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  // ✅ SOLUCIÓN MÁS SIMPLE: Usar OverflowBox
  return Center(
    child: OverflowBox(
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * camController.value.aspectRatio,
          child: CameraPreview(camController),
        ),
      ),
    ),
  );
}),

        // Overlay al grabar
        Obx(() {
          if (controller.isRecording.value) {
            return Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 4),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),

        _buildHeader(),
        _buildGallery(),
        _buildCaptureButton(),
        _buildInstructionText(),
      ],
    ),
  );
}
  Widget _buildHeader() {
    return Positioned(
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
              // Botón cerrar
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),

              // Timer
              Obx(() {
                if (controller.isRecording.value) {
                  return Container(
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
                          '${controller.recordingSeconds.value}s',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              // Botón cambiar cámara
              GestureDetector(
                onTap: () => controller.switchCamera(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGallery() {
  return Positioned(
    bottom: 140,
    left: 0,
    right: 0,
    child: SizedBox(
      height: 80,
      child: Obx(() {
        if (controller.isLoadingGallery.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.galleryAssets.length + 1, // ✅ +1 para el botón
          itemBuilder: (context, index) {
            // ✅ NUEVO: Botón "Ver todo"
            if (index == 0) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => const GalleryPickerScreen());
                },
                child: Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 2),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.photo_library,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Todo',
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Assets normales (ajustar índice)
            final asset = controller.galleryAssets[index - 1];
            return GestureDetector(
              onTap: () => controller.selectFromGallery(asset),
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
        );
      }),
    ),
  );
}

  Widget _buildCaptureButton() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: Obx(() {
          return GestureDetector(
            onTap: controller.isRecording.value ? null : () => controller.takePicture(),
            onLongPressStart: (_) => controller.startRecording(),
            onLongPressEnd: (_) => controller.stopRecording(),
            onLongPressCancel: () => controller.stopRecording(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Progreso
                if (controller.isRecording.value)
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: CircularProgressIndicator(
                      value: controller.recordingSeconds.value / CreateStoryController.maxRecordingSeconds,
                      strokeWidth: 4,
                      color: Colors.red,
                      backgroundColor: Colors.white.withOpacity(0.3),
                    ),
                  ),

                // Botón
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    color: controller.isRecording.value
                        ? Colors.red
                        : Colors.white.withOpacity(0.3),
                  ),
                  child: controller.isRecording.value
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
          );
        }),
      ),
    );
  }

  Widget _buildInstructionText() {
    return Obx(() {
      if (!controller.isRecording.value) {
        return Positioned(
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
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildPreviewScreen() {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Stack(
      children: [
        // Preview
        Positioned.fill(
          child: Obx(() {
            // ✅ Un solo Obx que observa contentType
            if (controller.contentType.value == 'video') {
              // ✅ Observar isVideoReady aquí
              if (!controller.isVideoReady.value) {
                return Container(
                  color: Colors.black,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 16),
                        Text(
                          'Preparando video...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              // Video listo
              final videoCtrl = controller.videoController;
              if (videoCtrl != null && videoCtrl.value.isInitialized) {
                return Center(
                  child: AspectRatio(
                    aspectRatio: videoCtrl.value.aspectRatio,
                    child: VideoPlayer(videoCtrl),
                  ),
                );
              }
              
              return Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            }
            
            // Imagen
            return _buildImagePreview();
          }),
        ),

        // Header con botones...
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
                  // Botón volver
                  GestureDetector(
                    onTap: () => controller.clearCapture(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    ),
                  ),

                  // Botón publicar
                  Obx(() {
                    if (controller.isVideoReady.value || controller.contentType.value == 'imagen') {
                      if (storyController.isCreatingStory.value) {
                        return const CircularProgressIndicator(color: Colors.white);
                      }
                      return GestureDetector(
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
                              const Icon(Icons.send, color: Colors.white, size: 20),
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
                      );
                    }
                    return const SizedBox.shrink();
                  }),
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
    if (controller.capturedFile.value == null) return const SizedBox.shrink();

    return Center(
      child: Image.file(
        controller.capturedFile.value!,
        fit: BoxFit.contain,
      ),
    );
  }


  Widget _buildVideoPreview() {
  // ✅ SOLUCIÓN: Observar isVideoReady en lugar del controller
  return Obx(() {
    // Forzar rebuild cuando cambie isVideoReady
    final isReady = controller.isVideoReady.value;
    final videoCtrl = controller.videoController;
    
    if (videoCtrl == null || !isReady) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Preparando video...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    if (!videoCtrl.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Cargando video...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: AspectRatio(
        aspectRatio: videoCtrl.value.aspectRatio,
        child: VideoPlayer(videoCtrl),
      ),
    );
  });
}
}