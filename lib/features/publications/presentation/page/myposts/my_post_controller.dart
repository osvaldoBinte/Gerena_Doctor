import 'package:gerena/common/errors/convert_message.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/publications/domain/entities/myposts/image_entity.dart';
import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/domain/usecase/get_my_posts_usecase.dart';
import 'package:gerena/features/publications/domain/usecase/like_publication_usecase.dart';
import 'package:gerena/features/publications/domain/usecase/delete_publication_usecase.dart'; // 🔥 NUEVO
import 'package:get/get.dart';

class MyPostController extends GetxController {
  final GetMyPostsUsecase getMyPostsUsecase;
  final LikePublicationUsecase likePublicationUsecase;
  final DeletePublicationUsecase deletePublicationUsecase; // 🔥 NUEVO
  
  MyPostController({
    required this.getMyPostsUsecase,
    required this.likePublicationUsecase,
    required this.deletePublicationUsecase, // 🔥 NUEVO
  });

  final RxList<PublicationEntity> myPosts = <PublicationEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  final RxInt totalReviews = 0.obs;
  final RxInt totalFollowers = 0.obs;
  final RxInt totalFollowing = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadMyPosts();
  }

  Future<void> loadMyPosts() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final result = await getMyPostsUsecase.execute();
      myPosts.value = result;
      
      _updateStatistics();
      
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('Error al cargar mis posts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshMyPosts() async {
    await loadMyPosts();
  }

  void _updateStatistics() {
    totalReviews.value = myPosts.where((post) => post.isReview).length;
  }

  List<PublicationEntity> get myReviews =>
      myPosts.where((post) => post.isReview).toList();

  List<PublicationEntity> get myPublications =>
      myPosts.where((post) => !post.isReview).toList();

  String? getImageByOrder(List<ImageEntity> images, int order) {
    try {
      return images.firstWhere((img) => img.order == order).imageUrl;
    } catch (e) {
      return images.isNotEmpty ? images.first.imageUrl : null;
    }
  }

  List<String> getOrderedImages(PublicationEntity post) {
    final sortedImages = List<ImageEntity>.from(post.images)
      ..sort((a, b) => a.order.compareTo(b.order));
    return sortedImages.map((img) => img.imageUrl).toList();
  }

  Future<void> toggleLike(int postId, String reactionType) async {
    try {
      final index = myPosts.indexWhere((p) => p.id == postId);
      if (index == -1) return;

      final post = myPosts[index];
      final isSameReaction = post.userreaction == reactionType;
      
      if (isSameReaction) {
        post.userreaction = null;
      } else {
        post.userreaction = reactionType;
      }

      myPosts.refresh();
      await likePublicationUsecase.execute(postId, reactionType);
      await refreshMyPosts();
      
    } catch (e) {
      print('Error al dar like: $e');
      showErrorSnackbar(
        'No se pudo registrar la reacción ${cleanExceptionMessage(e)}',
      );
      await refreshMyPosts();
    }
  }

  // 🔥 NUEVO - Método para eliminar publicación
  Future<void> deletePost(int postId) async {
    try {
      isLoading.value = true;
      
      await deletePublicationUsecase.execute(postId);
      
      // Eliminar del estado local
      myPosts.removeWhere((post) => post.id == postId);
      _updateStatistics();
      
      showSuccessSnackbar('Publicación eliminada correctamente');
      
    } catch (e) {
      print('Error al eliminar publicación: $e');
      showErrorSnackbar(
        'No se pudo eliminar la publicación ${cleanExceptionMessage(e)}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year}';
  }

  bool isReview(PublicationEntity post) => post.isReview;
}