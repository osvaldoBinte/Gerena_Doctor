import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

class ReviewsLoading extends StatefulWidget {
  const ReviewsLoading({Key? key}) : super(key: key);

  @override
  State<ReviewsLoading> createState() => _ReviewsLoadingState();
}

class _ReviewsLoadingState extends State<ReviewsLoading>
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              3, 
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildReviewCardSkeleton(),
              ),
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

  Widget _buildReviewCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: GerenaColors.smallBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReviewHeaderSkeleton(),
          const SizedBox(height: 8),
          
          _buildShimmerBox(
            child: Container(
              height: 14,
              width: 180,
              decoration: BoxDecoration(
                color: GerenaColors.loadding,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          _buildShimmerBox(
            child: Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: GerenaColors.loadding,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 4),
          _buildShimmerBox(
            child: Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: GerenaColors.loadding,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 4),
          _buildShimmerBox(
            child: Container(
              height: 12,
              width: 250,
              decoration: BoxDecoration(
                color: GerenaColors.loadding,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          _buildReviewImagesSkeleton(),
          
          const SizedBox(height: 8),
          _buildReviewFooterSkeleton(),
        ],
      ),
    );
  }

  Widget _buildReviewHeaderSkeleton() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: GerenaColors.loaddingwithOpacity1,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        
        Expanded(
          child: Row(
            children: List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Icon(
                  Icons.star,
                  color: GerenaColors.loaddingwithOpacity1,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewImagesSkeleton() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          2, 
          (index) => Container(
            width: 120,
            height: 100,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: GerenaColors.smallBorderRadius,
              color: GerenaColors.loaddingwithOpacity1,
            ),
            child: Center(
              child: Icon(
                Icons.image_outlined,
                color: GerenaColors.loaddingwithOpacity3,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewFooterSkeleton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
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
        const SizedBox(width: 8),
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
    );
  }
}