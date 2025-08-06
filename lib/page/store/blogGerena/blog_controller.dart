import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BlogController extends ChangeNotifier {
  // Estados privados para BlogGerena
  bool _showBlogSocial = false;
  bool _showArticleDetail = false;
  Map<String, String>? _selectedArticle;

  // Estados privados para BlogSocial
  bool _showQuestions = false;
  bool _showSocialArticleDetail = false;
  String _selectedQuestionTitle = '';
  List<Map<String, String>> _selectedAnswers = [];
  Map<String, String>? _selectedSocialArticle;

  // Controlador del carrusel
  final CarouselSliderController _carouselController = CarouselSliderController();

  // Getters públicos para BlogGerena
  bool get showBlogSocial => _showBlogSocial;
  bool get showArticleDetail => _showArticleDetail;
  Map<String, String>? get selectedArticle => _selectedArticle;

  // Getters públicos para BlogSocial
  bool get showQuestions => _showQuestions;
  bool get showSocialArticleDetail => _showSocialArticleDetail;
  String get selectedQuestionTitle => _selectedQuestionTitle;
  List<Map<String, String>> get selectedAnswers => _selectedAnswers;
  Map<String, String>? get selectedSocialArticle => _selectedSocialArticle;
  CarouselSliderController get carouselController => _carouselController;

  // Métodos para BlogGerena
  // Método para cambiar a Blog Social
  void showBlogSocialSection() {
    _showBlogSocial = true;
    _showArticleDetail = false;
    _selectedArticle = null;
    // Limpiar estados de BlogSocial
    _resetBlogSocialState();
    notifyListeners();
  }

  // Método para cambiar a Blog Gerena
  void showBlogGerenaSection() {
    _showBlogSocial = false;
    _showArticleDetail = false;
    _selectedArticle = null;
    // Limpiar estados de BlogSocial
    _resetBlogSocialState();
    notifyListeners();
  }

  // Método para mostrar detalle de artículo en BlogGerena
  void showArticleDetailView(Map<String, String> article) {
    _showArticleDetail = true;
    _selectedArticle = article;
    _showBlogSocial = false; // Asegurar que estemos en Blog Gerena
    notifyListeners();
  }

  // Método para regresar de detalle de artículo en BlogGerena
  void goBackFromArticleDetail() {
    _showArticleDetail = false;
    _selectedArticle = null;
    notifyListeners();
  }

  // Métodos para BlogSocial
  // Método para mostrar detalle de pregunta
  void showQuestionDetail(String questionTitle, List<Map<String, String>> answers) {
    _showQuestions = true;
    _showSocialArticleDetail = false;
    _selectedQuestionTitle = questionTitle;
    _selectedAnswers = answers;
    notifyListeners();
  }

  // Método para mostrar detalle de artículo social
  void showSocialArticleDetails(Map<String, String> article) {
    _showQuestions = false;
    _showSocialArticleDetail = true;
    _selectedSocialArticle = article;
    notifyListeners();
  }

  // Método para regresar al contenido principal de BlogSocial
  void goBackToBlogSocial() {
    _showQuestions = false;
    _showSocialArticleDetail = false;
    _selectedSocialArticle = null;
    notifyListeners();
  }

  // Método privado para limpiar estados de BlogSocial
  void _resetBlogSocialState() {
    _showQuestions = false;
    _showSocialArticleDetail = false;
    _selectedQuestionTitle = '';
    _selectedAnswers = [];
    _selectedSocialArticle = null;
  }

  // Método para limpiar todo el estado
  void resetState() {
    _showBlogSocial = false;
    _showArticleDetail = false;
    _selectedArticle = null;
    _resetBlogSocialState();
    notifyListeners();
  }

  // Datos de artículos principales (secciones del blog)
  List<Map<String, String>> getBlogSectionArticles() {
    return [
      {
        'title': 'Periodontitis: los nutrientes de lactoria bifidobacteria regeneran las encías inflamadas',
        'content': 'Cuidar nuestra salud dental es un reflejo directo de las patologías que podemos sufrir en nuestro organismo. Uno de los casos más comunes es el de la periodontitis, una enfermedad de las encías que puede llevar a la pérdida dental y a otras complicaciones sistémicas si no se trata de manera adecuada.',
        'image': 'assets/blog/example.png',
        'date': 'Hoy',
        'author': 'Dr. Gerena',
      },
      {
        'title': 'Cómo mejorar tu cantidad calórica con Magnesio Líquido',
        'content': 'Una buena rutina diaria puede mejorar tu calidad de vida de manera significativa. El magnesio es uno de los minerales más importantes para nuestro cuerpo, y su deficiencia puede causar fatiga, calambres musculares y otros problemas de salud.',
        'image': 'assets/blog/example.png',
        'date': 'Ayer',
        'author': 'Dra. Nutrición',
      },
    ];
  }

  // Datos de artículos recientes
  List<Map<String, String>> getRecentArticles() {
    return [
      {
        'title': 'El libro de medicina estética más completo creado hasta ahora',
        'content': 'Un compendio de libros más completo sobre medicina estética, con técnicas innovadoras y procedimientos actualizados para profesionales de la salud.',
        'image': 'assets/blog/example.png',
        'date': '28/03/2024',
        'author': 'Editorial Gerena',
      },
      {
        'title': 'Nuevas las complicaciones frecuentes ocasionadas en una piel sensible: líneas temporales',
        'content': 'Las complicaciones más frecuentes en pieles sensibles y cómo tratarlas adecuadamente con los productos correctos.',
        'image': 'assets/blog/example.png',
        'date': '28/03/2024',
        'author': 'Dra. Dermatología',
      },
      {
        'title': 'Botox Gerena: todo un éxito en nuestro Centro Odontológico',
        'content': 'El Botox Gerena se ha convertido en uno de nuestros tratamientos más solicitados por sus excelentes resultados.',
        'image': 'assets/blog/example.png',
        'date': '28/03/2024',
        'author': 'Centro Gerena',
      },
      {
        'title': 'Ácido hialurónico en Centro Técnica Lengua y Odontología',
        'content': 'El tratamiento de ácido hialurónico en nuestro centro ofrece resultados naturales y duraderos para el rejuvenecimiento facial.',
        'image': 'assets/blog/example.png',
        'date': '28/03/2024',
        'author': 'Dr. Estética',
      },
      {
        'title': 'Nutrición Estética: Cómo lograr tratamientos naturales y beneficiosos',
        'content': 'Una nutrición adecuada enriquece los resultados de los tratamientos estéticos y promueve una belleza natural desde adentro.',
        'image': 'assets/blog/example.png',
        'date': '28/03/2024',
        'author': 'Dra. Nutrición Estética',
      },
    ];
  }

  // Datos específicos para BlogSocial
  // Datos de preguntas del carrusel
  List<Map<String, dynamic>> getCarouselQuestions() {
    return [
      {
        'title': '¿Recomendación de marcas para aplicación de ácido hialurónico?',
        'commentsText': '12 comentarios',
        'answers': getAnswersForQuestion1(),
      },
      {
        'title': '¿Qué protocolo siguen para tratar los hematomas post-aplicación de ácido hialurónico?',
        'commentsText': '8 comentarios',
        'answers': getAnswersForQuestion1(),
      },
      {
        'title': '¿Alguno ha tratado casos de migración de filler en el surco nasogeniano?',
        'commentsText': '5 comentarios',
        'answers': getAnswersForQuestion1(),
      },
    ];
  }

  // Respuestas para las preguntas
  List<Map<String, String>> getAnswersForQuestion1() {
    return [
      {
        'doctorName': 'Dra. Carmen González',
        'answer': 'Depende la aplicación que vas a realizar, yo en lo personal suelo manejar toda la línea de Derma Evolution ya que cuentan con certificado por parte de Cofrepris',
      },
      {
        'doctorName': 'Dr. Saul Figueroa',
        'answer': 'Te recomiendo Celosome, está certificado por la FDA y cuentan con una gran variedad de presentaciones. Dependiendo tu aplicación puedes encontrar el que se adapte mejor al área en el que vas a realizar el procedimiento.',
      },
      {
        'doctorName': 'Dra. Adriana Flores Gómez',
        'answer': 'Si vas a aplicar en relleno de labios yo te recomiento que pruebes Red Volumen, a mis pacientes les ha gustado mucho porque no solo se ve el volumen en labios si no que también agrega un bonito color ya que contiene vitamina B12, es uno de los pocos en el mercado y se ha estado vendiendo muy bien.',
      },
    ];
  }

  // Datos de artículos sociales
  List<Map<String, String>> getSocialArticles() {
    return [
      {
        'title': 'Experiencias de pacientes: testimonios reales',
        'content': 'Descubre las experiencias reales de nuestros pacientes y cómo han transformado su vida. En este artículo exploramos casos de éxito y las lecciones aprendidas en el proceso de acompañamiento durante los tratamientos de medicina estética.',
        'image': 'assets/blog/example.png',
        'date': 'Blog Social - Hace 1 día',
        'author': 'Dr. María González',
      },
      {
        'title': 'Comunidad médica: intercambio de conocimientos',
        'content': 'Un espacio para que profesionales compartan conocimientos y experiencias. La colaboración entre colegas es fundamental para el crecimiento profesional y la mejora continua en nuestros tratamientos.',
        'image': 'assets/blog/example.png',
        'date': 'Blog Social - Hace 2 días',
        'author': 'Dr. Carlos Méndez',
      },
      {
        'title': 'Tendencias en medicina estética 2024',
        'content': 'Las últimas tendencias y técnicas en el mundo de la medicina estética. Exploramos las innovaciones más recientes y cómo están transformando la manera en que abordamos los tratamientos.',
        'image': 'assets/blog/example.png',
        'date': 'Blog Social - Hace 3 días',
        'author': 'Dra. Ana Rodríguez',
      },
    ];
  }

  // Método para obtener contenido específico según el tipo de artículo
  String getArticleType(String title) {
    if (title.contains('Periodontitis')) {
      return 'periodontitis';
    } else if (title.contains('Magnesio')) {
      return 'magnesium';
    } else if (title.contains('Botox')) {
      return 'botox';
    } else {
      return 'default';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}