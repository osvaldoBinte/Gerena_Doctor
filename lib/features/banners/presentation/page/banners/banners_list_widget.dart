import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/banners/presentation/controller/banner_controller.dart';
import 'package:get/get.dart';

class BannersListWidget extends StatelessWidget {
  final double? height;
  final EdgeInsetsGeometry? margin;
  final int? maxBanners;
  final VoidCallback? onBannerTap;

  const BannersListWidget({
    Key? key,
    this.height,
    this.margin,
    this.maxBanners,
    this.onBannerTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BannerController>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      if (controller.banners.isEmpty) return const SizedBox.shrink();

      final bannersToShow = maxBanners != null
          ? controller.banners.take(maxBanners!).toList()
          : controller.banners;

      return Column(
        children: bannersToShow.map((banner) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: onBannerTap,
            child: Container(
              height: height ?? (screenWidth < 600 ? 150 : 200),
              margin: margin ?? const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: GerenaColors.mediumBorderRadius,
                child: Image.network(
                  banner.imageUrl ?? '',
                  fit: screenWidth < 600 ? BoxFit.cover : BoxFit.contain,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, color: Colors.grey[600]),
                  ),
                ),
              ),
            ),
          ),
        )).toList(),
      );
    });
  }
}