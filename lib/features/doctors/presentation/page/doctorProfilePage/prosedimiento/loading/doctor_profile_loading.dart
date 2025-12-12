import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorProfileLoading extends StatefulWidget {
  const DoctorProfileLoading({Key? key}) : super(key: key);

  @override
  State<DoctorProfileLoading> createState() => _DoctorProfileLoadingState();
}

class _DoctorProfileLoadingState extends State<DoctorProfileLoading>
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
    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorFondo,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: GerenaColors.backgroundColorFondo,
          elevation: 4,
          shadowColor: GerenaColors.shadowColor,
        ),
      ),
      body: AnimatedBuilder(
        animation: _shimmerAnimation,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildDoctorHeaderSkeleton(),
                ),
                const SizedBox(height: 16),
                Divider(height: 2, color: GerenaColors.dividerColor),
                const SizedBox(height: 16),
                _buildWishlistButtonSkeleton(),
                const SizedBox(height: 16),
                Divider(height: 2, color: GerenaColors.dividerColor),
                const SizedBox(height: 16),
                SizedBox(height: GerenaColors.paddingMedium),
                _buildStatusCardSkeleton(),
                const SizedBox(height: 16),
                Divider(height: 2, color: GerenaColors.dividerColor),
                _buildRewardsSectionSkeleton(),
                const SizedBox(height: 16),
                Divider(height: 2, color: GerenaColors.dividerColor),
                const SizedBox(height: 16),
                _buildExecutiveSectionSkeleton(),
                const SizedBox(height: 16),
                Divider(height: 2, color: GerenaColors.dividerColor),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildShimmerBox(
                    child: Container(
                      height: 18,
                      width: 120,
                      decoration: BoxDecoration(
                        color: GerenaColors.loadding,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildPortfolioSectionSkeleton(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildShimmerBox(
                        child: Container(
                          height: 18,
                          width: 200,
                          decoration: BoxDecoration(
                            color: GerenaColors.loadding,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildReviewsSkeleton(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Divider(height: 2, color: GerenaColors.dividerColor),
                _buildMenuItemsSkeleton(),
                const SizedBox(height: 32),
              ],
            ),
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

  Widget _buildDoctorHeaderSkeleton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: GerenaColors.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: GerenaColors.loaddingwithOpacity1,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: GerenaColors.loaddingwithOpacity3,
                    ),
                  ),
                  SizedBox(height: GerenaColors.paddingExtraLarge),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Icon(
                          Icons.star,
                          size: 16,
                          color: GerenaColors.loaddingwithOpacity1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildShimmerBox(
                    child: Container(
                      height: 12,
                      width: 30,
                      decoration: BoxDecoration(
                        color: GerenaColors.loadding,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
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
                        height: 14,
                        width: 150,
                        decoration: BoxDecoration(
                          color: GerenaColors.loadding,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildShimmerBox(
                      child: Container(
                        height: 14,
                        width: 80,
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
                    const SizedBox(height: 4),
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
                    const SizedBox(height: 16),
                  
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
              ),
            ],
          ),
          SizedBox(height: GerenaColors.paddingMedium),
       
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: GerenaColors.loaddingwithOpacity1,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: GerenaColors.loaddingwithOpacity1,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
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
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildShimmerBox(
              child: Container(
                height: 14,
                decoration: BoxDecoration(
                  color: GerenaColors.loadding,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCardSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: GerenaColors.cardDecoration,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Container(
                width: 80,
                height: 30,
                decoration: BoxDecoration(
                  color: GerenaColors.loaddingwithOpacity1,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              3,
              (index) => Column(
                children: [
                  _buildShimmerBox(
                    child: Container(
                      height: 20,
                      width: 40,
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
                      width: 60,
                      decoration: BoxDecoration(
                        color: GerenaColors.loadding,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsSectionSkeleton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShimmerBox(
                child: Container(
                  height: 16,
                  width: 120,
                  decoration: BoxDecoration(
                    color: GerenaColors.loadding,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildShimmerBox(
                child: Container(
                  height: 16,
                  width: 80,
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
    );
  }

  Widget _buildExecutiveSectionSkeleton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
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
                const SizedBox(height: 8),
                _buildShimmerBox(
                  child: Container(
                    height: 13,
                    width: 120,
                    decoration: BoxDecoration(
                      color: GerenaColors.loadding,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                _buildShimmerBox(
                  child: Container(
                    height: 11,
                    width: 180,
                    decoration: BoxDecoration(
                      color: GerenaColors.loadding,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 100,
            height: 35,
            decoration: BoxDecoration(
              color: GerenaColors.loaddingwithOpacity1,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioSectionSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: List.generate(
              3,
              (index) => Expanded(
                child: Container(
                  height: 120,
                  margin: EdgeInsets.only(
                    right: index < 2 ? 8 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: GerenaColors.loaddingwithOpacity1,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSkeleton() {
    return Column(
      children: List.generate(
        2,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: GerenaColors.cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: GerenaColors.loaddingwithOpacity1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        const SizedBox(height: 4),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              Icons.star,
                              size: 14,
                              color: GerenaColors.loaddingwithOpacity1,
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
                  width: 200,
                  decoration: BoxDecoration(
                    color: GerenaColors.loadding,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemsSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(
          4,
          (index) => Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _buildShimmerBox(
              child: Container(
                height: 14,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: GerenaColors.loadding,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}