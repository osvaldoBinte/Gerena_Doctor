import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gerena/features/publications/presentation/widget/videoItem.dart';

class PostCarousel extends StatefulWidget {
  final List<String> images;
  final double height;

  const PostCarousel({
    Key? key,
    required this.images,
    this.height = 600,
  }) : super(key: key);

  @override
  State<PostCarousel> createState() => _PostCarouselState();
}

class _PostCarouselState extends State<PostCarousel> {
  final CarouselSliderController _carouselController = CarouselSliderController();

  bool _isVideo(String url) {
    final uri = Uri.parse(url);
    final path = uri.path.toLowerCase();
    return path.endsWith('.mp4') || path.endsWith('.mov') || path.endsWith('.avi');
  }

  Widget _buildMediaItem(String url) {
    if (_isVideo(url)) {
      return VideoItem(url: url);
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Icon(Icons.broken_image, size: 48));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: widget.height,
            viewportFraction: 0.85,
            enlargeCenterPage: false,
            enlargeFactor: 0.2,
            enableInfiniteScroll: false,
            autoPlay: false,
          ),
          items: widget.images.map((url) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: _buildMediaItem(url),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}