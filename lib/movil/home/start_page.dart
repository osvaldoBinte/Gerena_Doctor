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
        // Manejar el botón de retroceso
        return await controller.handleBackButton();
      },
      child: Obx(() => GerenaColors.createMainScaffold(
        body: controller.currentPage,
        currentIndex: controller.selectedIndex.value,
        onNavigationTap: controller.changePage,
        iconPaths: [
          controller.getIconPath(0),
          controller.getIconPath(1),
          controller.getIconPath(2),
          controller.getIconPath(3),
          controller.getIconPath(4),
        ],
        backgroundColor: GerenaColors.backgroundColorFondo,
        bottomNavBackgroundColor: GerenaColors.backgroundColor,
      )),
    );
  }
}