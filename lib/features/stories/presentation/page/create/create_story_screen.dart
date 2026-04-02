import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/stories/presentation/page/create/create_story_controller.dart';
import 'package:gerena/features/stories/presentation/page/gallery_picker_screen.dart';
import 'package:gerena/features/stories/presentation/page/story_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
class DraggableStoryText extends StatefulWidget {
  final String text;
  final Color color;
  final Offset position;
  final double scale;
  final bool isSelected;
  final Function(Offset) onPositionChanged;
  final Function(double) onScaleChanged;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final String style;
  final VoidCallback? onDragStart;
  final Function(Offset globalPosition)? onDragEnd;

  const DraggableStoryText({
    Key? key,
    required this.text,
    required this.color,
    required this.position,
    required this.scale,
    required this.isSelected,
    required this.onPositionChanged,
    required this.onScaleChanged,
    required this.onTap,
    required this.onLongPress,
    this.style = 'none',
    this.onDragStart,
    this.onDragEnd,
  }) : super(key: key);

  @override
  State<DraggableStoryText> createState() => _DraggableStoryTextState();
}

class _DraggableStoryTextState extends State<DraggableStoryText> {
  late Offset position;
  late double scale;
  double baseScale = 1.0;
  Offset basePosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    position = widget.position;
    scale = widget.scale;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
      left: position.dx * size.width,
      top: position.dy * size.height,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: GestureDetector(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          onScaleStart: (details) {
            baseScale = scale;
            basePosition = position;
            widget.onDragStart?.call();
          },
          onScaleUpdate: (details) {
            setState(() {
              if (details.scale != 1.0) {
                scale = (baseScale * details.scale).clamp(0.5, 3.0);
              }
              final newX =
                  (basePosition.dx * size.width + details.focalPointDelta.dx) /
                  size.width;
              final newY =
                  (basePosition.dy * size.height +
                      details.focalPointDelta.dy) /
                  size.height;
              position = Offset(newX.clamp(0.0, 1.0), newY.clamp(0.0, 1.0));
              basePosition = position;
            });
          },
          onScaleEnd: (_) {
            widget.onPositionChanged(position);
            widget.onScaleChanged(scale);
            final renderBox = context.findRenderObject() as RenderBox?;
            if (renderBox != null && widget.onDragEnd != null) {
              final globalPos = renderBox.localToGlobal(Offset.zero);
              widget.onDragEnd!(globalPos);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: widget.style == 'pill'
                  ? Colors.black.withOpacity(0.6)
                  : widget.isSelected
                      ? Colors.white.withOpacity(0.2)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(
                widget.style == 'pill' ? 12 : 8,
              ),
              border: widget.style == 'outline'
                  ? Border.all(color: widget.color, width: 2.5)
                  : widget.isSelected
                      ? Border.all(color: Colors.white, width: 2)
                      : null,
            ),
            child: Transform.scale(
              scale: scale,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                child: Text(
                  widget.text,
                  style: GoogleFonts.rubik(
                    color: widget.color,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: widget.style == 'outline'
                        ? []
                        : [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({Key? key}) : super(key: key);

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen>
    with WidgetsBindingObserver {
  final CreateStoryController controller = Get.put(CreateStoryController());
  final StoryController storyController = Get.find<StoryController>();

  final RxBool _isDraggingText = false.obs;
  final GlobalKey _trashKey = GlobalKey();

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

  void _checkDropOnTrash(String textId, Offset globalPos) {
    final trashCtx = _trashKey.currentContext;
    if (trashCtx == null) return;
    final trashBox = trashCtx.findRenderObject() as RenderBox?;
    if (trashBox == null) return;
    final trashPos  = trashBox.localToGlobal(Offset.zero);
    final trashSize = trashBox.size;
    final trashRect = Rect.fromLTWH(
      trashPos.dx - 40,
      trashPos.dy - 40,
      trashSize.width + 80,
      trashSize.height + 80,
    );
    if (trashRect.contains(globalPos)) {
      controller.removeText(textId);
      controller.selectText(null);
    }
  }

  Future<void> _publishStory() async {
    if (controller.capturedFile.value == null ||
        controller.contentType.value == null) {
      debugPrint('❌ No hay contenido para publicar');
      return;
    }

    File? finalFile = controller.capturedFile.value;

    if (controller.storyTexts.isNotEmpty) {
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    'Procesando historia con textos...',
                    style: GoogleFonts.rubik(
                        color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Esto puede tardar unos segundos',
                    style: GoogleFonts.rubik(
                        color: Colors.grey[400], fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      finalFile = await controller.captureStoryWithTexts();
      Get.back();
    }

    if (finalFile == null) {
      showWarningSnackbar('No se pudo procesar la historia. Intenta de nuevo.');
      return;
    }

    if (!await finalFile.exists()) {
      showWarningSnackbar('El archivo procesado no existe. Intenta de nuevo.');
      return;
    }

    await storyController.createStory(
      finalFile,
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
          Obx(() {
            final camController = controller.cameraController.value;
            if (!controller.isCameraInitialized.value ||
                camController == null) {
              return Container(
                color: Colors.black,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text('Iniciando cámara...',
                          style: TextStyle(color: Colors.white)),
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
            return Center(
              child: OverflowBox(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width *
                        camController.value.aspectRatio,
                    child: CameraPreview(camController),
                  ),
                ),
              ),
            );
          }),
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
      top: 0, left: 0, right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              Obx(() {
                if (controller.isRecording.value) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8, height: 8,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${controller.recordingSeconds.value}s',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              GestureDetector(
                onTap: () => controller.switchCamera(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.flip_camera_ios,
                      color: Colors.white, size: 24),
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
      bottom: 140, left: 0, right: 0,
      child: SizedBox(
        height: 80,
        child: Obx(() {
          if (controller.isLoadingGallery.value) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.galleryAssets.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () =>  controller.selectFromImagePicker(),
                  child: Container(
                    width: 60, height: 60,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white, width: 2),
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.photo_library,
                            color: Colors.white, size: 24),
                        const SizedBox(height: 4),
                        Text('Todo',
                            style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                );
              }
              final asset = controller.galleryAssets[index - 1];
              return GestureDetector(
                onTap: () => controller.selectFromGallery(asset),
                child: Container(
                  width: 60, height: 60,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: FutureBuilder<Uint8List?>(
                      future: asset.thumbnailDataWithSize(
                          const ThumbnailSize(200, 200)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.done &&
                            snapshot.hasData) {
                          return Image.memory(snapshot.data!,
                              fit: BoxFit.cover);
                        }
                        return Container(
                          color: Colors.grey[800],
                          child: const Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
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
      bottom: 40, left: 0, right: 0,
      child: Center(
        child: Obx(() {
          return GestureDetector(
            onTap: controller.isRecording.value
                ? null
                : () => controller.takePicture(),
            onLongPressStart: (_) => controller.startRecording(),
            onLongPressEnd: (_) => controller.stopRecording(),
            onLongPressCancel: () => controller.stopRecording(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (controller.isRecording.value)
                  SizedBox(
                    width: 90, height: 90,
                    child: CircularProgressIndicator(
                      value: controller.recordingSeconds.value /
                          CreateStoryController.maxRecordingSeconds,
                      strokeWidth: 4,
                      color: Colors.red,
                      backgroundColor: Colors.white.withOpacity(0.3),
                    ),
                  ),
                Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    color: controller.isRecording.value
                        ? Colors.red
                        : Colors.white.withOpacity(0.3),
                  ),
                  child: controller.isRecording.value
                      ? const Center(
                          child: Icon(Icons.videocam,
                              color: Colors.white, size: 30))
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
          bottom: 10, left: 0, right: 0,
          child: Center(
            child: Text(
              'Toca para foto • Mantén para video',
              style: GoogleFonts.rubik(
                  color: Colors.white.withOpacity(0.7), fontSize: 12),
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildPreviewScreen() {
 
    final size = MediaQuery.of(context).size;
    controller.previewScreenWidth  = size.width;
    controller.previewScreenHeight = size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => controller.selectText(null),
        child: Stack(
          children: [
            RepaintBoundary(
              key: controller.repaintBoundaryKey,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Obx(() {
                      final isVid =
                          controller.contentType.value == 'video';
                      final isVideoReady = controller.isVideoReady.value;

                      if (isVid) {
                        if (!isVideoReady) {
                          return Container(
                            color: Colors.black,
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                      color: Colors.white),
                                  SizedBox(height: 16),
                                  Text('Preparando video...',
                                      style:
                                          TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          );
                        }
                        final videoCtrl = controller.videoController;
                        if (videoCtrl != null &&
                            videoCtrl.value.isInitialized) {
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
                            child: CircularProgressIndicator(
                                color: Colors.white),
                          ),
                        );
                      }
                      return _buildImagePreview();
                    }),
                  ),

                  Obx(() {
                    return Stack(
                      children: controller.storyTexts.map((storyText) {
                        return Obx(() {
                          return DraggableStoryText(
                            text: storyText.text,
                            color: storyText.color,
                            position: storyText.position,
                            scale: storyText.scale,
                            style: storyText.style,
                            isSelected:
                                controller.selectedTextId.value ==
                                    storyText.id,
                            onPositionChanged: (p) =>
                                controller.updateTextPosition(
                                    storyText.id, p),
                            onScaleChanged: (s) =>
                                controller.updateTextScale(storyText.id, s),
                            onTap: () => controller.openTextEditor(
                                textId: storyText.id),
                            onLongPress: () => controller.openTextEditor(
                                textId: storyText.id),
                            onDragStart: () =>
                                _isDraggingText.value = true,
                            onDragEnd: (globalPos) {
                              _isDraggingText.value = false;
                              _checkDropOnTrash(storyText.id, globalPos);
                            },
                          );
                        });
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),

            _buildPreviewHeader(),

            Obx(() => _isDraggingText.value
                ? const SizedBox.shrink()
                : _buildAddTextButton()),

            Obx(() => _isDraggingText.value
                ? _buildTrashZone()
                : const SizedBox.shrink()),

            Obx(() => controller.isEditingText.value
                ? _FullscreenTextEditorOverlay(controller: controller)
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Widget _buildTrashZone() {
    return Positioned(
      bottom: 40, left: 0, right: 0,
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 250),
          curve: Curves.elasticOut,
          builder: (context, value, child) =>
              Transform.scale(scale: value, child: child),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                key: _trashKey,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.85),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(Icons.delete_forever,
                    color: Colors.white, size: 32),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Suelta aquí para eliminar',
                  style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewHeader() {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => controller.clearCapture(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 24),
                ),
              ),
              Obx(() {
                final showPublish = controller.isVideoReady.value ||
                    controller.contentType.value == 'imagen';

                if (showPublish) {
                  if (storyController.isCreatingStory.value) {
                    return const CircularProgressIndicator(
                        color: Colors.white);
                  }
                  return GestureDetector(
                    onTap: _publishStory,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: GerenaColors.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.send,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text('Publicar',
                              style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
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
    );
  }

  Widget _buildAddTextButton() {
    return Positioned(
      bottom: 30, right: 20,
      child: GestureDetector(
        onTap: () => controller.openTextEditor(),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(Icons.text_fields,
              color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (controller.capturedFile.value == null) return const SizedBox.shrink();
    return Center(
      child: Image.file(controller.capturedFile.value!, fit: BoxFit.contain),
    );
  }
}

class _FullscreenTextEditorOverlay extends StatefulWidget {
  final CreateStoryController controller;
  const _FullscreenTextEditorOverlay({required this.controller});

  @override
  State<_FullscreenTextEditorOverlay> createState() =>
      _FullscreenTextEditorOverlayState();
}

class _FullscreenTextEditorOverlayState
    extends State<_FullscreenTextEditorOverlay> {
  late final TextEditingController _textCtrl;

  final List<Color> _colors = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.cyan,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.deepPurple,
    const Color(0xFFA2845E),
  ];

  @override
  void initState() {
    super.initState();
    _textCtrl = TextEditingController(
        text: widget.controller.currentEditText.value);
    _textCtrl.selection =
        TextSelection.collapsed(offset: _textCtrl.text.length);
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            widget.controller.isEditingText.value = false,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('Cancelar',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 13)),
                        ),
                      ),
                      const Spacer(),

                      ...['left', 'center', 'right'].map((a) {
                        return Obx(() {
                          final isActive =
                              widget.controller.currentEditAlign.value == a;
                          final icon = a == 'left'
                              ? Icons.format_align_left
                              : a == 'center'
                                  ? Icons.format_align_center
                                  : Icons.format_align_right;
                          return GestureDetector(
                            onTap: () =>
                                widget.controller.currentEditAlign.value = a,
                            child: Container(
                              margin: const EdgeInsets.only(left: 6),
                              width: 34, height: 34,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.white.withOpacity(0.35)
                                    : Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isActive
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.25),
                                  width: 1.5,
                                ),
                              ),
                              child:
                                  Icon(icon, color: Colors.white, size: 16),
                            ),
                          );
                        });
                      }).toList(),

                      const Spacer(),

                    
                      GestureDetector(
                        onTap: () => widget.controller
                            .confirmTextEdit(_textCtrl.text),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('Listo',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Center(
                    child: Obx(() {
                      final style =
                          widget.controller.currentEditStyle.value;
                      final color =
                          widget.controller.currentEditColor.value;
                      final align =
                          widget.controller.currentEditAlign.value;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: style != 'none'
                            ? const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10)
                            : EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: style == 'pill'
                              ? Colors.black.withOpacity(0.6)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: style == 'outline'
                              ? Border.all(color: color, width: 2.5)
                              : null,
                        ),
                        child: TextField(
                          controller: _textCtrl,
                          autofocus: true,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          textAlign: align == 'left'
                              ? TextAlign.left
                              : align == 'right'
                                  ? TextAlign.right
                                  : TextAlign.center,
                          style: TextStyle(
                            color: color,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                            shadows: style == 'outline'
                                ? []
                                : [
                                    Shadow(
                                      color: color == Colors.black
                                          ? Colors.white.withOpacity(0.4)
                                          : Colors.black.withOpacity(0.8),
                                      offset: const Offset(1, 1),
                                      blurRadius: 4,
                                    ),
                                  ],
                          ),
                          decoration: InputDecoration(
                            hintText: 'Escribe algo...',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.35),
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: true,
                            fillColor: Colors.transparent,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      {'id': 'none',    'label': 'Sin fondo'},
                      {'id': 'pill',    'label': 'Con fondo'},
                      {'id': 'outline', 'label': 'Contorno'},
                    ].map((s) {
                      return Obx(() {
                        final isActive =
                            widget.controller.currentEditStyle.value ==
                                s['id'];
                        return GestureDetector(
                          onTap: () =>
                              widget.controller.currentEditStyle.value =
                                  s['id']!,
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.white.withOpacity(0.25)
                                  : Colors.white.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isActive
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.25),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              s['label']!,
                              style: TextStyle(
                                color: isActive
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.55),
                                fontSize: 12,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      });
                    }).toList(),
                  ),
                ),

                SizedBox(
                  height: 52,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _colors.length,
                    itemBuilder: (ctx, i) {
                      final c = _colors[i];
                      return Obx(() {
                        final isSelected =
                            widget.controller.currentEditColor.value == c;
                        return GestureDetector(
                          onTap: () =>
                              widget.controller.currentEditColor.value = c,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: isSelected ? 38 : 32,
                            height: isSelected ? 38 : 32,
                            margin: EdgeInsets.only(
                                right: 10, top: isSelected ? 0 : 3),
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white38,
                                width: isSelected ? 3 : 1.5,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: c.withOpacity(0.6),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}