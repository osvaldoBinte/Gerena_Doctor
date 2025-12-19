import 'package:flutter/material.dart';
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
  
  final RxInt currentPage = 1.obs;
  final RxInt pageSize = 10.obs;
  final RxBool hasMore = true.obs;
  
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    loadFeedPosts();
  }

  void _onScroll() {
    if (scrollController.position.pixels >= 
        scrollController.position.maxScrollExtent * 0.8) {
      if (!isLoading.value && hasMore.value) {
        loadMorePosts();
      }
    }
  }

  Future<void> loadFeedPosts({bool refresh = true}) async {
    try {
      if (refresh) {
        currentPage.value = 1;
        hasMore.value = true;
        posts.clear();
      }

      if (isLoading.value) return;

      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final result = await getFeedPostsUsecase.execute(
        currentPage.value,
        pageSize.value,
      );

      // Si trae menos posts de los esperados, ya no hay más
      if (result.isEmpty || result.length < pageSize.value) {
        hasMore.value = false;
      }

      if (result.isNotEmpty) {
        if (refresh) {
          posts.value = result;
        } else {
          posts.addAll(result);
        }
        currentPage.value++;
      } else {
        if (refresh) {
          posts.clear();
        }
        hasMore.value = false;
      }
      
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('Error al cargar posts: $e');
      showErrorSnackbar('Error al cargar publicaciones');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMorePosts() async {
    if (isLoading.value || !hasMore.value) return;

    await loadFeedPosts(refresh: false);
  }

  Future<void> refreshPosts() async {
    await loadFeedPosts(refresh: true);
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
      
      print('Reacción actualizada localmente para el post $postId: ${post.userreaction}');
      posts.refresh();
      
      await likePublicationUsecase.execute(postId, reactionType);
      
    } catch (e) {
      print('Error al dar like: $e');
      showErrorSnackbar(
        'No se pudo registrar la reacción ${cleanExceptionMessage(e)}',
      );
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  bool isReview(PublicationEntity post) => post.isReview;

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}