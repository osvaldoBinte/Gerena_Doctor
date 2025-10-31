
import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';


Widget buildWishlistButton({
  VoidCallback? onTap,
  bool showShadow = true, 
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 13),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: GerenaColors.textLightColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: GerenaColors.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ]
            : null, 
      ),
      child: Row(
        children: [
          Icon(
            Icons.favorite, 
            color: GerenaColors.textPrimaryColor,
            size: 24,
          ),
          Expanded(
            child: Container(
              height: 1, 
              margin: const EdgeInsets.symmetric(horizontal: 12), 
              color: GerenaColors.textPrimaryColor, 
            ),
          ),
          Text(
            'WISHLIST',
            style: TextStyle(
              color: GerenaColors.textPrimaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}
  
  Widget buildWebinarCard() {
    return ClipRRect(
    borderRadius: GerenaColors.smallBorderRadius,
    child: Image.asset(
      'assets/Webinar.png',
      fit: BoxFit.cover,
      width: double.infinity,
    ),
  );
  }
Widget buildPromoCard() {
  return ClipRRect(
    borderRadius: GerenaColors.smallBorderRadius,
    child: Image.asset(
      'assets/example/promocion.png',
      fit: BoxFit.cover,
      width: double.infinity,
    ),
  );
}