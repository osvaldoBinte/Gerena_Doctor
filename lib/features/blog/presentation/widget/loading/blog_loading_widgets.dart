import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

class BlogGerenaLoading extends StatefulWidget {
  const BlogGerenaLoading({Key? key}) : super(key: key);

  @override
  State<BlogGerenaLoading> createState() => _BlogGerenaLoadingState();
}

class _BlogGerenaLoadingState extends State<BlogGerenaLoading>
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skeleton de las 2 tarjetas principales
            _buildBlogSectionsSkeleton(),
            
            const SizedBox(height: 24),
            
            // Divider
            Container(
              height: 1,
              color: GerenaColors.primaryColor.withOpacity(0.3),
            ),
            
            const SizedBox(height: 24),
            
            // Título "Artículos recientes"
            _buildShimmerBox(
              child: Container(
                height: 24,
                width: 200,
                decoration: BoxDecoration(
                  color: GerenaColors.loadding,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Grid de artículos recientes
            _buildArticlesGridSkeleton(),
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

  Widget _buildBlogSectionsSkeleton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double cardMinWidth = 250.0;
        
        int crossAxisCount = (screenWidth / cardMinWidth).floor();
        crossAxisCount = crossAxisCount.clamp(1, 4);
        
        double crossAxisSpacing = crossAxisCount == 1 ? 0 : 
                                 crossAxisCount == 2 ? 20 : 
                                 crossAxisCount == 3 ? 40 : 60;
        
        double childAspectRatio = crossAxisCount == 1 ? 0.9 : 
                                 crossAxisCount == 2 ? 1.0 : 
                                 0.8;
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: 16,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: 2, // Solo 2 cards para la sección principal
          itemBuilder: (context, index) => _buildArticleCardSkeleton(),
        );
      },
    );
  }

  Widget _buildArticlesGridSkeleton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double cardMinWidth = 250.0;
        
        int crossAxisCount = (screenWidth / cardMinWidth).floor();
        crossAxisCount = crossAxisCount.clamp(1, 4);
        
        double crossAxisSpacing = crossAxisCount == 1 ? 0 : 
                                 crossAxisCount == 2 ? 20 : 
                                 crossAxisCount == 3 ? 40 : 60;
        
        double childAspectRatio = crossAxisCount == 1 ? 0.9 : 
                                 crossAxisCount == 2 ? 1.0 : 
                                 0.8;
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: 16,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: 6, // Muestra 6 cards skeleton
          itemBuilder: (context, index) => _buildArticleCardSkeleton(),
        );
      },
    );
  }

  Widget _buildArticleCardSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: GerenaColors.surfaceColor,
        borderRadius: GerenaColors.mediumBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen skeleton
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: GerenaColors.loaddingwithOpacity1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                    GerenaColors.mediumBorderRadius.topLeft.x),
                topRight: Radius.circular(
                    GerenaColors.mediumBorderRadius.topRight.x),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.article_outlined,
                size: 60,
                color: GerenaColors.loaddingwithOpacity3,
              ),
            ),
          ),
          
          // Contenido
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fecha y categoría
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildShimmerBox(
                      child: Container(
                        height: 12,
                        width: 80,
                        decoration: BoxDecoration(
                          color: GerenaColors.loadding,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    _buildShimmerBox(
                      child: Container(
                        height: 12,
                        width: 90,
                        decoration: BoxDecoration(
                          color: GerenaColors.loadding,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
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
                    width: 180,
                    decoration: BoxDecoration(
                      color: GerenaColors.loadding,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Contenido (3 líneas)
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
                    width: 150,
                    decoration: BoxDecoration(
                      color: GerenaColors.loadding,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Botón "Leer más"
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: GerenaColors.loaddingwithOpacity1,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}