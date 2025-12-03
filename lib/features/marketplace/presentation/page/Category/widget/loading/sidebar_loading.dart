import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/presentation/page/Category/widget/half_cut_circle.dart';

class SidebarLoading extends StatefulWidget {
  const SidebarLoading({Key? key}) : super(key: key);

  @override
  State<SidebarLoading> createState() => _SidebarLoadingState();
}

class _SidebarLoadingState extends State<SidebarLoading>
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
        return Container(
          width: 350,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/menu/MENUGERENA.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/gerena-logo-home.png',
                                      height: 45,
                                    ),
                                  ],
                                ),
                              ),
                              _buildSearchFieldSkeleton(),
                              
                              const SizedBox(height: 10),
                              _buildWishlistButtonSkeleton(),
                              
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Row(
                                  children: [
                                    _buildShimmerBox(
                                      child: Container(
                                        height: 16,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: GerenaColors.loadding,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _buildCatalogGridSkeleton(),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
                _buildContactButtonSkeleton(),
               
                Container(
                  width: 60,
                  height: 4,
                  margin: const EdgeInsets.only(top: 8, bottom: 12),
                  decoration: BoxDecoration(
                    color: GerenaColors.surfaceColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
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

  Widget _buildSearchFieldSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 12),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: GerenaColors.loaddingwithOpacity1,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: GerenaColors.loaddingwithOpacity1,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistButtonSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 13),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: GerenaColors.loaddingwithOpacity1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: GerenaColors.loaddingwithOpacity3,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: GerenaColors.loaddingwithOpacity3,
            ),
          ),
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
        ],
      ),
    );
  }

  Widget _buildCatalogGridSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.8,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        itemBuilder: (context, index) {
          return _buildCategoryItemSkeleton();
        },
      ),
    );
  }

  Widget _buildCategoryItemSkeleton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PhysicalShape(
          clipper: BottomFlatClipper(),
          color: GerenaColors.loaddingwithOpacity1,
          elevation: 4,
          shadowColor: Colors.black,
          child: Container(
            width: 80,
            height: 80,
            child: Center(
              child: Icon(
                Icons.category_outlined,
                size: 30,
                color: GerenaColors.loaddingwithOpacity3,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        _buildShimmerBox(
          child: Container(
            height: 11,
            width: 60,
            decoration: BoxDecoration(
              color: GerenaColors.loadding,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactButtonSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: GerenaColors.surfaceColor,
        borderRadius: GerenaColors.smallBorderRadius,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: GerenaColors.surfaceColor,
            ),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: GerenaColors.loaddingwithOpacity1,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: GerenaColors.loaddingwithOpacity1,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}