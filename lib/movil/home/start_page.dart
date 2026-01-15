import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:get/get.dart';
import 'start_controller.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StartController controller = Get.put(StartController());

    return WillPopScope(
      onWillPop: () async {
        return await controller.handleBackButton();
      },
      child: Obx(() {
        final _ = controller.shouldShowBlog;
        
        return GerenaColors.createMainScaffold(
          body: controller.currentPage,
          currentIndex: controller.selectedIndex.value,
          onNavigationTap: controller.changePage,
          iconPaths: List.generate(
            controller.iconPaths.length,
            (index) => controller.getIconPath(index),
          ),
          backgroundColor: GerenaColors.backgroundColorFondo,
          bottomNavBackgroundColor: GerenaColors.backgroundColor,
        );
      }),
    );
  }
}