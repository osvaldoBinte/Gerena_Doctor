import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/doctors/presentation/page/prefil_dortor_controller.dart';
import 'package:gerena/features/stories/presentation/page/create_story_screen.dart';
import 'package:gerena/features/stories/presentation/page/story_controller.dart';
import 'package:gerena/features/stories/presentation/page/story_modal_widget.dart';
import 'package:get/get.dart';

class MyStoryRingWidget extends StatelessWidget {
  final double size;
  final VoidCallback? onAddStory;

  const MyStoryRingWidget({
    Key? key,
    this.size = 80,
    this.onAddStory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StoryController storyController = Get.find<StoryController>();
    final PrefilDortorController doctorController = Get.find<PrefilDortorController>();

    return Container(
      margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
      child: Obx(() {
        // Mostrar loading si está cargando
        if (storyController.isLoadingMyStory.value) {
          return _buildLoadingRing();
        }

        // Si tengo historia, mostrarla
        if (storyController.hasMyStory.value && storyController.myStories.isNotEmpty) {
          return _buildMyStoryRing(context, storyController, doctorController);
        }

        // Si no tengo historia, mostrar botón de agregar
        return _buildAddStoryButton(context, doctorController);
      }),
    );
  }

  Widget _buildMyStoryRing(
    BuildContext context,
    StoryController storyController,
    PrefilDortorController doctorController,
  ) {
    final doctor = doctorController.doctorProfile.value;
    
    // Verificar si todas las historias fueron vistas
    final bool allViewed = storyController.myStories.every((story) => story.yaVista);
    
    return GestureDetector(
      onTap: () {
        // Abrir modal de historia con la opción isMyStory = true
        showStoryModal(context, userIndex: -1, isMyStory: true);
      },
      child: Stack(
        children: [
          GerenaColors.createStoryRing(
            child: _buildProfileImage(doctor),
            hasStory: true,
            isViewed: allViewed,
            size: size,
          ),
          // ✅ CAMBIO: Mostrar botón de agregar en lugar del contador
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                // Navegar a la pantalla de crear historia
                Get.to(() => const CreateStoryScreen());
              },
              child: Container(
                width: 29,
                height: 29,
               
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    'assets/icons/aadHistory.png',
                    fit: BoxFit.contain,
                  
                  ),
                ),
              ),
            ),
          ),
          // ✅ NUEVO: Contador de historias en la esquina superior derecha
          if (storyController.myStories.length > 1)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: GerenaColors.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Center(
                  child: Text(
                    '${storyController.myStories.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddStoryButton(BuildContext context, PrefilDortorController doctorController) {
    final doctor = doctorController.doctorProfile.value;

    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla de crear historia
        Get.to(() => const CreateStoryScreen());
      },
      child: Stack(
        children: [
          GerenaColors.createStoryRing(
            child: _buildProfileImage(doctor),
            hasStory: false,
            size: size,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              width: 29,
              height: 29,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  'assets/icons/aadHistory.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildProfileImage(dynamic doctor) {
  if (doctor?.foto != null && doctor!.foto!.isNotEmpty) {
    return Image.network(
      doctor.foto!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackIcon();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: GerenaColors.backgroundColorfondo,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  } else {
    return _buildFallbackIcon();
  }
}

Widget _buildFallbackIcon() {
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


  Widget _buildLoadingRing() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: GerenaColors.primaryColor,
        ),
      ),
    );
  }
}