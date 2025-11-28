import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/blog/domain/entities/create/create_blog_social_entity.dart';
import 'package:gerena/features/blog/domain/usecase/create_blog_social_usecase.dart';
import 'package:gerena/features/blog/domain/usecase/get_blog_gerena_by_id_usecase.dart';
import 'package:gerena/features/blog/domain/usecase/get_blog_gerena_usecase.dart';
import 'package:gerena/features/blog/domain/usecase/get_blog_social_by_id_usecase.dart';
import 'package:gerena/features/blog/domain/usecase/get_blog_social_usecase.dart';
import 'package:gerena/features/blog/domain/usecase/post_answer_blog_usecase.dart';
import 'package:get/get.dart';
import 'package:gerena/features/blog/domain/entities/blog_gerena_entity.dart';
import 'package:gerena/features/blog/domain/entities/blog_social_entity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart'; 

class BlogController extends GetxController {
  final GetBlogGerenaUsecase getBlogGerenaUsecase;
  final GetBlogGerenaByIdUsecase getBlogGerenaByIdUsecase;
  final GetBlogSocialUsecase getBlogSocialUsecase;
  final GetBlogSocialByIdUsecase getBlogSocialByIdUsecase;
  final CreateBlogSocialUsecase createBlogSocialUsecase;
  final PostAnswerBlogUsecase postAnswerBlogUsecase;

  BlogController({
    required this.getBlogGerenaUsecase,
    required this.getBlogGerenaByIdUsecase,
    required this.getBlogSocialUsecase,
    required this.getBlogSocialByIdUsecase,
    required this.createBlogSocialUsecase,
    required this.postAnswerBlogUsecase,
  });

  // Variables reactivas
  final RxBool showBlogSocial = false.obs;
  final RxBool showArticleDetail = false.obs;
  final Rx<BlogGerenaEntity?> selectedArticle = Rx<BlogGerenaEntity?>(null);

  final RxBool showQuestions = false.obs;
  final RxBool showSocialArticleDetail = false.obs;
  final RxBool showCreateBlogSocial = false.obs;
  final RxString selectedQuestionTitle = ''.obs;
  final RxList<RespuestaEntity> selectedAnswers = <RespuestaEntity>[].obs;
  final Rx<BlogSocialEntity?> selectedSocialArticle = Rx<BlogSocialEntity?>(null);

  final CarouselSliderController carouselController = CarouselSliderController();

  // Estados de carga
  final RxBool isLoadingGerena = false.obs;
  final RxBool isLoadingSocial = false.obs;
  final RxBool isLoadingDetail = false.obs;
  final RxBool isCreatingBlog = false.obs;

  // Listas de datos
  final RxList<BlogGerenaEntity> blogGerenaList = <BlogGerenaEntity>[].obs;
  final RxList<BlogSocialEntity> blogSocialList = <BlogSocialEntity>[].obs;
  
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final RxString selectedQuestionType = ''.obs;
  final RxString selectedImagePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadBlogGerenaArticles();
  }

  // ============ MÉTODOS PARA CARGAR DATOS ============
  List<BlogSocialEntity> getQuestions() {
    return blogSocialList.where((article) {
      return article.tipoPregunta != null && article.tipoPregunta!.isNotEmpty;
    }).toList();
  }

  Future<void> loadBlogGerenaArticles() async {
    try {
      isLoadingGerena.value = true;
      final articles = await getBlogGerenaUsecase.execute();
      blogGerenaList.value = articles;
    } catch (e) {
      showErrorSnackbar('No se pudieron cargar los artículos de Blog Gerena');
    } finally {
      isLoadingGerena.value = false;
    }
  }

  Future<void> loadBlogSocialArticles() async {
    try {
      isLoadingSocial.value = true;
      final articles = await getBlogSocialUsecase.execute();
      blogSocialList.value = articles;
    } catch (e) {
      showErrorSnackbar('No se pudieron cargar los artículos de Blog Social');
    } finally {
      isLoadingSocial.value = false;
    }
  }

  Future<void> loadBlogGerenaById(int id) async {
    try {
      isLoadingDetail.value = true;
      final article = await getBlogGerenaByIdUsecase.execute(id);
      selectedArticle.value = article;
      showArticleDetail.value = true;
    } catch (e) {
      showErrorSnackbar('No se pudo cargar el artículo');
    } finally {
      isLoadingDetail.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        selectedImagePath.value = result.files.single.path!;
      }
    } catch (e) {
      showErrorSnackbar('No se pudo seleccionar la imagen: $e');
    }
  }

  void clearSelectedImage() {
    selectedImagePath.value = '';
  }

  Future<void> submitCreateBlogForm() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (selectedImagePath.value.isEmpty) {
      showErrorSnackbar('Por favor selecciona una imagen');
      return;
    }

    await createBlogSocial(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      questionType: selectedQuestionType.value,
      imagePath: selectedImagePath.value,
    );
    
    // Limpiar formulario después de crear
    _clearCreateBlogForm();
  }

  void _clearCreateBlogForm() {
    titleController.clear();
    descriptionController.clear();
    selectedQuestionType.value = '';
    selectedImagePath.value = '';
  }

  Future<void> loadBlogSocialById(int id) async {
    try {
      isLoadingDetail.value = true;
      final article = await getBlogSocialByIdUsecase.execute(id);
      selectedSocialArticle.value = article;
      showSocialArticleDetail.value = true;
    } catch (e) {
      showErrorSnackbar('No se pudo cargar el artículo social');
    } finally {
      isLoadingDetail.value = false;
    }
  }
