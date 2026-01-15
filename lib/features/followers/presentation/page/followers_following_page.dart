import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/followers/domain/entities/follow_user_entity.dart';
import 'package:gerena/features/followers/presentation/controller/follower_controller.dart';
import 'package:gerena/movil/home/start_controller.dart';
import 'package:get/get.dart';

class FollowersFollowingPage extends StatefulWidget {
  final int initialTab; // 0 = Seguidores, 1 = Seguidos

  const FollowersFollowingPage({
    Key? key,
    this.initialTab = 0,
  }) : super(key: key);

  @override
  State<FollowersFollowingPage> createState() => _FollowersFollowingPageState();
}

class _FollowersFollowingPageState extends State<FollowersFollowingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FollowerController followerController = Get.find<FollowerController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );

    // Cargar datos según la pestaña inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialTab == 0) {
        followerController.loadFollowers();
      } else {
        followerController.loadFollowing();
      }
    });

    // Listener para cargar datos cuando cambia de pestaña
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          followerController.loadFollowers();
        } else {
          followerController.loadFollowing();
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
          'Conexiones',
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
                    'Seguidores (${followerController.totalFollowers})',
                  )),
            ),
            Tab(
              child: Obx(() => Text(
                    'Seguidos (${followerController.totalFollowing})',
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
      if (followerController.isLoadingFollowers.value) {
        return Center(
          child: CircularProgressIndicator(
            color: GerenaColors.primaryColor,
          ),
        );
      }

      if (followerController.followers.isEmpty) {
        return _buildEmptyState(
          icon: Icons.people_outline,
          title: 'Sin seguidores aún',
          message: 'Cuando alguien te siga, aparecerá aquí',
        );
      }

      return RefreshIndicator(
        onRefresh: () => followerController.loadFollowers(),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8),
          itemCount: followerController.followers.length,
          itemBuilder: (context, index) {
            final follower = followerController.followers[index];
            return _buildUserCard(follower);
          },
        ),
      );
    });
  }

  Widget _buildFollowingTab() {
    return Obx(() {
      if (followerController.isLoadingFollowing.value) {
        return Center(
          child: CircularProgressIndicator(
            color: GerenaColors.primaryColor,
          ),
        );
      }

      if (followerController.following.isEmpty) {
        return _buildEmptyState(
          icon: Icons.person_add_outlined,
          title: 'No sigues a nadie',
          message: 'Busca médicos y usuarios para seguir',
        );
      }

      return RefreshIndicator(
        onRefresh: () => followerController.loadFollowing(),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8),
          itemCount: followerController.following.length,
          itemBuilder: (context, index) {
            final followingUser = followerController.following[index];
            return _buildUserCard(followingUser);
          },
        ),
      );
    });
  }

  Widget _buildUserCard(FollowUserEntity user) {
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
          backgroundImage: (user.fotoPerfil != null && user.fotoPerfil!.isNotEmpty)
              ? NetworkImage(user.fotoPerfil!)
              : null,
          child: (user.fotoPerfil == null || user.fotoPerfil!.isEmpty)
              ? Icon(
                  Icons.person,
                  size: 28,
                  color: GerenaColors.primaryColor,
                )
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
                user.rol,
                style: TextStyle(
                  fontSize: 14,
                  color: GerenaColors.textUsername,
                ),
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

  void _navigateToProfile(FollowUserEntity user) {
    try {
      final startController = Get.find<StartController>();

      final rol = user.rol.toLowerCase().trim();

      print('🔍 Navegando al perfil de: ${user.username}');
      print('   - Rol: $rol');
      print('   - ID: ${user.userId}');
      print('   - Especialidad: ${user.especialidad ?? "N/A"}');

      const clientRoles = ['cliente', 'paciente', 'usuario'];
      const doctorRoles = ['doctor', 'médico', 'medico', 'profesional'];

      if (clientRoles.contains(rol)) {
        Get.back();
        startController.showUserProfilePage(
          userData: {
            'userId': user.userId,
          },
        );
      } else if (doctorRoles.contains(rol)) {
        Get.back();
        print('✅ Abriendo perfil de doctor');
        startController.showDoctorProfilePage(
          doctorData: {
            'userId': user.userId,
          },
        );
      } else {
        // Rol desconocido, mostrar mensaje de error
        print('⚠️ Rol desconocido o no soportado: "$rol"');
        showErrorSnackbar(
          'No se puede abrir este perfil. Rol: ${user.rol}',
        );
      }
    } catch (e) {
      print('❌ Error al navegar al perfil: $e');
      showErrorSnackbar('Error al abrir el perfil del usuario');
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