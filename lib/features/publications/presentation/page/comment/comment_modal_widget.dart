import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/custom_alert_type.dart';
import 'package:gerena/features/publications/domain/entities/comments/get_comments_entity.dart';
import 'package:gerena/features/publications/presentation/page/comment/comment_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CommentModalWidget extends StatefulWidget {
  final int postId;

  const CommentModalWidget({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  State<CommentModalWidget> createState() => _CommentModalWidgetState();
}

class _CommentModalWidgetState extends State<CommentModalWidget> {
  final CommentController commentController = Get.find<CommentController>();
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    commentController.getComments(widget.postId, refresh: true);
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent * 0.9) {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
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
                  icon: Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),

          Expanded(
            child: Obx(() {
              final comments = commentController.getCommentsList(widget.postId);
              final isLoading = commentController.isLoading(widget.postId);

              if (comments.isEmpty && !isLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.comment_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No hay comentarios aún',
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Sé el primero en comentar',
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                controller: scrollController,
                padding: EdgeInsets.all(16),
                itemCount: comments.length + (isLoading ? 1 : 0),
                separatorBuilder: (context, index) => SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index >= comments.length) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(
                          color: GerenaColors.primaryColor,
                        ),
                      ),
                    );
                  }

                  final comment = comments[index];
                  return _buildCommentCard(comment);
                },
              );
            }),
          ),

          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5),
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
                          color: Colors.grey.shade400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: GerenaColors.primaryColor),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Obx(() => commentController.isAddingComment.value
                      ? Container(
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
                          icon: Icon(
                            Icons.send,
                            color: GerenaColors.primaryColor,
                          ),
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

 Widget _buildCommentCard(GetCommentsEntity comment) {
  final isAuthor = comment.esAutor == true;
  
  return GestureDetector(
    onLongPress: isAuthor
        ? () => _showDeleteConfirmation(comment.id)
        : null,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: comment.authorEntity?.profilePhoto != null &&
                  comment.authorEntity!.profilePhoto!.isNotEmpty &&
                  comment.authorEntity!.profilePhoto!.startsWith('http')
              ? NetworkImage(comment.authorEntity!.profilePhoto!)
              : null,
          child: comment.authorEntity?.profilePhoto == null ||
                  comment.authorEntity!.profilePhoto!.isEmpty
              ? Icon(Icons.person, size: 20)
              : null,
        ),
        SizedBox(width: 12),

        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        comment.authorEntity?.name ?? 'Usuario',
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      comment.createdAt != null
                          ? _formatDate(comment.createdAt!)
                          : '',
                      style: GoogleFonts.rubik(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                       overflow: TextOverflow.ellipsis,
                        maxLines: 1
                    ),
                    if (isAuthor)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                           overflow: TextOverflow.ellipsis,
                        maxLines: 1
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  comment.comentario ?? '',
                  style: GoogleFonts.rubik(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
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
    onCancel: () {
      Navigator.of(context).pop(); 
    },
  );
}
}