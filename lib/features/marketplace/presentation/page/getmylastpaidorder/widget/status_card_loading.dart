import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

class StatusCardLoading extends StatefulWidget {
  const StatusCardLoading({Key? key}) : super(key: key);

  @override
  State<StatusCardLoading> createState() => _StatusCardLoadingState();
}

class _StatusCardLoadingState extends State<StatusCardLoading>
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: GerenaColors.smallBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: AnimatedBuilder(
        animation: _shimmerAnimation,
        builder: (context, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con título y folio
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Título "ESTATUS DE PEDIDO:"
                  _buildShimmerBox(
                    child: Container(
                      height: 12,
                      width: 140,
                      decoration: BoxDecoration(
                        color: GerenaColors.loadding,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  
                  // Folio section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildShimmerBox(
                        child: Container(
                          height: 10,
                          width: 40,
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
                          width: 60,
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
              
              const SizedBox(height: 8),
              
              // Status row skeleton
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _buildStatusRowSkeleton(),
              ),
            ],
          );
        },
      ),
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

  List<Widget> _buildStatusRowSkeleton() {
    List<Widget> widgets = [];
    
    for (int i = 0; i < 4; i++) {
      widgets.add(_buildStatusItemSkeleton());
      
      if (i < 3) {
        widgets.add(_buildStatusLineSkeleton());
      }
    }
    
    return widgets;
  }

  Widget _buildStatusItemSkeleton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ícono circular skeleton
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: GerenaColors.loaddingwithOpacity1,
            shape: BoxShape.circle,
          ),
        ),
        
        const SizedBox(height: 4),
        
        // Texto skeleton (2 líneas)
        SizedBox(
          width: 50,
          height: 32,
          child: Column(
            children: [
              _buildShimmerBox(
                child: Container(
                  height: 8,
                  width: 45,
                  decoration: BoxDecoration(
                    color: GerenaColors.loadding,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              _buildShimmerBox(
                child: Container(
                  height: 8,
                  width: 35,
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
    );
  }

  Widget _buildStatusLineSkeleton() {
    return Container(
      width: 20,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: GerenaColors.loaddingwithOpacity1,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}