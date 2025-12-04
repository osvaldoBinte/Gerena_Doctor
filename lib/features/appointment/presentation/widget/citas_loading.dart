import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

class CitasLoading extends StatefulWidget {
  const CitasLoading({Key? key}) : super(key: key);

  @override
  State<CitasLoading> createState() => _CitasLoadingState();
}

class _CitasLoadingState extends State<CitasLoading>
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
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    margin: EdgeInsets.only(
                      right: 12,
                      left: index == 0 ? 0 : 0,
                    ),
                    child: _buildCitaCardSkeleton(),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 20),
            _buildPageIndicatorsSkeleton(),
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

  Widget _buildCitaCardSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: GerenaColors.mediumBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: ClipRRect(
        borderRadius: GerenaColors.mediumBorderRadius,
        child: SingleChildScrollView( 
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: GerenaColors.loaddingwithOpacity1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildShimmerBox(
                            child: Container(
                              height: 14,
                              width: 120,
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
                              width: 80,
                              decoration: BoxDecoration(
                                color: GerenaColors.loadding,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                Container(
                  height: 1,
                  color: GerenaColors.primaryColor.withOpacity(0.2),
                ),
                
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Container(
                      width: 45, 
                      height: 45,
                      decoration: BoxDecoration(
                        color: GerenaColors.loaddingwithOpacity1,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildShimmerBox(
                            child: Container(
                              height: 14,
                              width: 140,
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
                  ],
                ),
                
                const SizedBox(height: 12),
                
                _buildShimmerBox(
                  child: Container(
                    height: 12,
                    width: 150,
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
        ),
      ),
    );
  }

  Widget _buildPageIndicatorsSkeleton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        2,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: index == 0 
                ? GerenaColors.primaryColor.withOpacity(0.3)
                : GerenaColors.loaddingwithOpacity1,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}