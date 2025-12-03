import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

enum LoadingType {
  offers,    
  catalog,    
  categories,  
}

class GlobalShopLoading extends StatefulWidget {
  final LoadingType loadingType;
  
  const GlobalShopLoading({
    Key? key,
    required this.loadingType,
  }) : super(key: key);

  @override
  State<GlobalShopLoading> createState() => _GlobalShopLoadingState();
}

class _GlobalShopLoadingState extends State<GlobalShopLoading>
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
    switch (widget.loadingType) {
      case LoadingType.offers:
        return _buildOffersLoading();
      case LoadingType.catalog:
        return _buildCatalogLoading();
      case LoadingType.categories:
        return _buildCategoriesLoading();
    }
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

  Widget _buildOffersLoading() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: GerenaColors.loaddingwithOpacity1,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                
                Expanded(
                  child: Row(
                    children: List.generate(
                      3,
                      (index) => Expanded(
                        child: Container(
                          height: 280,
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: _buildProductCardSkeleton(),
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: GerenaColors.loaddingwithOpacity1,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCatalogLoading() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(40.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 8, 
            itemBuilder: (context, index) {
              return _buildProductCardSkeleton();
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoriesLoading() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: List.generate(
                5,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: GerenaColors.loaddingwithOpacity1,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildShimmerBox(
                          child: Container(
                            height: 16,
                            decoration: BoxDecoration(
                              color: GerenaColors.loadding,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductCardSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: GerenaColors.loaddingwithOpacity1,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.image_outlined,
                size: 50,
                color: GerenaColors.loaddingwithOpacity3,
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    width: 100,
                    decoration: BoxDecoration(
                      color: GerenaColors.loadding,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                
                _buildShimmerBox(
                  child: Container(
                    height: 18,
                    width: 80,
                    decoration: BoxDecoration(
                      color: GerenaColors.loadding,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                Container(
                  width: double.infinity,
                  height: 36,
                  decoration: BoxDecoration(
                    color: GerenaColors.loaddingwithOpacity1,
                    borderRadius: BorderRadius.circular(18),
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