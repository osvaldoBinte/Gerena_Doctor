import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

class NewsFeedLoading extends StatefulWidget {
  final bool isCompact;
  
  const NewsFeedLoading({
    Key? key,
    this.isCompact = false,
  }) : super(key: key);

  @override
  State<NewsFeedLoading> createState() => _NewsFeedLoadingState();
}

class _NewsFeedLoadingState extends State<NewsFeedLoading>
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
    if (widget.isCompact) {
      return _buildCompactNewsFeedSkeleton();
    } else {
      return _buildFullNewsFeedSkeleton();
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

  Widget _buildFullNewsFeedSkeleton() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildBannerSkeleton(),
            const SizedBox(height: 16),
            _buildBannerSkeleton(),
            const SizedBox(height: 30),
          
          ],
        );
      },
    );
  }

  Widget _buildCompactNewsFeedSkeleton() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: _buildShimmerBox(
                  child: Container(
                    height: 16,
                    width: 100,
                    decoration: BoxDecoration(
                      color: GerenaColors.loadding,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              _buildCompactNewsCardSkeleton(),
              const SizedBox(height: 8),
              _buildCompactNewsCardSkeleton(),
              const SizedBox(height: 8),
              _buildCompactNewsCardSkeleton(),
              const SizedBox(height: 8),
              _buildCompactNewsCardSkeleton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBannerSkeleton() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: GerenaColors.loaddingwithOpacity1,
        borderRadius: GerenaColors.mediumBorderRadius,
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 60,
          color: GerenaColors.loaddingwithOpacity3,
        ),
      ),
    );
  }

  Widget _buildCompactNewsCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GerenaColors.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: GerenaColors.loaddingwithOpacity1,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShimmerBox(
                  child: Container(
                    height: 12,
                    width: 50,
                    decoration: BoxDecoration(
                      color: GerenaColors.loadding,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
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
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: GerenaColors.loaddingwithOpacity3,
          ),
        ],
      ),
    );
  }
}