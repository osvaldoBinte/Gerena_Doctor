import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:get/get.dart';

void showSnackBar(String message, Color color) {
  ScaffoldMessenger.of(Get.context!).clearSnackBars();
  
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: GerenaColors.textLightColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: GerenaColors.textLightColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.all(16),
    ),
  );
}
void showSuccessSnackbar(String message) {
  showSnackBar(message, GerenaColors.successColor);
}

void showErrorSnackbar(String message) {
  showSnackBar(message, GerenaColors.errorColor);
}

void showInfoSnackbar(String message) {
  showSnackBar(message, GerenaColors.primaryColor);
}

void showWarningSnackbar(String message) {
  showSnackBar(message, Colors.orange);
}