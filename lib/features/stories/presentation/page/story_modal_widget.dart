import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/doctors/presentation/page/prefil_dortor_controller.dart';
import 'package:gerena/features/stories/domain/entities/getstories/story_entity.dart';
import 'package:gerena/features/stories/presentation/page/story_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

void showStoryModal(
  BuildContext context, {
  required int userIndex,
  bool isMyStory = false,
}) async {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return StoryModalWidget(
          userIndex: userIndex,
          isMyStory: isMyStory,
        );
      },
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );
}

class StoryModalWidget extends StatefulWidget {
  final int userIndex;
  final bool isMyStory;

  const StoryModalWidget({
    Key? key,
    required this.userIndex,
    this.isMyStory = false,
  }) : super(key: key);

  @override
  _StoryModalWidgetState createState() => _StoryModalWidgetState();
}

class _StoryModalWidgetState extends State<StoryModalWidget>
    with TickerProviderStateMixin {
  final StoryController controller = Get.find<StoryController>();
  final PrefilDortorController doctorController = Get.find<PrefilDortorController>();
  
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.isMyStory) {
      controller.initializeMyStoryModal(this);
    } else {
      controller.initializeStoryModal(widget.userIndex, this);
    }
    
    _initializeVideoIfNeeded();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoIfNeeded() async {
    final story = widget.isMyStory 
        ? controller.myStory.value 
        : controller.currentStory;

    if (story == null) return;

    if (story.tipoContenido.toLowerCase() == 'video') {
      await _initializeVideo(story.urlContenido);
    }
  }

  Future<void> _initializeVideo(String videoUrl) async {
    try {
      _videoController?.dispose();
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.play();
      
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: GerenaColors.textTertiary,
          elevation: 4,
          shadowColor: GerenaColors.shadowColor,
        ),
      ),
      body: Obx(() {
        final isViewingMyStory = controller.isViewingMyStory.value;
        
        final currentStory = isViewingMyStory 
            ? controller.myStory.value 
            : controller.currentStory;

        if (currentStory == null) {
          return const Center(child: CircularProgressIndicator());
        }

        _checkAndUpdateVideo(currentStory);

        return Material(
          color: Colors.black,
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Stack(
              children: [
                // Contenido de fondo (imagen o video)
                Positioned.fill(
                  child: _buildStoryContent(currentStory),
                ),

                // Header
                Positioned(
                  top: -30,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 10,
                      left: 8,
                      right: 8,
                      bottom: 10,
                    ),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Barra de progreso
                        if (isViewingMyStory) ...[
                          Container(
                            height: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.white.withOpacity(0.3),
                            ),
                            child: AnimatedBuilder(
                              animation: controller.progressAnimation!,
                              builder: (context, child) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor: controller.getMyStoryProgress(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ] else ...[
                          Row(
                            children: List.generate(
                              controller.currentUserStories.length,
                              (index) => Expanded(
                                child: Container(
                                  height: 3,
                                  margin: const EdgeInsets.symmetric(horizontal: 1),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  child: AnimatedBuilder(
                                    animation: controller.progressAnimation!,
                                    builder: (context, child) {
                                      return Align(
                                        alignment: Alignment.centerLeft,
                                        child: FractionallySizedBox(
                                          widthFactor: controller.getStoryProgress(index),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(2),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),

                        // Info del usuario
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: isViewingMyStory
                                    ? _buildMyProfileImage()
                                    : Image.network(
                                        controller.currentUser!.fotoPerfilUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/perfil.png',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                isViewingMyStory 
                                    ? "Mi historia" 
                                    : controller.currentUser!.nombreDoctor,
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 1),
                                      blurRadius: 3,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/icons/close.png',
                                  width: 15,
                                  height: 15,
                                  color: GerenaColors.textTertiary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 16,
                      left: 16,
                      right: 16,
                      top: 16,
                    ),
                    child: SizedBox(
                      height: 50,
                      child: isViewingMyStory 
                          ? _buildMyStoryFooter(currentStory)
                          : _buildOtherStoryFooter(currentStory),
                    ),
                  ),
                ),

                // Áreas de navegación
                Positioned(
                  top: 110,
                  bottom: 76 + MediaQuery.of(context).padding.bottom,
                  left: 0,
                  width: screenWidth * 0.3,
                  child: GestureDetector(
                    onTap: () => controller.previousStory(),
                    onLongPress: () => controller.pauseStory(),
                    onLongPressEnd: (details) => controller.resumeStory(),
                    child: Container(color: Colors.transparent),
                  ),
                ),

                Positioned(
                  top: 110,
                  bottom: 76 + MediaQuery.of(context).padding.bottom,
                  right: 0,
                  width: screenWidth * 0.3,
                  child: GestureDetector(
                    onTap: () {
                      if (isViewingMyStory) {
                        controller.goToFirstUserStory();
                      } else {
                        controller.nextStory();
                      }
                    },
                    onLongPress: () => controller.pauseStory(),
                    onLongPressEnd: (details) => controller.resumeStory(),
                    child: Container(color: Colors.transparent),
                  ),
                ),

                Positioned(
                  top: 110,
                  bottom: 76 + MediaQuery.of(context).padding.bottom,
                  left: screenWidth * 0.3,
                  right: screenWidth * 0.3,
                  child: GestureDetector(
                    onLongPress: () => controller.pauseStory(),
                    onLongPressEnd: (details) => controller.resumeStory(),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Nuevo método para construir la imagen de perfil del doctor
  Widget _buildMyProfileImage() {
    return Obx(() {
      final doctor = doctorController.doctorProfile.value;
      
      if (doctor?.foto != null && doctor!.foto!.isNotEmpty) {
        return Image.network(
          doctor.foto!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/perfil.png',
              fit: BoxFit.cover,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: GerenaColors.backgroundColorfondo,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            );
          },
        );
      } else {
        return Image.asset(
          'assets/perfil.png',
          fit: BoxFit.cover,
        );
      }
    });
  }

  Widget _buildStoryContent(StoryEntity story) {
    final isVideo = story.tipoContenido.toLowerCase() == 'video';

    if (isVideo) {
      if (_videoController != null && _isVideoInitialized) {
        return Center(
          child: AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
        );
      } else {
        return Container(
          color: Colors.grey[900],
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      }
    } else {
      return Image.network(
        story.urlContenido,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[800],
            child: const Center(
              child: Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 50,
              ),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[900],
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        },
      );
    }
  }

  void _checkAndUpdateVideo(StoryEntity newStory) {
    final isVideo = newStory.tipoContenido.toLowerCase() == 'video';
    
    if (isVideo) {
      if (_videoController == null || 
          _videoController!.dataSource != newStory.urlContenido) {
        _initializeVideo(newStory.urlContenido);
      }
    } else {
      if (_videoController != null) {
        _videoController!.dispose();
        _videoController = null;
        _isVideoInitialized = false;
      }
    }
  }

  Widget _buildMyStoryFooter(StoryEntity story) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.visibility,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${story.vistas}',
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${story.likes}',
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        GestureDetector(
          onTap: () => _showDeleteOptions(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherStoryFooter(StoryEntity story) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => controller.likeStory(),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            'assets/icons/favorite_border.png',
            color: story.yaLikeada 
                ? Colors.red 
                : Colors.white,
            width: 26,
            height: 26,
          ),
        ),
      ),
    );
  }

  void _showDeleteOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: GerenaColors.backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text(
                'Eliminar historia',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Get.back();
                _confirmDeleteStory(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.close,
                color: GerenaColors.textSecondaryColor,
              ),
              title: const Text('Cancelar'),
              onTap: () => Get.back(),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteStory(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text('Eliminar historia'),
        content: const Text('¿Estás seguro de que deseas eliminar tu historia? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancelar',
              style: TextStyle(color: GerenaColors.textSecondaryColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              Get.back();
              await controller.deleteMyStory();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}