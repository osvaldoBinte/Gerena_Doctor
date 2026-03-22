import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/publications/domain/entities/comments/get_comments_entity.dart';
import 'package:gerena/features/publications/domain/usecase/add_comment_usecase.dart';
import 'package:gerena/features/publications/domain/usecase/delete_comment_usecase.dart';
import 'package:gerena/features/publications/domain/usecase/get_post_comments_usecase.dart';
import 'package:get/get.dart';
class CommentController extends GetxController {
  final GetPostCommentsUsecase getPostCommentsUsecase;
  final AddCommentUsecase addCommentUsecase;
  final DeleteCommentUsecase deleteCommentUsecase;

  CommentController({
    required this.addCommentUsecase,
    required this.getPostCommentsUsecase,
    required this.deleteCommentUsecase,
  });

  final RxMap<int, RxList<GetCommentsEntity>> commentsMap = <int, RxList<GetCommentsEntity>>{}.obs;
  final RxMap<int, RxBool> loadingMap = <int, RxBool>{}.obs;
  final RxMap<int, RxInt> currentPageMap = <int, RxInt>{}.obs;
  final RxMap<int, RxBool> hasMoreMap = <int, RxBool>{}.obs;
  final RxBool isAddingComment = false.obs;
  final RxMap<int, RxBool> deletingCommentMap = <int, RxBool>{}.obs;

  // ── Highlight ────────────────────────────────────────────────────
  final Rx<int?> highlightCommentId = Rx<int?>(null);
  final Rx<int?> pendingScrollCommentId = Rx<int?>(null);

  void initHighlight(int? commentId) {
    highlightCommentId.value = commentId;
    pendingScrollCommentId.value = commentId;
  }

  void clearHighlight() {
    highlightCommentId.value = null;
  }

  // Llamado cuando el comentario ya está en pantalla y se hizo scroll
  void onScrolledToComment() {
    pendingScrollCommentId.value = null;
    Future.delayed(const Duration(seconds: 3), () {
      clearHighlight();
    });
  }
  // ─────────────────────────────────────────────────────────────────
Future<void> getComments(int publicacionId, {bool refresh = false}) async {
  if (refresh) {
    currentPageMap[publicacionId] = 1.obs;
    commentsMap[publicacionId] = <GetCommentsEntity>[].obs;
    hasMoreMap[publicacionId] = true.obs;
  }
  if (loadingMap[publicacionId]?.value == true) return;
  if (hasMoreMap[publicacionId]?.value == false) return;
  loadingMap[publicacionId] = true.obs;
  try {
    final page = currentPageMap[publicacionId]?.value ?? 1;
    final comments = await getPostCommentsUsecase.execute(publicacionId, page);
    if (comments.isEmpty) {
      hasMoreMap[publicacionId] = false.obs;
    } else {
      commentsMap[publicacionId] ??= <GetCommentsEntity>[].obs;
      commentsMap[publicacionId]!.addAll(comments);
      currentPageMap[publicacionId] = (page + 1).obs;

      // ── Reordenar solo en la primera página ──────────────────
      if (page == 1) _reorderWithHighlight(publicacionId);
    }
  } catch (e) {
    showErrorSnackbar('No se pudieron cargar los comentarios');
  } finally {
    loadingMap[publicacionId] = false.obs;
  }
}

  Future<void> addComment(int publicacionId, String comment) async {
    if (comment.trim().isEmpty) {
      showErrorSnackbar('El comentario no puede estar vacío');
      return;
    }
    isAddingComment.value = true;
    try {
      await addCommentUsecase.execute(publicacionId, comment);
      await getComments(publicacionId, refresh: true);
      showSuccessSnackbar('Comentario agregado correctamente');
    } catch (e) {
      showErrorSnackbar('No se pudo agregar el comentario');
    } finally {
      isAddingComment.value = false;
    }
  }

  Future<void> deleteComment(int publicacionId, int commentId) async {
    deletingCommentMap[commentId] = true.obs;
    try {
      await deleteCommentUsecase.execute(publicacionId, commentId);
      commentsMap[publicacionId]?.removeWhere((c) => c.id == commentId);
      showSuccessSnackbar('Comentario eliminado correctamente');
    } catch (e) {
      showErrorSnackbar('No se pudo eliminar el comentario');
    } finally {
      deletingCommentMap[commentId] = false.obs;
    }
  }
void _reorderWithHighlight(int publicacionId) {
  final highlightId = highlightCommentId.value;
  if (highlightId == null) return;

  final list = commentsMap[publicacionId];
  if (list == null) return;

  final index = list.indexWhere((c) => c.id == highlightId);
  if (index <= 0) return; // ya está primero o no existe

  final comment = list.removeAt(index);
  list.insert(0, comment);
}
  bool isDeletingComment(int commentId) => deletingCommentMap[commentId]?.value ?? false;
  List<GetCommentsEntity> getCommentsList(int publicacionId) => commentsMap[publicacionId] ?? [];
  bool isLoading(int publicacionId) => loadingMap[publicacionId]?.value ?? false;
  bool hasMore(int publicacionId) => hasMoreMap[publicacionId]?.value ?? true;
}