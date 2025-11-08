
import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
import 'package:get/get.dart'; 
  Widget buildCompactNewsCard(
    String category, 
    String title, 
    String subtitle, {
    VoidCallback? onTap, 
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF00414A),
          borderRadius: GerenaColors.smallBorderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: TextStyle(
                color: GerenaColors.secondaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                color: GerenaColors.textLightColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget buildQuestionCard() {
    return GestureDetector(
      onTap: () {
        _navigateToForum();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: GerenaColors.smallBorderRadius,
          boxShadow: [GerenaColors.lightShadow],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Recomendación de marcas para aplicación de ácido hialurónico?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: GerenaColors.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '82 comentarios',
                  style: TextStyle(
                    color: GerenaColors.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
   void _navigateToForum() {
    Get.find<ShopNavigationController>().navigateToBlogGerena();
      Get.to(() => GlobalShopInterface());
  }