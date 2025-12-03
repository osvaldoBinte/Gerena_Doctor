import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

class ShareAndProceduresLoading extends StatefulWidget {


  const ShareAndProceduresLoading({
    Key? key,
  }) : super(key: key);

  @override
  State<ShareAndProceduresLoading> createState() =>
      _ShareAndProceduresLoadingState();
}

class _ShareAndProceduresLoadingState extends State<ShareAndProceduresLoading>
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
          
            _buildProceduresGridSkeleton(),
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

  Widget _buildShareSectionSkeleton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GerenaColors.surfaceColor,
        borderRadius: GerenaColors.mediumBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 12),
          
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: GerenaColors.loaddingwithOpacity1,
                  borderRadius: GerenaColors.smallBorderRadius,
                ),
                child: Center(
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 40,
                    color: GerenaColors.loaddingwithOpacity3,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: GerenaColors.loaddingwithOpacity1,
                  borderRadius: GerenaColors.smallBorderRadius,
                ),
                child: Center(
                  child: Icon(
                    Icons.videocam_outlined,
                    size: 40,
                    color: GerenaColors.loaddingwithOpacity3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProceduresGridSkeleton() {
    return Column(
      children: List.generate(
        2, 
        (rowIndex) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildProcedureCardSkeleton()),
              const SizedBox(width: 16),
              Expanded(child: _buildProcedureCardSkeleton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProcedureCardSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: GerenaColors.surfaceColor,
        borderRadius: GerenaColors.mediumBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: GerenaColors.loaddingwithOpacity1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                    GerenaColors.mediumBorderRadius.topLeft.x),
                topRight: Radius.circular(
                    GerenaColors.mediumBorderRadius.topRight.x),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 50,
                    color: GerenaColors.loaddingwithOpacity3,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: GerenaColors.loaddingwithOpacity1,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    width: 120,
                    decoration: BoxDecoration(
                      color: GerenaColors.loadding,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: GerenaColors.loaddingwithOpacity1,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: GerenaColors.loaddingwithOpacity1,
                        shape: BoxShape.circle,
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
}