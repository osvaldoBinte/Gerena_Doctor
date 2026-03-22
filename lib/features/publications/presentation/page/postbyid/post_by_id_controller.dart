import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/domain/usecase/get_posts_by_id_usecase.dart';
import 'package:get/get.dart';

class PostByIdController extends GetxController {
  final GetPostsByIdUsecase getPostsByIdUsecase;
  PostByIdController({required this.getPostsByIdUsecase});

  final Rx<PublicationEntity?> post = Rx<PublicationEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  int? commentId;

  @override
  void onInit() {
    super.onInit();
    // Solo lee Get.arguments si no hay parámetros directos
    final args = Get.arguments;
    if (args != null) {
      final int postId = args is Map ? args['postId'] as int : args as int;
      commentId = args is Map ? args['commentId'] as int? : null;
      loadPost(postId);
    }
  }

  // ← Para uso embebido (desde NotificationPage sin Get.arguments)
  void loadPostDirect(int postId, {int? commentIdParam}) {
    commentId = commentIdParam;
    loadPost(postId);
  }

  Future<void> loadPost(int postId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      post.value = null;
      final result = await getPostsByIdUsecase.execute(postId);
      post.value = result;
    } catch (e) {
      errorMessage.value = 'No se pudo cargar la publicación.';
    } finally {
      isLoading.value = false;
    }
  }
}