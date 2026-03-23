import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/doctors/presentation/page/prefil_dortor_controller.dart';
import 'package:gerena/features/stories/domain/entities/getstories/story_entity.dart';
import 'package:gerena/features/stories/presentation/page/story_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

void showStoryModal(
  BuildContext context, {
  required int userIndex,
  bool isMyStory = false,
}) {
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
        return FadeTransition(opacity: animation, child: child);
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
    controller.disposeStoryModal();
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
                // ── Contenido (imagen o video) ─────────────
                // ✅ _buildStoryContent NO recibe story como parámetro
                // para evitar que quede "congelado" con la historia anterior
                Positioned.fill(
                  child: _buildStoryContent(),
                ),

                // ── Overlay de carga ──────────────────────
                Obx(() {
                  if (!controller.isContentLoading.value) {
                    return const SizedBox.shrink();
                  }
                  return Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.55),
                      child: const Center(
                       
                      ),
                    ),
                  );
                }),

                // ── Header con barra de progreso ──────────
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
                        // Barras de progreso
                        if (isViewingMyStory) ...[
                          _buildProgressBars(
                            count: controller.myStories.length,
                            getProgress: controller.getMyStoryProgressAt,
                          ),
                        ] else ...[
                          _buildProgressBars(
                            count: controller.currentUserStories.length,
                            getProgress: controller.getStoryProgress,
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
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: ClipOval(child: _buildUserAvatar(isViewingMyStory),),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isViewingMyStory
                                        ? 'Mi historia'
                                        : controller
                                                .currentUser?.nombreDoctor ??
                                            '',
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
                                  Text(
                                    controller
                                        .getTimeAgo(currentStory.fechaCreacion),
                                    style: GoogleFonts.rubik(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      shadows: [
                                        Shadow(
                                          offset: const Offset(0, 1),
                                          blurRadius: 3,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
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

                // ── Footer ────────────────────────────────
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

                // ── Área izquierda (anterior) ─────────────
                Positioned(
                  top: 110,
                  bottom: 76 + MediaQuery.of(context).padding.bottom,
                  left: 0,
                  width: screenWidth * 0.3,
                  child: GestureDetector(
                    onTap: () {
                      if (controller.isViewingMyStory.value) {
                        controller.previousMyStory();
                      } else {
                        controller.previousStory();
                      }
                    },
                    onLongPress: () => controller.pauseStory(),
                    onLongPressEnd: (_) => controller.resumeStory(),
                    child: Container(color: Colors.transparent),
                  ),
                ),

                // ── Área derecha (siguiente) ──────────────
                Positioned(
                  top: 110,
                  bottom: 76 + MediaQuery.of(context).padding.bottom,
                  right: 0,
                  width: screenWidth * 0.3,
                  child: GestureDetector(
                    onTap: () {
                      if (controller.isViewingMyStory.value) {
                        controller.nextMyStory();
                      } else {
                        controller.nextStory();
                      }
                    },
                    onLongPress: () => controller.pauseStory(),
                    onLongPressEnd: (_) => controller.resumeStory(),
                    child: Container(color: Colors.transparent),
                  ),
                ),

                // ── Centro (solo pausa) ───────────────────
                Positioned(
                  top: 110,
                  bottom: 76 + MediaQuery.of(context).padding.bottom,
                  left: screenWidth * 0.3,
                  right: screenWidth * 0.3,
                  child: GestureDetector(
                    onLongPress: () => controller.pauseStory(),
                    onLongPressEnd: (_) => controller.resumeStory(),
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

  // ── Barras de progreso ────────────────────────

  Widget _buildProgressBars({
    required int count,
    required double Function(int) getProgress,
  }) {
    return Row(
      children: List.generate(count, (index) {
        return Expanded(
          child: Container(
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white.withOpacity(0.3),
            ),
            child: _ProgressSegment(
              controller: controller,
              index: index,
              getProgress: getProgress,
            ),
          ),
        );
      }),
    );
  }

  // ── Contenido ────────────────────────────────
  // ✅ Lee todo desde el controller via Obx,
  //    sin recibir StoryEntity como parámetro.
  //    Así cuando cambia la historia el Obx
  //    reconstruye con el controller correcto.
  Widget _buildStoryContent() {
    return Obx(() {
      // Leer la historia activa en este momento
      final isViewingMyStory = controller.isViewingMyStory.value;
      final story = isViewingMyStory
          ? controller.currentMyStory
          : controller.currentStory;

      if (story == null) {
        return Container(color: Colors.black);
      }

      final isVideo = story.tipoContenido.toLowerCase() == 'video';

      if (isVideo) {
        // ✅ Leer el Rx del controller — se reconstruye cuando cambia
        final videoCtrl = controller.videoControllerRx.value;
        final initialized = controller.isVideoInitialized.value;

        if (initialized &&
            videoCtrl != null &&
            videoCtrl.value.isInitialized) {
          return Center(
            child: AspectRatio(
              aspectRatio: videoCtrl.value.aspectRatio,
              child: VideoPlayer(videoCtrl),
            ),
          );
        }

        // Mientras carga el video
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
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        );
      }

      // Imagen
      return CachedNetworkImage(
        imageUrl: story.urlContenido,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        fadeInDuration: Duration.zero,
        placeholder: (context, url) => Container(
          color: Colors.grey[900],
          child: const Center(
           
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[800],
          child: const Center(
            child: Icon(Icons.error_outline, color: Colors.white, size: 50),
          ),
        ),
      );
    });
  }

  // ── Footer: mi historia ───────────────────────

  Widget _buildMyStoryFooter(StoryEntity story) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _statChip(
              icon: Icons.visibility,
              iconColor: Colors.white,
              value: '${story.vistas}',
            ),
            const SizedBox(width: 12),
            _statChip(
              icon: Icons.favorite,
              iconColor: Colors.red,
              value: '${story.likes}',
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
            child: const Icon(Icons.more_vert, color: Colors.white, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _statChip({
    required IconData icon,
    required Color iconColor,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.rubik(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── Footer: historia de otro ──────────────────

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
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Image.asset(
              story.yaLikeada
                  ? 'assets/icons/favorite.png'
                  : 'assets/icons/favorite_border.png',
              key: ValueKey(story.yaLikeada),
              color: story.yaLikeada ? Colors.red : Colors.white,
              width: 26,
              height: 26,
            ),
          ),
        ),
      ),
    );
  }

  // ── Fallback avatar ───────────────────────────

  Widget _fallbackIcon() {
    return Container(
      color: GerenaColors.backgroundColor,
      child: const Center(
        child: Icon(Icons.person, size: 20, color: Colors.grey),
      ),
    );
  }
Widget _buildUserAvatar(bool isViewingMyStory) {
  if (isViewingMyStory) {
    // ── Mi historia → foto del usuario logueado ──
    final PrefilDortorController userController = Get.find<PrefilDortorController>();
    final userPhoto = userController.doctorProfile.value?.foto;

    if (userPhoto != null && userPhoto.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: userPhoto,
        fit: BoxFit.cover,
        width: 40,
        height: 40,
        placeholder: (_, __) => _fallbackIcon(),
        errorWidget: (_, __, ___) => _fallbackIcon(),
      );
    }
    return _fallbackIcon();
  }

  // ── Historia de otro usuario → fotoPerfilUrl de GetStoriesEntity ──
  final fotoUrl = controller.currentUser?.fotoPerfilUrl;

  if (fotoUrl != null && fotoUrl.isNotEmpty) {
    return CachedNetworkImage(
      imageUrl: fotoUrl,
      fit: BoxFit.cover,
      width: 40,
      height: 40,
      placeholder: (_, __) => _fallbackIcon(),
      errorWidget: (_, __, ___) => _fallbackIcon(),
    );
  }
  return _fallbackIcon();
}
  // ── Diálogos eliminar ─────────────────────────

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
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Eliminar historia',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                _confirmDeleteStory(context);
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.close, color: GerenaColors.textSecondaryColor),
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Eliminar historia'),
        content: const Text(
            '¿Estás seguro de que deseas eliminar tu historia? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancelar',
                style: TextStyle(color: GerenaColors.textSecondaryColor)),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await controller.deleteMyStory();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// _ProgressSegment
// ─────────────────────────────────────────────
class _ProgressSegment extends StatefulWidget {
  final StoryController controller;
  final int index;
  final double Function(int) getProgress;

  const _ProgressSegment({
    required this.controller,
    required this.index,
    required this.getProgress,
  });

  @override
  State<_ProgressSegment> createState() => _ProgressSegmentState();
}

class _ProgressSegmentState extends State<_ProgressSegment> {
  Animation<double>? _currentAnimation;
  Worker? worker;

  @override
  void initState() {
    super.initState();
    worker = ever(widget.controller.isContentLoading, (_) {
      _reattachAnimation();
    });
    _reattachAnimation();
  }

  void _reattachAnimation() {
    final anim = widget.controller.progressAnimation;
    if (anim == _currentAnimation) return;

    _currentAnimation?.removeListener(_onAnimationTick);
    _currentAnimation = anim;
    _currentAnimation?.addListener(_onAnimationTick);

    if (mounted) setState(() {});
  }

  void _onAnimationTick() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    worker?.dispose();
    _currentAnimation?.removeListener(_onAnimationTick);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.controller.isContentLoading.value
        ? 0.0
        : widget.getProgress(widget.index);

    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}