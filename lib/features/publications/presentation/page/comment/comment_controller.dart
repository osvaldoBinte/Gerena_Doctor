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

  // Observable lists para cada publicación
  final RxMap<int, RxList<GetCommentsEntity>> commentsMap = <int, RxList<GetCommentsEntity>>{}.obs;
  final RxMap<int, RxBool> loadingMap = <int, RxBool>{}.obs;
  final RxMap<int, RxInt> currentPageMap = <int, RxInt>{}.obs;
  final RxMap<int, RxBool> hasMoreMap = <int, RxBool>{}.obs;

  // Loading para agregar comentario
  final RxBool isAddingComment = false.obs;
  
  // Loading para eliminar comentario
  final RxMap<int, RxBool> deletingCommentMap = <int, RxBool>{}.obs;

  // Obtener comentarios de una publicación
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
        if (commentsMap[publicacionId] == null) {
          commentsMap[publicacionId] = <GetCommentsEntity>[].obs;
        }
        commentsMap[publicacionId]!.addAll(comments);
        currentPageMap[publicacionId] = (page + 1).obs;
      }
    } catch (e) {
      showErrorSnackbar('No se pudieron cargar los comentarios');
    } finally {
      loadingMap[publicacionId] = false.obs;
    }
  }

  // Agregar comentario
  Future<void> addComment(int publicacionId, String comment) async {
    if (comment.trim().isEmpty) {
      showErrorSnackbar('El comentario no puede estar vacío');
      return;
    }

    isAddingComment.value = true;

    try {
      await addCommentUsecase.execute(publicacionId, comment);
      
      // Refrescar comentarios
      await getComments(publicacionId, refresh: true);
      
      showSuccessSnackbar('Comentario agregado correctamente');
    } catch (e) {
      showErrorSnackbar('No se pudo agregar el comentario');
    } finally {
      isAddingComment.value = false;
    }
  }

  // Eliminar comentario
  Future<void> deleteComment(int publicacionId, int commentId) async {
    deletingCommentMap[commentId] = true.obs;

    try {
      await deleteCommentUsecase.execute(publicacionId, commentId);
      
      // Eliminar el comentario de la lista local
      if (commentsMap[publicacionId] != null) {
        commentsMap[publicacionId]!.removeWhere((comment) => comment.id == commentId);
      }
      
      showSuccessSnackbar('Comentario eliminado correctamente');
    } catch (e) {
      showErrorSnackbar('No se pudo eliminar el comentario');
    } finally {
      deletingCommentMap[commentId] = false.obs;
    }
  }

  // Verificar si se está eliminando un comentario específico
  bool isDeletingComment(int commentId) {
    return deletingCommentMap[commentId]?.value ?? false;
  }

  // Obtener lista de comentarios
  List<GetCommentsEntity> getCommentsList(int publicacionId) {
    return commentsMap[publicacionId] ?? [];
  }

  // Verificar si está cargando
  bool isLoading(int publicacionId) {
    return loadingMap[publicacionId]?.value ?? false;
  }

  // Verificar si hay más comentarios
  bool hasMore(int publicacionId) {
    return hasMoreMap[publicacionId]?.value ?? true;
  }
}