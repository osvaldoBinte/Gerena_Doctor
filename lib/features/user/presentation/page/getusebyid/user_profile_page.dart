import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/presentation/page/post_controller.dart';
import 'package:gerena/features/publications/presentation/widget/review_widget.dart';
import 'package:gerena/features/user/presentation/page/getusebyid/get_user_by_id_controller.dart';
import 'package:gerena/movil/home/start_controller.dart';
import 'package:get/get.dart';

class UserProfilePage extends StatelessWidget {
  final GetUserByIdController controller = Get.find<GetUserByIdController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorFondo,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: GerenaColors.backgroundColorFondo,
          elevation: 4,
          shadowColor: GerenaColors.shadowColor,
        ),
      ),
      body: Obx(() {
        // Mostrar loading inicial
        if (controller.isLoading.value && controller.userEntity.value == null) {
          return Center(
            child: CircularProgressIndicator(color: GerenaColors.primaryColor),
          );
        }

        // Mostrar error si no hay usuario
        if (controller.errorMessage.value.isNotEmpty &&
            controller.userEntity.value == null) {
          return _buildErrorView();
        }

        return RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              controller.refreshUserPosts(),
              controller.loadFollowStatus(),
            ]);
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [_buildHeaders(),_buildProfileHeader(), _buildPublicationsSection()],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red),
          SizedBox(height: 16),
          Obx(
            () => Text(
              controller.errorMessage.value,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.retryLoad(),
            style: ElevatedButton.styleFrom(
              backgroundColor: GerenaColors.primaryColor,
            ),
            child: Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaders() {
    return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 13, right: 16),
                      child: GestureDetector(
                        onTap: () {
                          final StartController controller =
                              Get.find<StartController>();

                          controller.hideUserPage();
                        },
                        child: Image.asset(
                          'assets/icons/close.png',
                          width: 15,
                          height: 15,
                          color: GerenaColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                );
  }
  Widget _buildProfileHeader() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GerenaColors.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 26, 26, 26).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        return Column(
          children: [
            
            Row(
              children: [
                
                GerenaColors.createStoryRing(
                  child:
                      (controller.userProfileImage.isNotEmpty)
                          ? Image.network(
                            controller.userProfileImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.white,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.grey[400],
                                ),
                              );
                            },
                          )
                          : Container(
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          ),
                  hasStory: false,
                  size: 80,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.userName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: GerenaColors.textPrimaryColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '@${controller.userUsername}',
                        style: TextStyle(
                          fontSize: 14,
                          color: GerenaColors.textUsername,
                        ),
                      ),
                      SizedBox(height: 12),
                      // Botón de Seguir
                      _buildFollowButton(),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Estadísticas
            _buildStatsRow(),
          ],
        );
      }),
    );
  }

  Widget _buildFollowButton() {
    return Obx(() {
      if (controller.isLoadingFollow) {
        return GerenaColors.widgetButton(
          text: "Cargando...",
          // isLoading: true,
          onPressed: () {},
        );
      }

      final isFollowing = controller.isFollowing;

      return GerenaColors.widgetButton(
        text: isFollowing ? "Siguiendo" : "Seguir",
        onPressed: () => controller.toggleFollow(),
        backgroundColor: isFollowing ? Colors.white : GerenaColors.primaryColor,
        textColor: isFollowing ? GerenaColors.primaryColor : Colors.white,
        borderColor: GerenaColors.primaryColor,
      );
    });
  }

  Widget _buildStatsRow() {
    return Obx(() {
      if (controller.followerController.isLoadingFollow.value) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatColumn(
              'Publicaciones',
              'Cargando...',
              GerenaColors.primaryColor,
            ),
            _buildStatColumn(
              'Seguidores',
              'Cargando...',
              GerenaColors.primaryColor,
            ),
            _buildStatColumn(
              'Seguidos',
              'Cargando...',
              GerenaColors.primaryColor,
            ),
          ],
        );
      }

      final postsCount = controller.userPosts.length;
      final followersCount = controller.totalFollowers;
      final followingCount = controller.totalFollowing;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn(
            'Publicaciones',
            '$postsCount ${postsCount == 1 ? 'publicación' : 'publicaciones'}',
            GerenaColors.primaryColor,
          ),
          _buildStatColumn(
            'Seguidores',
            '$followersCount ${followersCount == 1 ? 'seguidor' : 'seguidores'}',
            GerenaColors.primaryColor,
          ),
          _buildStatColumn(
            'Seguidos',
            '$followingCount seguidos',
            GerenaColors.primaryColor,
          ),
        ],
      );
    });
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: GerenaColors.textTertiary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildPublicationsSection() {
    return Obx(() {
      final posts = controller.userPosts;

      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: GerenaColors.backgroundColorFondo,
            child: Text(
              'PUBLICACIONES',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                fontFamily: 'Rubik',
                color: GerenaColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          if (controller.isLoadingPosts.value && posts.isEmpty)
            Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(color: GerenaColors.primaryColor),
            )
          else if (posts.isEmpty)
            Container(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 60,
                    color: GerenaColors.textSecondaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aún no hay publicaciones',
                    style: TextStyle(
                      fontSize: 16,
                      color: GerenaColors.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            )
          else
            ...posts.map((post) => _buildPostWidget(post)).toList(),
        ],
      );
    });
  }

  Widget _buildPostWidget(PublicationEntity post) {
    final postController = Get.find<PostController>();

    Map<String, dynamic>? doctorData;
    if (post.taggedDoctor != null) {
      doctorData = {
        'userId': post.taggedDoctor!.id,
        'doctorName': post.taggedDoctor!.nombreCompleto ?? '',
        'specialty': post.taggedDoctor!.especialidad ?? '',
        'profileImage': post.taggedDoctor!.fotoPerfil ?? '',
      };
    }

    return ReviewWidget(
      postId: post.id,
      userName: post.author?.name ?? controller.userName,
      date: controller.formatDate(post.createdAt),
      title: _extractTitle(post.description),
      content: '',
      images: controller.getOrderedImages(post),
      isReview: post.isReview,
      userRole: post.taggedDoctor?.nombreCompleto ?? '',
      rating: post.rating?.toDouble() ?? 0.0,
      reactions: post.reactions.total,
      avatarPath: post.author?.profilePhoto ?? controller.userProfileImage,
      showAgendarButton: post.taggedDoctor != null,
      showDeleteButton: false,
      userReaction: post.userreaction,
      doctorData: doctorData,
    );
  }

  String _extractTitle(String description) {
    if (description.length <= 50) {
      return description;
    }

    final firstLine = description.split('\n').first;
    if (firstLine.length <= 50) {
      return firstLine;
    }

    return '${description.substring(0, 50)}...';
  }
}
