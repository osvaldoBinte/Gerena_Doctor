import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/presentation/page/post_controller.dart';
import 'package:gerena/features/publications/presentation/page/postbyid/post_by_id_controller.dart';
import 'package:gerena/features/publications/presentation/page/publication_controller.dart';
import 'package:gerena/features/publications/presentation/widget/post_card_widget.dart';
import 'package:get/get.dart';

class PostByIdPage extends StatefulWidget {
  final int? postId;       // ← opcional, para uso embebido
  final int? commentId;    // ← opcional

  const PostByIdPage({
    super.key,
    this.postId,
    this.commentId,
  });

  @override
  State<PostByIdPage> createState() => _PostByIdPageState();
}

class _PostByIdPageState extends State<PostByIdPage> {
  late final PostByIdController controller;
  late final PublicationController publicationController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PostByIdController>();
    publicationController = Get.find<PublicationController>();

    // Si viene por constructor (embebido en NotificationPage)
    if (widget.postId != null) {
      controller.loadPostDirect(
        widget.postId!,
        commentIdParam: widget.commentId,
      );
    }
    // Si postId es null, onInit del controller ya lo cargó con Get.arguments
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GerenaColors.backgroundColorFondo,
        elevation: 4,
        shadowColor: GerenaColors.shadowColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: GerenaColors.textPrimaryColor),
          onPressed: () => Navigator.of(context).pop(),
          // ← Usa Navigator.pop en vez de Get.back() para respetar
          //   el Navigator local de NotificationPage
        ),
        title: Text(
          'Publicación',
          style: GerenaColors.headingMedium.copyWith(fontSize: 18),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(controller.errorMessage.value),
                const Text('Publicación no se encontró o fue eliminada'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    if (widget.postId != null) {
                      controller.loadPostDirect(
                        widget.postId!,
                        commentIdParam: widget.commentId,
                      );
                    } else {
                      final args = Get.arguments;
                      final int postId =
                          args is Map ? args['postId'] as int : args as int;
                      controller.loadPost(postId);
                    }
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        final post = controller.post.value;
        if (post == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: _buildPostFromEntity(post),
        );
      }),
    );
  }

  Widget _buildPostFromEntity(PublicationEntity post) {
    final PostController postController = Get.find<PostController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      postController.initializeUserReaction(post.id, post.userreaction);
    });

    String userRole;
    if (post.isReview && post.taggedDoctor != null) {
      userRole = post.taggedDoctor!.nombreCompleto ?? 'Doctor';
    } else if (post.isReview) {
      userRole = 'Reseña verificada';
    } else {
      userRole = 'Publicación';
    }

    return PostCardWidget(
      postId: post.id,
      author: post.author,
      userRole: userRole,
      postImages: publicationController.getOrderedImages(post),
      description: post.description,
      likes: post.reactions.total.toString(),
      rating: post.rating?.toDouble(),
      createdAt: publicationController.formatDate(post.createdAt),
      userHasLiked: post.userHasLiked,
      taggedDoctor: post.taggedDoctor,
      userReaction: post.userreaction,
      commentid: controller.commentId,
      onReactionPressed: () {
        final reactionType = postController.getCurrentReactionType(post.id);
        publicationController.toggleLike(post.id, reactionType);
      },
      doctorData: {
        'doctorName': post.taggedDoctor?.nombreCompleto ?? 'Doctor',
        'specialty': post.taggedDoctor?.especialidad ?? 'Especialidad no especificada',
        'rating': post.rating?.toDouble() ?? 0.0,
        'reviews': post.reactions.total.toString(),
        'profileImage': post.taggedDoctor?.fotoPerfil ?? "assets/logo/logo.png",
        'userId': post.taggedDoctor?.id ?? 0,
      },
    );
  }
}