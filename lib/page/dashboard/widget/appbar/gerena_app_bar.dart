import 'package:flutter/material.dart'; 
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/page/dashboard/widget/appbar/gerena_app_bar_controller.dart';
import 'package:gerena/page/dashboard/widget/notificasiones/notification_modal.dart';
import 'package:get/get.dart'; 
import 'package:window_manager/window_manager.dart';
import 'dart:io' show Platform;

class GerenaAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool? showWindowControls;
  final bool showActionIcons;
  final bool showUserProfile;
  
  const GerenaAppBar({
    Key? key,
    this.showWindowControls,
    this.showActionIcons = true,
    this.showUserProfile = true,
  }) : super(key: key);

  @override
  State<GerenaAppBar> createState() => _GerenaAppBarState();
  
  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _GerenaAppBarState extends State<GerenaAppBar> {
  final appBarController = Get.put(GerenaAppBarController());

  bool get shouldShowCustomControls {
    if (widget.showWindowControls != null) {
      return widget.showWindowControls!;
    }
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  bool get isDesktop {
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: isDesktop ? () async {
        if (await windowManager.isMaximized()) {
          windowManager.unmaximize();
        } else {
          windowManager.maximize();
        }
      } : null,
      onPanStart: isDesktop ? (details) {
        windowManager.startDragging();
      } : null,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: GerenaColors.primaryColor, 
          image: const DecorationImage(
            image: AssetImage('assets/BARRA-DE-ACCIONES.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            if (shouldShowCustomControls) _buildWindowControls(),
            
            if (shouldShowCustomControls)
              Expanded(
                child: Container(color: Colors.transparent),
              )
            else
              const Spacer(),
            
            if (widget.showActionIcons) _buildActionIcons(),
            
            if (widget.showUserProfile) _buildUserProfileButton(),
            
            if (Platform.isWindows && !shouldShowCustomControls) 
              const SizedBox(width: 120),
            
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildWindowControls() {
    return Row(
      children: [
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildActionIcons() {
    return Row(
      children: [
        InkWell(
          onTap: appBarController.navigateToDashboard,
          child: Container(
            width: 36,
            height: 36,
            padding: const EdgeInsets.all(6),
            child: Image.asset('assets/home.png', width: 24, height: 24),
          ),
        ),
        const SizedBox(width: 10),
        
        InkWell(
          onTap: appBarController.navigateportafolio,
          child: Container(
            width: 36,
            height: 36,
            padding: const EdgeInsets.all(6),
            child: Image.asset('assets/portafolio.png', width: 24, height: 24),
          ),
        ),
        const SizedBox(width: 10),
        
        InkWell(
          onTap: () {
            if (appBarController.showNotifications != null) {
              appBarController.showNotifications!();
            } else {
              NotificationHelper.showNotificationModal(context);
            }
          },
          child: Container(
            width: 36,
            height: 36,
            padding: const EdgeInsets.all(6),
            child: Image.asset('assets/Notificaciones.png', width: 24, height: 24),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildUserProfileButton() {
    return InkWell(
      onTap: appBarController.navigateToProfile,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.white,
        child: Icon(Icons.person, color: GerenaColors.primaryColor),
      ),
    );
  }
}