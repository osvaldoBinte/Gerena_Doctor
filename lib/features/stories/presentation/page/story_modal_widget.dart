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
  
  // ✅ ELIMINAR estas variables locales - usar las del controller
  // VideoPlayerController? _videoController;
  // bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.isMyStory) {
      controller.initializeMyStoryModal(this);
    } else {
      controller.initializeStoryModal(widget.userIndex, this);
    }
  }

  @override
  void dispose() {
    super.dispose();
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
              if (!controller.isModalActive.value) {
        return const SizedBox.shrink();
      }
        final isViewingMyStory = controller.isViewingMyStory.value;
        final currentStory = isViewingMyStory 
            ? controller.currentMyStory
            : controller.currentStory;

        if (currentStory == null) {
          return const Center(child: CircularProgressIndicator());
        }

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
                          Row(
                            children: List.generate(
                              controller.myStories.length,
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
                                          widthFactor: controller.getMyStoryProgressAt(index),
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
                                    : _fallbackIcon()
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
                             onTap: () {
    // ✅ CRÍTICO: Limpiar ANTES de cerrar
    controller.disposeStoryModal();
    Get.back();
  },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                               
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
Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
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
               // Área IZQUIERDA - Retroceder
Positioned(
  top: 110,
  bottom: 76 + MediaQuery.of(context).padding.bottom,
  left: 0,
  width: screenWidth * 0.3,
  child: GestureDetector(
    onTap: () {
      // ✅ NUEVO: Manejar tap diferente según el contexto
      if (controller.isViewingMyStory.value) {
        controller.previousMyStory();
      } else {
        controller.previousStory();
      }
    },
    onLongPress: () => controller.pauseStory(),
    onLongPressEnd: (details) => controller.resumeStory(),
    child: Container(color: Colors.transparent),
  ),
),

// Área DERECHA - Avanzar
Positioned(
  top: 110,
  bottom: 76 + MediaQuery.of(context).padding.bottom,
  right: 0,
  width: screenWidth * 0.3,
  child: GestureDetector(
    onTap: () {
      // ✅ NUEVO: Manejar tap diferente según el contexto
      if (controller.isViewingMyStory.value) {
        controller.nextMyStory();
      } else {
        controller.nextStory();
      }
    },
    onLongPress: () => controller.pauseStory(),
    onLongPressEnd: (details) => controller.resumeStory(),
    child: Container(color: Colors.transparent),
  ),
),

// Área CENTRAL - Solo pausar/reanudar
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

  Widget _buildMyProfileImage() {
    return Obx(() {
      final doctor = doctorController.doctorProfile.value;

      if (doctor?.foto != null && doctor!.foto!.isNotEmpty) {
        return Image.network(
          doctor.foto!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _fallbackIcon();
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
        return _fallbackIcon();
      }
    });
  }

  Widget _fallbackIcon() {
    return Container(
      color: GerenaColors.backgroundColorfondo,
      child: const Center(
        child: Icon(
          Icons.person,
          size: 20,
          color: Colors.grey,
        ),
      ),
    );
  }

  // ✅ CAMBIO: Usar videoController del controller con Obx
  Widget _buildStoryContent(StoryEntity story) {
    final isVideo = story.tipoContenido.toLowerCase() == 'video';

    if (isVideo) {
      return Obx(() {
        // ✅ Usar las variables del controller
        if (controller.videoController != null && controller.isVideoInitialized.value) {
          return Center(
            child: AspectRatio(
              aspectRatio: controller.videoController!.value.aspectRatio,
              child: VideoPlayer(controller.videoController!),
            ),
          );
        } else {
          return Container(
            color: Colors.grey[900],
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Cargando video...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      });
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
  }Widget _buildOtherStoryFooter(StoryEntity story) {
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
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          child: Image.asset(
            story.yaLikeada 
                ? 'assets/icons/favorite.png'
                : 'assets/icons/favorite_border.png',
            key: ValueKey(story.yaLikeada), // ✅ Key necesaria para la animación
            color: story.yaLikeada 
                ? Colors.red
                : Colors.white,
            width: 26,
            height: 26,
          ),
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