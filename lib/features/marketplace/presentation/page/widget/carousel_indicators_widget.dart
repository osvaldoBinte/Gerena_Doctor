import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

enum IndicatorStyle {
  customLines, 
  dots, 
}

class ProductCarouselWidget extends StatefulWidget {
  final List<String> images;
  final IndicatorStyle indicatorStyle;
  final Color? activeIndicatorColor;
  final Color? inactiveIndicatorColor;
  final bool showNavigationButtons;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final double height;
  final String? backgroundImage;
  final double? imagePadding;
  final BoxFit imageFit;
  final double? containerWidth; 
  final double? containerHeight;

  const ProductCarouselWidget({
    Key? key,
    required this.images,
    this.indicatorStyle = IndicatorStyle.dots,
    this.activeIndicatorColor,
    this.inactiveIndicatorColor,
    this.showNavigationButtons = true,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.height = 400,
    this.backgroundImage = 'assets/tienda-producto.png',
    this.imagePadding = 40,
    this.imageFit = BoxFit.contain,
    this.containerWidth,
    this.containerHeight, 
  }) : super(key: key);

  @override
  State<ProductCarouselWidget> createState() => _ProductCarouselWidgetState();
}

class _ProductCarouselWidgetState extends State<ProductCarouselWidget> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  // Obtener las imágenes a mostrar, con fallback a imagen por defecto
  List<String> get _displayImages {
    if (widget.images.isEmpty) {
      return ['assets/tienda-producto.png'];
    }
    return widget.images;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            children: [
              CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: _displayImages.length,
                options: CarouselOptions(
                  height: widget.height,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: _displayImages.length > 1,
                  autoPlay: widget.autoPlay && _displayImages.length > 1, // No autoplay si solo hay una imagen
                  autoPlayInterval: widget.autoPlayInterval,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  return _buildCarouselItem(_displayImages[index]);
                },
              ),

              // Solo mostrar indicadores si hay más de una imagen
              if (_displayImages.length > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: widget.indicatorStyle == IndicatorStyle.customLines
                      ? _buildCustomIndicators()
                      : _buildDotIndicators(),
                ),
            ],
          ),

          // Solo mostrar botones de navegación si hay más de una imagen
          if (widget.showNavigationButtons && _displayImages.length > 1) ...[
            Positioned(
              left: 10,
              top: widget.height / 2 - 20,
              child: _buildNavigationButton(
                icon: Icons.chevron_left,
                onPressed: () {
                  _carouselController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
            Positioned(
              right: 10,
              top: widget.height / 2 - 20,
              child: _buildNavigationButton(
                icon: Icons.chevron_right,
                onPressed: () {
                  _carouselController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCarouselItem(String imageUrl) {
    // Si la imagen es la imagen por defecto y viene de images vacío
    final bool isDefaultImage = widget.images.isEmpty && 
                                 imageUrl == 'assets/tienda-producto.png';
    
    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.backgroundImage != null && !isDefaultImage)
          Center(
            child: Container(
              width: widget.containerWidth ?? 350, 
              height: widget.containerHeight ?? 350, 
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [GerenaColors.lightShadow],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.backgroundImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                    );
                  },
                ),
              ),
            ),
          ),

        // Si es la imagen por defecto, mostrarla directamente sin padding
        isDefaultImage
            ? Center(
                child: Container(
                  width: widget.containerWidth ?? 350, 
                  height: widget.containerHeight ?? 350, 
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [GerenaColors.lightShadow],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Imagen no disponible',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.all(widget.imagePadding ?? 40),
                child: _buildImage(imageUrl),
              ),
      ],
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: widget.imageFit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: GerenaColors.primaryColor,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image,
                  size: 60,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 8),
                Text(
                  'Error al cargar imagen',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        fit: widget.imageFit,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 60,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 8),
                Text(
                  'Imagen no disponible',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  // Botones de navegación
  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: GerenaColors.secondaryColor,
          shape: BoxShape.circle,
          boxShadow: [GerenaColors.lightShadow],
        ),
        child: Icon(icon, color: GerenaColors.textLightColor, size: 24),
      ),
    );
  }

  Widget _buildCustomIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAnimatedIndicator(0, 20),
        const SizedBox(width: 6),
        _buildAnimatedIndicator(1, 80),
        const SizedBox(width: 6),
        _buildAnimatedIndicator(2, 30),
      ],
    );
  }

  Widget _buildDotIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _displayImages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: _currentIndex == index ? 40 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _currentIndex == index
                ? (widget.activeIndicatorColor ?? GerenaColors.secondaryColor)
                : (widget.inactiveIndicatorColor ?? Colors.grey[300]),
            borderRadius: BorderRadius.circular(4),
            boxShadow: _currentIndex == index
                ? [
                    BoxShadow(
                      color: (widget.activeIndicatorColor ??
                              GerenaColors.secondaryColor)
                          .withOpacity(0.5),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIndicator(int indicatorIndex, double baseWidth) {
    final isActive = _currentIndex == indicatorIndex;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isActive ? baseWidth + 10 : baseWidth,
      height: isActive ? 7 : 5,
      decoration: BoxDecoration(
        color: isActive
            ? (widget.activeIndicatorColor ?? GerenaColors.secondaryColor)
            : (widget.inactiveIndicatorColor ?? GerenaColors.backgroundColor),
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          isActive
              ? BoxShadow(
                  color: (widget.activeIndicatorColor ??
                          GerenaColors.secondaryColor)
                      .withOpacity(0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              : GerenaColors.mediumShadow,
        ],
      ),
    );
  }
}