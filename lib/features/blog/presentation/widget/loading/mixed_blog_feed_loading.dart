import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

class MixedBlogFeedLoading extends StatefulWidget {
  const MixedBlogFeedLoading({Key? key}) : super(key: key);

  @override
  State<MixedBlogFeedLoading> createState() => _MixedBlogFeedLoadingState();
}

class _MixedBlogFeedLoadingState extends State<MixedBlogFeedLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: false);

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3, // Mostrar 3 cards skeleton
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                // Alternar entre diferentes tipos de cards para variedad
                if (index == 0) {
                  return _buildArticleCardSkeleton();
                } else if (index == 1) {
                  return _buildQuestionCardSkeleton();
                } else {
                  return _buildArticleCardSkeleton();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerBox({required Widget child}) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, _) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                GerenaColors.loaddingwithOpacity1,
                GerenaColors.loaddingwithOpacity3,
                GerenaColors.loaddingwithOpacity1
              ],
              stops: [
                _shimmerAnimation.value - 1,
                _shimmerAnimation.value,
                _shimmerAnimation.value + 1,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }

  Widget _buildArticleCardSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: GerenaColors.smallBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen skeleton
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: GerenaColors.loaddingwithOpacity1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(GerenaColors.smallBorderRadius.topLeft.x),
                topRight: Radius.circular(GerenaColors.smallBorderRadius.topRight.x),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.image_outlined,
                size: 60,
                color: GerenaColors.loaddingwithOpacity3,
              ),
            ),
          ),
          
          // Contenido
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge de tipo
                _buildShimmerBox(
                  child: Container(
                    height: 20,
                    width: 100,
                    decoration: BoxDecoration(
                      color: GerenaColors.loadding,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Título
                _buildShimmerBox(
                  child: Container(
                    height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: GerenaColors.loadding,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildShimmerBox(
                  child: Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: GerenaColors.loadding,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Contenido/descripción
                _buildShimmerBox(
                  child: Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: GerenaColors.loadding,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                _buildShimmerBox(
                  child: Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: GerenaColors.loadding,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                _buildShimmerBox(
                  child: Container(
                    height: 14,
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      color: GerenaColors.loadding,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Botón "Leer más"
                Row(
                  children: [
                    Container(
                      height: 36,
                      width: 100,
                      decoration: BoxDecoration(
                        color: GerenaColors.loaddingwithOpacity1,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCardSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: GerenaColors.smallBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge de tipo pregunta
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: GerenaColors.loaddingwithOpacity1,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildShimmerBox(
                      child: Container(
                        height: 12,
                        width: 60,
                        decoration: BoxDecoration(
                          color: GerenaColors.loadding,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 20,
                      height: 16,
                      decoration: BoxDecoration(
                        color: GerenaColors.loaddingwithOpacity3,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Título de la pregunta
          _buildShimmerBox(
            child: Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: GerenaColors.loadding,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildShimmerBox(
            child: Container(
              height: 16,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                color: GerenaColors.loadding,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // "Ver comentarios"
          Row(
            children: [
              _buildShimmerBox(
                child: Container(
                  height: 12,
                  width: 100,
                  decoration: BoxDecoration(
                    color: GerenaColors.loadding,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}