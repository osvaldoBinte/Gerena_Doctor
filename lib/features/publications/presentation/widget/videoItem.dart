import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'video_controller.dart';

class VideoItem extends StatelessWidget {
  final String url;

  const VideoItem({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      VideoController(url: url),
      tag: url, 
    );

    return Obx(() {
      if (!controller.isInitialized.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Stack(
        alignment: Alignment.center,
        children: [
          // Video
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.videoPlayerController.value.size.width,
                height: controller.videoPlayerController.value.size.height,
                child: VideoPlayer(controller.videoPlayerController),
              ),
            ),
          ),

          // Controles arriba
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
              child: Row(
                children: [
                  // Play/Pause
                  GestureDetector(
                    onTap: controller.togglePlayPause,
                    child: Icon(
                      controller.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 4),

                  // Tiempo actual
                  Text(
                    controller.currentPosition,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),

                  // Slider
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                        trackHeight: 2.5,
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.white30,
                        thumbColor: Colors.white,
                        overlayColor: Colors.white24,
                      ),
                      child: Slider(
                        min: 0.0,
                        max: controller.sliderMax,
                        value: controller.sliderValue.clamp(0.0, controller.sliderMax),
                        onChangeStart: controller.onSliderChangeStart,
                        onChanged: controller.onSliderChanged,
                        onChangeEnd: controller.onSliderChangeEnd,
                      ),
                    ),
                  ),

                  // Duración total
                  Text(
                    controller.totalDuration,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),

          // Tap centro play/pause
          GestureDetector(
            onTap: controller.togglePlayPause,
            child: Container(color: Colors.transparent),
          ),
        ],
      );
    });
  }
}