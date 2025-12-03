import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

class AddressSelectorLoading extends StatefulWidget {
  const AddressSelectorLoading({Key? key}) : super(key: key);

  @override
  State<AddressSelectorLoading> createState() => _AddressSelectorLoadingState();
}

class _AddressSelectorLoadingState extends State<AddressSelectorLoading>
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
            _buildSelectedAddressSkeleton(),
            const SizedBox(height: 10),
            _buildChangeAddressButtonSkeleton(),
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

  Widget _buildSelectedAddressSkeleton() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          // Icono de check
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: GerenaColors.loaddingwithOpacity1,
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Información de dirección
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre y teléfono
                _buildShimmerBox(
                  child: Container(
                    height: 16,
                    width: 200,
                    decoration: BoxDecoration(
                      color: GerenaColors.loadding,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Dirección línea 1
                _buildShimmerBox(
                  child: Container(
                    height: 13,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: GerenaColors.loadding,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Dirección línea 2
                _buildShimmerBox(
                  child: Container(
                    height: 13,
                    width: 250,
                    decoration: BoxDecoration(
                      color: GerenaColors.loadding,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Icono de editar
          Container(
            margin: const EdgeInsets.only(right: 20),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: GerenaColors.loaddingwithOpacity1,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeAddressButtonSkeleton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: GerenaColors.loaddingwithOpacity1,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 15),
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
          const SizedBox(width: 15),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: GerenaColors.loaddingwithOpacity1,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}