Future<void> sendAnswer({
  required int questionId,
  required String answer,
}) async {
  if (answer.trim().isEmpty) {
    showErrorSnackbar('Por favor escribe una respuesta');
    return;
  }

  if (answer.length > 280) {
    showErrorSnackbar('La respuesta no puede exceder 280 caracteres');
    return;
  }

  try {
    isLoadingDetail.value = true;
    
    await postAnswerBlogUsecase.execute(
      questionId, 
      answer,
    );
    
    await loadBlogSocialById(questionId);
    
    showSuccessSnackbar('Respuesta enviada correctamente');
    
    Get.back();
    
  } catch (e) {
    showErrorSnackbar('No se pudo enviar la respuesta: $e');
    rethrow;
  } finally {
    isLoadingDetail.value = false;
  }
}
  // ============ CREAR BLOG SOCIAL ============
  
  Future<void> createBlogSocial({
    required String title,
    required String description,
    required String questionType,
    required String imagePath,
  }) async {
    try {
      isCreatingBlog.value = true;
      
      final entity = CreateBlogSocialEntity(
        title: title,
        description: description,
        questionType: questionType,
        image: imagePath,
      );
      
      await createBlogSocialUsecase.execute(entity);
      
      showSuccessSnackbar('Blog social creado correctamente');
      
      // Recargar la lista de blogs sociales
      await loadBlogSocialArticles();
      
      // Volver a la vista principal
      goBackToBlogSocial();
      
    } catch (e) {
      showErrorSnackbar('No se pudo crear el blog social: $e');
      rethrow;
    } finally {
      isCreatingBlog.value = false;
    }
  }

  // ============ MÉTODOS DE NAVEGACIÓN ============

  void showBlogSocialSection() {
    showBlogSocial.value = true;
    showArticleDetail.value = false;
    selectedArticle.value = null;
    _resetBlogSocialState();
    
    if (blogSocialList.isEmpty) {
      loadBlogSocialArticles();
    }
  }

  void showBlogGerenaSection() {
    showBlogSocial.value = false;
    showArticleDetail.value = false;
    selectedArticle.value = null;
    _resetBlogSocialState();
  }

  void showArticleDetailView(int articleId) {
    loadBlogGerenaById(articleId);
    showBlogSocial.value = false;
  }

  void goBackFromArticleDetail() {
    showArticleDetail.value = false;
    selectedArticle.value = null;
  }

  void showQuestionDetail(String questionTitle, List<RespuestaEntity> answers) {
    showQuestions.value = true;
    showSocialArticleDetail.value = false;
    selectedQuestionTitle.value = questionTitle;
    selectedAnswers.value = answers;
  }

  void showSocialArticleDetails(int articleId) {
    showQuestions.value = false;
    loadBlogSocialById(articleId);
  }

  void showCreateBlogSocialForm() {
    showCreateBlogSocial.value = true;
    showQuestions.value = false;
    showSocialArticleDetail.value = false;
  }

  void goBackToBlogSocial() {
    showQuestions.value = false;
    showSocialArticleDetail.value = false;
    showCreateBlogSocial.value = false;
    selectedSocialArticle.value = null;
  }

  void _resetBlogSocialState() {
    showQuestions.value = false;
    showSocialArticleDetail.value = false;
    showCreateBlogSocial.value = false;
    selectedQuestionTitle.value = '';
    selectedAnswers.clear();
    selectedSocialArticle.value = null;
  }

  void resetState() {
    showBlogSocial.value = false;
    showArticleDetail.value = false;
    selectedArticle.value = null;
    _resetBlogSocialState();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}