import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:google_fonts/google_fonts.dart';

class OffersLoading extends StatefulWidget {
  const OffersLoading({Key? key}) : super(key: key);

  @override
  State<OffersLoading> createState() => _OffersLoadingState();
}

class _OffersLoadingState extends State<OffersLoading>
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'OFERTAS DE PRIMAVERA',
                    style: GoogleFonts.rubik(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: GerenaColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        AnimatedBuilder(
          animation: _shimmerAnimation,
          builder: (context, child) {
            return Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: GerenaColors.loaddingwithOpacity1,
                    shape: BoxShape.circle,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                Expanded(
                  child: SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: _buildProductCardSkeleton(),
                        );
                      },
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
            );
          },
        ),

        const SizedBox(height: 24),
      ],
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

  Widget _buildProductCardSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: GerenaColors.mediumBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: ClipRRect(
        borderRadius: GerenaColors.mediumBorderRadius,
        child: SingleChildScrollView( 
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    height: 120, 
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
                        Icons.local_offer_outlined,
                        size: 40, 
                        color: GerenaColors.loaddingwithOpacity3,
                      ),
                    ),
                  ),
                  
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: GerenaColors.loaddingwithOpacity1,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _buildShimmerBox(
                        child: Container(
                          height: 10, 
                          width: 30, 
                          decoration: BoxDecoration(
                            color: GerenaColors.loadding,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: GerenaColors.loaddingwithOpacity1,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              
              Padding(
                padding: const EdgeInsets.all(10), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                        width: 100, 
                        decoration: BoxDecoration(
                          color: GerenaColors.loadding,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 6),
                    
                    _buildShimmerBox(
                      child: Container(
                        height: 10, 
                        width: 50, 
                        decoration: BoxDecoration(
                          color: GerenaColors.loadding,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 3), 
                    
                    _buildShimmerBox(
                      child: Container(
                        height: 16, 
                        width: 70,
                        decoration: BoxDecoration(
                          color: GerenaColors.loadding,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8), 
                    
                    Container(
                      width: double.infinity,
                      height: 32,
                      decoration: BoxDecoration(
                        color: GerenaColors.loaddingwithOpacity1,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}