import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/followers/presentation/controller/follower_user_controller.dart';
import 'package:gerena/movil/home/start_controller.dart';

import 'package:get/get.dart';

class FollowersFollowingGenericPage extends StatefulWidget {
  final int userId;
  final String userName;
  final int initialTab; // 0 = Seguidores, 1 = Seguidos

  const FollowersFollowingGenericPage({
    Key? key,
    required this.userId,
    required this.userName,
    this.initialTab = 0,
  }) : super(key: key);

  @override
  State<FollowersFollowingGenericPage> createState() =>
      _FollowersFollowingGenericPageState();
}

class _FollowersFollowingGenericPageState
    extends State<FollowersFollowingGenericPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FollowerUserController followerController = Get.find<FollowerUserController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialTab == 0) {
        followerController.loadFollowers(widget.userId);
      } else {
        followerController.loadFollowing(widget.userId);
      }
    });

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          followerController.loadFollowers(widget.userId);
        } else {
          followerController.loadFollowing(widget.userId);
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorFondo,
      appBar: AppBar(
        backgroundColor: GerenaColors.cardColor,
        elevation: 2,
        shadowColor: GerenaColors.shadowColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: GerenaColors.textPrimaryColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.userName,
          style: TextStyle(
            color: GerenaColors.textPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: GerenaColors.primaryColor,
          labelColor: GerenaColors.primaryColor,
          unselectedLabelColor: GerenaColors.textSecondaryColor,
          labelStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          tabs: [
            Tab(
              child: Obx(() => Text(
                    'Seguidores (${followerController.totalFollowers(widget.userId)})',
                  )),
            ),
            Tab(
              child: Obx(() => Text(
                    'Seguidos (${followerController.totalFollowing(widget.userId)})',
                  )),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFollowersTab(),
          _buildFollowingTab(),
        ],
      ),
    );
  }

  Widget _buildFollowersTab() {
    return Obx(() {
      if (followerController.isLoadingFollowers(widget.userId)) {
        return Center(
          child: CircularProgressIndicator(color: GerenaColors.primaryColor),
        );
      }

      final followers = followerController.getFollowers(widget.userId);

      if (followers.isEmpty) {
        return _buildEmptyState(
          icon: Icons.people_outline,
          title: 'Sin seguidores',
          message: 'Este usuario aún no tiene seguidores',
        );
      }

      return RefreshIndicator(
        onRefresh: () => followerController.loadFollowers(widget.userId),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8),
          itemCount: followers.length,
          itemBuilder: (context, index) {
            return _buildUserCard(followers[index]);
          },
        ),
      );
    });
  }

  Widget _buildFollowingTab() {
    return Obx(() {
      if (followerController.isLoadingFollowing(widget.userId)) {
        return Center(
          child: CircularProgressIndicator(color: GerenaColors.primaryColor),
        );
      }

      final following = followerController.getFollowing(widget.userId);

      if (following.isEmpty) {
        return _buildEmptyState(
          icon: Icons.person_add_outlined,
          title: 'Sin seguidos',
          message: 'Este usuario aún no sigue a nadie',
        );
      }

      return RefreshIndicator(
        onRefresh: () => followerController.loadFollowing(widget.userId),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8),
          itemCount: following.length,
          itemBuilder: (context, index) {
            return _buildUserCard(following[index]);
          },
        ),
      );
    });
  }

 Widget _buildUserCard(user) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    decoration: BoxDecoration(
      color: GerenaColors.cardColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          spreadRadius: 1,
          blurRadius: 3,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: GerenaColors.primaryColor.withOpacity(0.1),
        backgroundImage:
            (user.fotoPerfil != null && user.fotoPerfil!.isNotEmpty)
                ? NetworkImage(user.fotoPerfil!)
                : null,
        child: (user.fotoPerfil == null || user.fotoPerfil!.isEmpty)
            ? Icon(Icons.person, size: 28, color: GerenaColors.primaryColor)
            : null,
      ),
      title: Text(
        user.username ?? 'Usuario',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: GerenaColors.textPrimaryColor,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user.rol != null) ...[
            SizedBox(height: 4),
            Text(
              '${user.rol}',
              style: TextStyle(fontSize: 14, color: GerenaColors.textUsername),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (user.especialidad != null && user.especialidad!.isNotEmpty) ...[
            SizedBox(height: 4),
            Text(
              user.especialidad!,
              style: TextStyle(
                fontSize: 13,
                color: GerenaColors.textSecondaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: GerenaColors.textSecondaryColor,
      ),
      onTap: () => _navigateToProfile(user),
    ),
  );
}

void _navigateToProfile(user) {
  final startController = Get.find<StartController>();
  // Verificar el rol del usuario
  final rol = user.rol?.toLowerCase() ?? '';
  
  print('🔍 Navegando al perfil de: ${user.username} (Rol: $rol, ID: ${user.userId})');
  
  if (rol == 'cliente') {
      Get.back();

    startController.showUserProfilePage(
      userData: {
        'userId': user.userId,
      },
    );
  } else if (rol == 'doctor') {
  Get.back();
    startController.showDoctorProfilePage(
      doctorData: {
        'userId': user.userId,
      },
    );
  } else {
    // Rol desconocido, mostrar mensaje de error
    print('⚠️ Rol desconocido: $rol');
    showErrorSnackbar('No se puede abrir este perfil');
  }
}

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: GerenaColors.textSecondaryColor.withOpacity(0.5),
            ),
            SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: GerenaColors.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: GerenaColors.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}