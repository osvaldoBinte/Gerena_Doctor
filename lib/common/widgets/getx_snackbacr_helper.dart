import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:get/get.dart';

void showSnackBarGetx(String message, Color color) {
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

void showGetxSuccessSnackbar(String message) {
  showSnackBarGetx(message, GerenaColors.successColor);
}

void showGetxErrorSnackbar(String message) {
  showSnackBarGetx(message, GerenaColors.errorColor);
}

void showGetxInfoSnackbar(String message) {
  showSnackBarGetx(message, GerenaColors.primaryColor);
}

void showGetxWarningSnackbar(String message) {
  showSnackBarGetx(message, Colors.orange);
}