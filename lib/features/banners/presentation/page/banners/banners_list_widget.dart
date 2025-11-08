import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/banners/domain/entity/banners_entity.dart';
import 'package:gerena/features/banners/presentation/controller/banner_controller.dart';
import 'package:get/get.dart';

class BannersListWidget extends StatelessWidget {
  final bool showLoading;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final int? maxBanners; // Límite de banners a mostrar
  final VoidCallback? onBannerTap;

  const BannersListWidget({
    Key? key,
    this.showLoading = true,
    this.height,
    this.margin,
    this.maxBanners,
    this.onBannerTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BannerController controller = Get.find<BannerController>();

    return Obx(() {
      // Mostrar loading
      if (controller.isLoading.value && controller.banners.isEmpty) {
        if (!showLoading) return const SizedBox.shrink();
        
        return Container(
          height: height ?? 200,
          margin: margin ?? const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: GerenaColors.backgroundColor,
            borderRadius: GerenaColors.mediumBorderRadius,
            boxShadow: [GerenaColors.lightShadow],
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: GerenaColors.primaryColor,
            ),
          ),
        );
      }

      // Mostrar error
      if (controller.errorMessage.value.isNotEmpty) {
        return Container(
          height: height ?? 200,
          margin: margin ?? const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: GerenaColors.backgroundColor,
            borderRadius: GerenaColors.mediumBorderRadius,
            boxShadow: [GerenaColors.lightShadow],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: GerenaColors.textSecondaryColor,
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    controller.errorMessage.value,
                    style: TextStyle(
                      color: GerenaColors.textSecondaryColor,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => controller.refreshBanners(),
                  child: Text(
                    'Reintentar',
                    style: TextStyle(
                      color: GerenaColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Si no hay banners
      if (controller.banners.isEmpty) {
        return const SizedBox.shrink();
      }

      // Obtener la lista de banners (limitada si es necesario)
      final List<BannersEntity> bannersToShow = maxBanners != null
          ? controller.banners.take(maxBanners!).toList()
          : controller.banners;

      // Si solo hay un banner
      if (bannersToShow.length == 1) {
        return _BannerCard(
          banner: bannersToShow.first,
          height: height,
          margin: margin,
          onTap: onBannerTap,
        );
      }

      // Si hay múltiples banners
      return Column(
        children: bannersToShow.map((banner) {
          return Column(
            children: [
              _BannerCard(
                banner: banner,
                height: height,
                margin: margin,
                onTap: onBannerTap,
              ),
              SizedBox(height: GerenaColors.paddingMedium),
            ],
          );
        }).toList(),
      );
    });
  }
}

class _BannerCard extends StatelessWidget {
  final BannersEntity banner;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const _BannerCard({
    Key? key,
    required this.banner,
    this.height,
    this.margin,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: GerenaColors.mediumBorderRadius,
          child: banner.imageUrl != null && banner.imageUrl!.isNotEmpty
              ? Image.network(
                  banner.imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              size: 50,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              banner.nombre ?? 'Banner',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: GerenaColors.primaryColor,
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          banner.nombre ?? 'Sin imagen',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}