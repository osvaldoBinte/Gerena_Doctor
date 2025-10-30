// lib/common/widgets/product_carousel_widget.dart

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

enum IndicatorStyle {
  customLines, // 3 líneas personalizadas
  dots, // Puntos normales
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
  final double? containerWidth; // ⭐ NUEVO
  final double? containerHeight; // ⭐ NUEVO

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
    this.containerWidth, // ⭐ NUEVO - null = usa 350 por defecto
    this.containerHeight, // ⭐ NUEVO - null = usa 350 por defecto
  }) : super(key: key);

  @override
  State<ProductCarouselWidget> createState() => _ProductCarouselWidgetState();
}

class _ProductCarouselWidgetState extends State<ProductCarouselWidget> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            children: [
              // Carrusel de imágenes
              CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: widget.images.length,
                options: CarouselOptions(
                  height: widget.height,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: widget.images.length > 1,
                  autoPlay: widget.autoPlay,
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
                  return _buildCarouselItem(widget.images[index]);
                },
              ),

              // Indicadores
              if (widget.images.length > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: widget.indicatorStyle == IndicatorStyle.customLines
                      ? _buildCustomIndicators()
                      : _buildDotIndicators(),
                ),
            ],
          ),

          // Botones de navegación
          if (widget.showNavigationButtons && widget.images.length > 1) ...[
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

  // Item del carrusel
  Widget _buildCarouselItem(String imageUrl) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Imagen de fondo decorativa
        if (widget.backgroundImage != null)
          Center(
            child: Container(
              width: widget.containerWidth ?? 350, // ⭐ MODIFICADO
              height: widget.containerHeight ?? 350, // ⭐ MODIFICADO
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

        // Imagen del producto
        Container(
          padding: EdgeInsets.all(widget.imagePadding ?? 40),
          child: _buildImage(imageUrl),
        ),
      ],
    );
  }

  // Construir imagen (red o asset)
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
          return Icon(
            Icons.image,
            size: 100,
            color: Colors.grey[400],
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        fit: widget.imageFit,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.image,
            size: 100,
            color: Colors.grey[400],
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

  // ⭐ INDICADORES PERSONALIZADOS (3 líneas)
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

  // ⭐ INDICADORES CON PUNTOS
  Widget _buildDotIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.images.length,
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

  // ⭐ Indicador animado para las 3 líneas personalizadas
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