import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/custom_alert_type.dart';
import 'package:gerena/features/publications/domain/entities/comments/get_comments_entity.dart';
import 'package:gerena/features/publications/presentation/page/comment/comment_controller.dart';
import 'package:gerena/movil/home/start_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CommentModalWidget extends StatefulWidget {
  final int postId;
  final int? highlightCommentId;

  const CommentModalWidget({
    Key? key,
    required this.postId,
    this.highlightCommentId,
  }) : super(key: key);

  @override
  State<CommentModalWidget> createState() => _CommentModalWidgetState();
}

class _CommentModalWidgetState extends State<CommentModalWidget> {
  final CommentController commentController = Get.find<CommentController>();
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final Map<int, GlobalKey> _commentKeys = {};
  int? _highlightedCommentId;
@override
void initState() {
  super.initState();
  commentController.getComments(widget.postId, refresh: true);
  scrollController.addListener(_onScroll);

  commentController.initHighlight(widget.highlightCommentId);

  ever(commentController.commentsMap, (_) {
    final pending = commentController.pendingScrollCommentId.value;
    if (pending == null) return;

    final exists = commentController
        .getCommentsList(widget.postId)
        .any((c) => c.id == pending);

    if (exists) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToComment(pending);
      });
    }
  });
}

  void _scrollToComment(int commentId) {
    final key = _commentKeys[commentId];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
      commentController.onScrolledToComment();
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.9) {
      commentController.getComments(widget.postId);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return DateFormat('dd/MM/yyyy').format(date);
    } else if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'Ahora';
    }
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    commentController.initHighlight(null); // limpiar highlight al cerrar
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Comentarios',
                    style: GoogleFonts.rubik(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),

          // ── Lista ───────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              final comments =
                  commentController.getCommentsList(widget.postId);
              final isLoading = commentController.isLoading(widget.postId);

              if (comments.isEmpty && !isLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.comment_outlined,
                          size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No hay comentarios aún',
                        style: GoogleFonts.rubik(
                            fontSize: 16, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sé el primero en comentar',
                        style: GoogleFonts.rubik(
                            fontSize: 14, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: comments.length + (isLoading ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
  if (index >= comments.length) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: CircularProgressIndicator(color: GerenaColors.primaryColor),
      ),
    );
  }

  final comment = comments[index];
  _commentKeys[comment.id] = _commentKeys[comment.id] ?? GlobalKey();

  // ← Lee directo del controller, sin setState
  return Obx(() => _buildCommentCard(
    comment,
    key: _commentKeys[comment.id],
    isHighlighted: commentController.highlightCommentId.value == comment.id,
  ));
},
              );
            }),
          ),

          // ── Input ───────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(top: BorderSide(color: Colors.grey.shade200)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Escribe un comentario...',
                        hintStyle: GoogleFonts.rubik(
                            color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                              color: GerenaColors.primaryColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(() => commentController.isAddingComment.value
                      ? SizedBox(
                          width: 48,
                          height: 48,
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: GerenaColors.primaryColor,
                              ),
                            ),
                          ),
                        )
                      : IconButton(
                          icon: Icon(Icons.send,
                              color: GerenaColors.primaryColor),
                          onPressed: () async {
                            if (textController.text.trim().isNotEmpty) {
                              await commentController.addComment(
                                widget.postId,
                                textController.text.trim(),
                              );
                              textController.clear();
                            }
                          },
                        )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(
    GetCommentsEntity comment, {
    Key? key,
    bool isHighlighted = false,
  }) {
    final isAuthor = comment.esAutor == true;

    return GestureDetector(
      key: key,
      onLongPress:
          isAuthor ? () => _showDeleteConfirmation(comment.id) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _navigateToProfile(comment),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: comment.authorEntity?.profilePhoto != null &&
                      comment.authorEntity!.profilePhoto!.isNotEmpty &&
                      comment.authorEntity!.profilePhoto!.startsWith('http')
                  ? NetworkImage(comment.authorEntity!.profilePhoto!)
                  : null,
              child: comment.authorEntity?.profilePhoto == null ||
                      comment.authorEntity!.profilePhoto!.isEmpty
                  ? const Icon(Icons.person, size: 20)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? GerenaColors.primaryColor.withOpacity(0.12)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: isHighlighted
                    ? Border.all(
                        color: GerenaColors.primaryColor, width: 1.5)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () => _navigateToProfile(comment),
                          child: Text(
                            comment.authorEntity?.name ?? 'Usuario',
                            style: GoogleFonts.rubik(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: GerenaColors.primaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        comment.createdAt != null
                            ? _formatDate(comment.createdAt!)
                            : '',
                        style: GoogleFonts.rubik(
                            fontSize: 12, color: Colors.grey.shade600),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      if (isAuthor) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: GerenaColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Autor',
                            style: GoogleFonts.rubik(
                              fontSize: 10,
                              color: GerenaColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.comentario ?? '',
                    style: GoogleFonts.rubik(
                        fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToProfile(GetCommentsEntity comment) async {
    if (comment.authorEntity == null) return;

    try {
      final authService = AuthService();
      final int? loggedUserId = await authService.getUsuarioId();
      final int authorId = comment.authorEntity!.id;

      if (loggedUserId == authorId) {
        Get.offAllNamed(RoutesNames.homePage, arguments: 4);
        return;
      }

      final rol = comment.authorEntity!.rol;
      final startController = Get.find<StartController>();

      if (rol == 'cliente') {
        startController
            .showUserProfilePage(userData: {'userId': comment.authorEntity!.id});
        Get.back();
      } else if (rol == 'doctor') {
        startController.showDoctorProfilePage(doctorData: {
          'userId': comment.authorEntity!.id,
          'doctorName': comment.authorEntity!.name ?? 'Doctor',
        });
        Get.back();
      }
    } catch (e) {
      print('❌ Error al navegar al perfil: $e');
    }
  }

  void _showDeleteConfirmation(int commentId) {
    HapticFeedback.mediumImpact();
    showCustomAlert(
      context: context,
      title: '¿Eliminar comentario?',
      message: 'Esta acción no se puede deshacer',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      type: CustomAlertType.warning,
      onConfirm: () async {
        Navigator.of(context).pop();
        await commentController.deleteComment(widget.postId, commentId);
      },
      onCancel: () => Navigator.of(context).pop(),
    );
  }
}