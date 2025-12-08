import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/custom_alert_type.dart';
import 'package:gerena/common/widgets/widgets_gobal.dart';
import 'package:gerena/features/doctors/presentation/page/editperfildoctor/movil/controller_perfil_configuration.dart';
import 'package:gerena/features/doctors/presentation/page/editperfildoctor/movil/perfil_edit_page.dart';
import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/presentation/page/create/create_publication_modal.dart';
import 'package:gerena/features/publications/presentation/page/myposts/my_post_controller.dart';
import 'package:gerena/features/publications/presentation/widget/review_widget.dart';
import 'package:gerena/features/publications/presentation/page/post_controller.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfileReviewsScreenState createState() => _ProfileReviewsScreenState();
}

class _ProfileReviewsScreenState extends State<ProfilePage> {
  final ControllerPerfilConfiguration perfilConfiguration =
      Get.find<ControllerPerfilConfiguration>();
  final MyPostController myPostController = Get.find<MyPostController>();

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find<PostController>();

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
        if (perfilConfiguration.showConfiguration.value) {
          return ProfileConfiguration();
        }

        return _buildProfileView(postController);
      }),
    );
  }

  Widget _buildProfileView(PostController postController) {
    return RefreshIndicator(
      onRefresh: () => myPostController.refreshMyPosts(),
      child: Container(
        color: GerenaColors.backgroundColorFondo,
        child: Obx(() {
          // Mostrar loading solo si no hay posts aún
          if (myPostController.isLoading.value &&
              myPostController.myPosts.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: GerenaColors.primaryColor),
            );
          }

          // Mostrar error si ocurrió y no hay posts
          if (myPostController.hasError.value &&
              myPostController.myPosts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error al cargar tus publicaciones',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => myPostController.loadMyPosts(),
                    child: Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [_buildProfileHeader(), _buildReviewsSection()],
            ),
          );
        }),
      ),
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
            color: const Color.fromARGB(255, 26, 26, 26).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              GerenaColors.createStoryRing(
                child: Image.asset(
                  'assets/example/perfil.png',
                  fit: BoxFit.cover,
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
                      'Flor Morales',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: GerenaColors.textPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '@florm_',
                          style: TextStyle(
                            fontSize: 14,
                            color: GerenaColors.textDarkColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GerenaColors.widgetButton(
                          onPressed: () {
                            Get.bottomSheet(
                              Container(
                                height:
                                    MediaQuery.of(Get.context!).size.height *
                                    0.9,
                                child: const CreatePublication(),
                              ),
                              isScrollControlled: true,
                              isDismissible: true,
                              enableDrag: true,
                            );
                          },
                          text: 'Publicar',
                        ),
                        GerenaColors.widgetButton(
                          onPressed: () {
                            perfilConfiguration.showConfigurationView();
                          },
                          text: 'EDITAR PERFIL',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  'Reseñas',
                  '${myPostController.totalReviews.value} ${myPostController.totalReviews.value == 1 ? "reseña creada" : "reseñas creadas"}',
                  GerenaColors.primaryColor,
                ),
                _buildStatColumn(
                  'Seguidores',
                  '${myPostController.totalFollowers.value} seguidores',
                  GerenaColors.primaryColor,
                ),
                _buildStatColumn(
                  'Seguidos',
                  '${myPostController.totalFollowing.value} Seguidos',
                  GerenaColors.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Obx(() {
      // 🔥 Cambiar de myReviews a myPosts para mostrar TODO
      final allPosts = myPostController.myPosts;

      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: GerenaColors.backgroundColorFondo,
            child: Text(
              'MIS PUBLICACIONES', // 🔥 Cambiar el título también
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                fontFamily: 'Rubik',
                color: GerenaColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),

          if (allPosts.isEmpty)
            Container(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(
                    Icons.rate_review_outlined,
                    size: 60,
                    color: GerenaColors.textSecondaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aún no tienes publicaciones', // 🔥 Actualizar mensaje
                    style: TextStyle(
                      fontSize: 16,
                      color: GerenaColors.textSecondaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Comparte tu experiencia o crea una publicación',
                    style: TextStyle(
                      fontSize: 14,
                      color: GerenaColors.textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            // 🔥 Mostrar TODAS las publicaciones (reseñas y normales)
            ...allPosts.map((post) => _buildReviewFromEntity(post)).toList(),
        ],
      );
    });
  }Widget _buildReviewFromEntity(PublicationEntity review) {
  Map<String, dynamic>? doctorData;
  if (review.taggedDoctor != null) {
    doctorData = {
      'userId': review.taggedDoctor!.id,
      'doctorName': review.taggedDoctor!.nombreCompleto ?? '',
      'specialty': review.taggedDoctor!.especialidad ?? '',
      'profileImage': review.taggedDoctor!.fotoPerfil ?? '',
    };
  }

  return ReviewWidget(
    postId: review.id,
    userName: review.author?.name ?? 'Mis Posts',
    date: myPostController.formatDate(review.createdAt),
    title: _extractTitle(review.description),
    content: '',
    images: myPostController.getOrderedImages(review),
    isReview: review.isReview,
    userRole: review.taggedDoctor?.nombreCompleto ?? '',
    rating: review.rating?.toDouble() ?? 0.0,
    reactions: review.reactions.total,
    avatarPath: review.author?.profilePhoto ?? '',
    showAgendarButton: review.taggedDoctor != null,
    showDeleteButton: true,
    userReaction: review.userreaction,
    doctorData: doctorData, 
    onReactionPressed: () {
      final postController = Get.find<PostController>();
      final reactionType = postController.getCurrentReactionType(review.id);
      myPostController.toggleLike(review.id, reactionType);
    },
    onDeletePressed: () {
      _showDeleteConfirmation(review.id, review.isReview);
    },
  );
}

// 🔥 NUEVO - Método para mostrar confirmación de eliminación
void _showDeleteConfirmation(int postId, bool isReview) {
  showCustomAlert(
    context: context,
    type: CustomAlertType.warning,
    title: '¿Eliminar ${isReview ? 'reseña' : 'publicación'}?',
    message: 'Esta acción no se puede deshacer. ¿Estás seguro de que deseas eliminar esta ${isReview ? 'reseña' : 'publicación'}?',
    confirmText: 'Eliminar',
    cancelText: 'Cancelar',
    onConfirm: () {
      Navigator.of(context).pop(); // Cerrar el diálogo
      myPostController.deletePost(postId);
    },
    onCancel: () {
      Navigator.of(context).pop(); // Cerrar el diálogo
    },
  );
}
  // Extraer título de la descripción (primeras 50 caracteres o primera línea)
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
}
