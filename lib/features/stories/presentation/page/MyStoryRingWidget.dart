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
        if (storyController.hasMyStory.value && storyController.myStory.value != null) {
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
            isViewed: storyController.myStory.value!.yaVista,
            size: size,
          ),
          // Indicador de que es mi historia
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: GerenaColors.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.check,
                size: 12,
                color: Colors.white,
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
      Get.to(() =>  CreateStoryScreen());
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