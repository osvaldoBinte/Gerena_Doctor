import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:get/get.dart';

void showSnackBar(String message, Color color) {
  // 👇 Cierra cualquier snackbar previo
  Get.closeAllSnackbars();

  Get.snackbar(
    '', // título vacío
    message,
    titleText: const SizedBox.shrink(), // 👈 oculta el título
    messageText: Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: GerenaColors.textLightColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: GerenaColors.textLightColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: color,
    snackPosition: SnackPosition.BOTTOM,
    borderRadius: 12,
    margin: const EdgeInsets.all(16),
    duration: const Duration(seconds: 3),
    isDismissible: true,
    overlayBlur: 0,
    overlayColor: Colors.transparent, 
   
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