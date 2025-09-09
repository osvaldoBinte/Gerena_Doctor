
import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/movil/perfil/perfil_controller.dart';
import 'package:get/get.dart';

Widget buildImageGallery(List<String> images) {
  if (images.isEmpty) return SizedBox.shrink();
  
  final PerfilController perfilController = Get.find<PerfilController>();
  
  List<Widget> pages = [];
  for (int i = 0; i < images.length; i += 2) {
    pages.add(
      Row(
        children: [
          Expanded(
            child: Container(
              height: 150,
              margin: EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(images[i]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          if (i + 1 < images.length)
            Expanded(
              child: Container(
                height: 150,
                margin: EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(images[i + 1]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          else
            Expanded(child: SizedBox()),
        ],
      ),
    );
  }
  
  return Column(
    children: [
      Container(
        height: 150,
        child: PageView(
          controller: perfilController.pageController,
          onPageChanged: (page) {
            perfilController.onImagePageChanged(page);
          },
          children: pages,
        ),
      ),
      
      if (pages.length > 1) ...[
        SizedBox(height: 12),
        Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            pages.length,
            (index) => Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == perfilController.currentImagePage.value
                  ? GerenaColors.primaryColor
                  : Colors.grey.withOpacity(0.3),
              ),
            ),
          ),
        )),
      ],
    ],
  );
}