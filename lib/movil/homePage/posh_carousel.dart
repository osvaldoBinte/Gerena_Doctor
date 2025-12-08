import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
          items: widget.images.map((image) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0), 
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0), 
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
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