import 'package:gerena/common/errors/convert_message.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/publications/domain/entities/myposts/image_entity.dart';
import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/domain/usecase/get_feed_posts_usecase.dart';
import 'package:gerena/features/publications/domain/usecase/like_publication_usecase.dart';
import 'package:get/get.dart';

class PublicationController extends GetxController {
  final GetFeedPostsUsecase getFeedPostsUsecase;
  final LikePublicationUsecase likePublicationUsecase;
  
  PublicationController({
    required this.getFeedPostsUsecase,
    required this.likePublicationUsecase,
  });

  final RxList<PublicationEntity> posts = <PublicationEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadFeedPosts();
  }

  Future<void> loadFeedPosts() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final result = await getFeedPostsUsecase.execute();
      posts.value = result;
      
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('Error al cargar posts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshPosts() async {
    await loadFeedPosts();
  }

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
      final index = posts.indexWhere((p) => p.id == postId);
      if (index == -1) return;

      final post = posts[index];
      final isSameReaction = post.userreaction == reactionType;
      
      if (isSameReaction) {
        post.userreaction = null;
      } else {
        post.userreaction = reactionType;
      }
 print('  - Reacción actualizada localmente para el post $postId: ${post.userreaction}');
      posts.refresh();
      await likePublicationUsecase.execute(postId, reactionType);
    //  await refreshMyPosts();
      
    } catch (e) {
      print('Error al dar like: $e');
      showErrorSnackbar(
        'No se pudo registrar la reacción ${cleanExceptionMessage(e)}',
      );
   //   await refreshMyPosts();
    }
  }
  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  bool isReview(PublicationEntity post) => post.isReview;
}