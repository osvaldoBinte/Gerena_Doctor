import 'package:gerena/common/errors/convert_message.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/publications/domain/entities/postreaction/post_reaction_entity.dart';
import 'package:gerena/features/publications/domain/usecase/get_post_reaction_usecase.dart';
import 'package:get/get.dart';

class GetPostReactionController extends GetxController {
  final GetPostReactionUsecase getPostReactionUsecase;
  
  GetPostReactionController({required this.getPostReactionUsecase});

  final RxList<PostReactionEntity> reactions = <PostReactionEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt publicationId = 0.obs;
  
  // Contadores por tipo de reacción
  final RxInt likesCount = 0.obs;
  final RxInt iLoveCount = 0.obs;
  final RxInt amazesMeCount = 0.obs;
  final RxInt iNeedItCount = 0.obs;
  
  // Filtro activo
  final RxString selectedFilter = 'all'.obs;
  
  @override
  void onInit() {
    super.onInit();
    
    if (Get.arguments != null && Get.arguments['publicationId'] != null) {
      publicationId.value = Get.arguments['publicationId'];
      loadReactions();
    }
  }

  Future<void> loadReactions() async {
    try {
      isLoading.value = true;
      
      final reactionsList = await getPostReactionUsecase.execute(
        publicationId.value,
      );
      
      reactions.value = reactionsList;
      _updateCounts();
      
    } catch (e) {
      print('Error cargando reacciones: $e');
      showErrorSnackbar(
        'Error al cargar reacciones: ${cleanExceptionMessage(e)}',
      );
    } finally {
      isLoading.value = false;
    }
  }
void _updateCounts() {
  likesCount.value = reactions
      .where((r) => r.type?.toLowerCase() == 'like')
      .length;
  
  iLoveCount.value = reactions
      .where((r) => r.type?.toLowerCase() == 'meencanta')
      .length;
  
  amazesMeCount.value = reactions
      .where((r) => r.type?.toLowerCase() == 'measombra')
      .length;
  
  iNeedItCount.value = reactions
      .where((r) => r.type?.toLowerCase() == 'lonecesito')
      .length;
}

List<PostReactionEntity> get filteredReactions {
  if (selectedFilter.value == 'all') {
    return reactions;
  }
  
  return reactions.where((r) {
    final type = r.type?.toLowerCase() ?? '';
    return type == selectedFilter.value.toLowerCase();
  }).toList();
}

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  int get totalReactions => reactions.length;

  Future<void> refreshReactions() async {
    await loadReactions();
  }
}