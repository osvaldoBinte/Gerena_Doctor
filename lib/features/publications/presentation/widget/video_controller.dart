import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  final String url;

  VideoController({required this.url});

  late VideoPlayerController videoPlayerController;

  final isInitialized = false.obs;
  final isPlaying = false.obs;
  final isDragging = false.obs;
  final position = 0.0.obs;
  final duration = 0.0.obs;
  final dragValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initVideo();
  }

  Future<void> _initVideo() async {
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(url));
    await videoPlayerController.initialize();

    duration.value =
        videoPlayerController.value.duration.inMilliseconds.toDouble();

    videoPlayerController.addListener(_listener);
    isInitialized.value = true;
  }

  void _listener() {
    if (!isDragging.value) {
      position.value = videoPlayerController.value.position.inMilliseconds
          .toDouble()
          .clamp(0.0, duration.value);
    }
    isPlaying.value = videoPlayerController.value.isPlaying;
  }

  void togglePlayPause() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
    } else {
      videoPlayerController.play();
    }
  }

  void onSliderChangeStart(double value) {
    isDragging.value = true;
    dragValue.value = value;
    videoPlayerController.pause();
  }

  void onSliderChanged(double value) {
    dragValue.value = value;
  }

  void onSliderChangeEnd(double value) async {
    await videoPlayerController.seekTo(Duration(milliseconds: value.toInt()));
    isDragging.value = false;
    videoPlayerController.play();
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get currentPosition => formatDuration(
        Duration(milliseconds: position.value.toInt()),
      );

  String get totalDuration => formatDuration(
        videoPlayerController.value.duration,
      );

  double get sliderValue =>
      isDragging.value ? dragValue.value : position.value;

  double get sliderMax => duration.value > 0 ? duration.value : 1.0;

  @override
  void onClose() {
    videoPlayerController.removeListener(_listener);
    videoPlayerController.dispose();
    super.onClose();
  }
}