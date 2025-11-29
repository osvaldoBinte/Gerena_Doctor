import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/stories/presentation/page/story_controller.dart';
import 'package:gerena/features/stories/presentation/page/story_modal_widget.dart';
import 'package:get/get.dart';

class StoryRingWidget extends StatelessWidget {
  final int index;
  final double size;

  const StoryRingWidget({
    Key? key,
    required this.index,
    this.size = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StoryController controller = Get.find<StoryController>();

    return Obx(() {
      // Si está cargando, mostrar loading
      if (controller.isLoading.value) {
        return _buildLoadingRing();
      }

      // Si no hay historias, no mostrar nada
      if (!controller.hasStories(index)) {
        return const SizedBox.shrink();
      }

      final String? profileImage = controller.getUserProfileImage(index);
      final bool hasUnviewed = controller.hasUnviewedStories(index);
      final bool allViewed = controller.hasViewedAllStories(index);

      return GestureDetector(
        onTap: () {
          showStoryModal(context, userIndex: index);
        },
        child: GerenaColors.createStoryRing(
          child: Image.network(
            profileImage ?? '',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  color: Colors.grey[600],
                  size: size * 0.5,
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey[200],
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          ),
          hasStory: true,
          isViewed: allViewed,
          size: size,
        ),
      );
    });
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