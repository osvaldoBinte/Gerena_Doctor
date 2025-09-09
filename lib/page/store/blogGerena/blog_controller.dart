import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BlogController extends ChangeNotifier {
  bool _showBlogSocial = false;
  bool _showArticleDetail = false;
  Map<String, String>? _selectedArticle;

  bool _showQuestions = false;
  bool _showSocialArticleDetail = false;
  String _selectedQuestionTitle = '';
  List<Map<String, String>> _selectedAnswers = [];
  Map<String, String>? _selectedSocialArticle;

  final CarouselSliderController _carouselController = CarouselSliderController();

  bool get showBlogSocial => _showBlogSocial;
  bool get showArticleDetail => _showArticleDetail;
  Map<String, String>? get selectedArticle => _selectedArticle;

  bool get showQuestions => _showQuestions;
  bool get showSocialArticleDetail => _showSocialArticleDetail;
  String get selectedQuestionTitle => _selectedQuestionTitle;
  List<Map<String, String>> get selectedAnswers => _selectedAnswers;
  Map<String, String>? get selectedSocialArticle => _selectedSocialArticle;
  CarouselSliderController get carouselController => _carouselController;

  void showBlogSocialSection() {
    _showBlogSocial = true;
    _showArticleDetail = false;
    _selectedArticle = null;
    _resetBlogSocialState();
    notifyListeners();
  }

  void showBlogGerenaSection() {
    _showBlogSocial = false;
    _showArticleDetail = false;
    _selectedArticle = null;
    _resetBlogSocialState();
    notifyListeners();
  }

  void showArticleDetailView(Map<String, String> article) {
    _showArticleDetail = true;
    _selectedArticle = article;
    _showBlogSocial = false;
    notifyListeners();
  }

  void goBackFromArticleDetail() {
    _showArticleDetail = false;
    _selectedArticle = null;
    notifyListeners();
  }

  void showQuestionDetail(String questionTitle, List<Map<String, String>> answers) {
    _showQuestions = true;
    _showSocialArticleDetail = false;
    _selectedQuestionTitle = questionTitle;
    _selectedAnswers = answers;
    notifyListeners();
  }

  void showSocialArticleDetails(Map<String, String> article) {
    _showQuestions = false;
    _showSocialArticleDetail = true;
    _selectedSocialArticle = article;
    notifyListeners();
  }

  void goBackToBlogSocial() {
    _showQuestions = false;
    _showSocialArticleDetail = false;
    _selectedSocialArticle = null;
    notifyListeners();
  }

  void _resetBlogSocialState() {
    _showQuestions = false;
    _showSocialArticleDetail = false;
    _selectedQuestionTitle = '';
    _selectedAnswers = [];
    _selectedSocialArticle = null;
  }

  void resetState() {
    _showBlogSocial = false;
    _showArticleDetail = false;
    _selectedArticle = null;
    _resetBlogSocialState();
    notifyListeners();
  }

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

  List<Map<String, String>> getRecentArticles() {
    return [
      {
        'title': 'El libro de medicina estética más completo creado hasta ahora',
        'content': 'Si algo he aprendido en mi práctica como médico estético es que la clave para construir relaciones duraderas con mis pacientes no está solo en los resultados visibles, sino en cómo los acompaño durante todo el proceso. Hoy quiero compartirte cómo la educación y la transparencia han sido mis mejores herramientas para fidelizar pacientes y generar una relación de confianza real. Caso 1: Decir “no” también construye confianza Una paciente joven llegó solicitando un aumento de labios con volumen exagerado. Aunque técnicamente podía hacerlo, sentí que no era lo adecuado para su armonía facial. Le mostré ejemplos, le expliqué los riesgos estéticos a largo plazo y le ofrecí una alternativa más natural. Al principio dudó, pero semanas después regresó. Aceptó el tratamiento sugerido, quedó encantada con el resultado… y hoy es una de mis pacientes más leales. Me recomienda constantemente porque, según ella, “fui el primero que no buscó venderle algo, sino orientarla. Caso 2: El poder del antes y después explicado Otro caso que recuerdo bien es el de un paciente que no notaba los cambios tras su tratamiento de toxina botulínica. En lugar de entrar en defensiva, le mostré sus fotos clínicas comparativas, le expliqué qué músculos habían sidotratados y cómo eso influía en la expresión. Cuando entendió el proceso, no solo quedó conforme, sino que comenzó a valorar más cada detalle del tratamiento. Hoy sigue confiando en mí y siempre pide que le muestre su evolución en cada sesión. Mi enfoque: educar, explicar, acompañar Creo firmemente que parte de nuestro rol como médicos estéticos es educar al paciente: explicarle qué necesita, qué no necesita, y por qué. Incluso cuando eso signifique rechazar un procedimiento o corregir expectativas poco realistas. La transparencia genera respeto, y el respeto se convierte en fidelidad. Fidelizar a un paciente no se trata de convencer, sino de acompañar con criterio, empatía y conocimiento. La educación es una forma de cuidado. Y cuando los pacientes lo sienten, siempre vuelven',
        'image': 'assets/blog/example.png',
        'date': '28/03/2024',
        'author': 'Editorial Gerena',
      },
      {
        'title': 'Nuevas las complicaciones frecuentes ocasionadas en una piel sensible: líneas temporales',
        'content': 'Si algo he aprendido en mi práctica como médico estético es que la clave para construir relaciones duraderas con mis pacientes no está solo en los resultados visibles, sino en cómo los acompaño durante todo el proceso. Hoy quiero compartirte cómo la educación y la transparencia han sido mis mejores herramientas para fidelizar pacientes y generar una relación de confianza real. Caso 1: Decir “no” también construye confianza Una paciente joven llegó solicitando un aumento de labios con volumen exagerado. Aunque técnicamente podía hacerlo, sentí que no era lo adecuado para su armonía facial. Le mostré ejemplos, le expliqué los riesgos estéticos a largo plazo y le ofrecí una alternativa más natural. Al principio dudó, pero semanas después regresó. Aceptó el tratamiento sugerido, quedó encantada con el resultado… y hoy es una de mis pacientes más leales. Me recomienda constantemente porque, según ella, “fui el primero que no buscó venderle algo, sino orientarla. Caso 2: El poder del antes y después explicado Otro caso que recuerdo bien es el de un paciente que no notaba los cambios tras su tratamiento de toxina botulínica. En lugar de entrar en defensiva, le mostré sus fotos clínicas comparativas, le expliqué qué músculos habían sidotratados y cómo eso influía en la expresión. Cuando entendió el proceso, no solo quedó conforme, sino que comenzó a valorar más cada detalle del tratamiento. Hoy sigue confiando en mí y siempre pide que le muestre su evolución en cada sesión. Mi enfoque: educar, explicar, acompañar Creo firmemente que parte de nuestro rol como médicos estéticos es educar al paciente: explicarle qué necesita, qué no necesita, y por qué. Incluso cuando eso signifique rechazar un procedimiento o corregir expectativas poco realistas. La transparencia genera respeto, y el respeto se convierte en fidelidad. Fidelizar a un paciente no se trata de convencer, sino de acompañar con criterio, empatía y conocimiento. La educación es una forma de cuidado. Y cuando los pacientes lo sienten, siempre vuelven',
        'image': 'assets/blog/example.png',
        'date': '28/03/2024',
        'author': 'Dra. Dermatología',
      },
      {
        'title': 'Botox Gerena: todo un éxito en nuestro Centro Odontológico',
        'content': 'Si algo he aprendido en mi práctica como médico estético es que la clave para construir relaciones duraderas con mis pacientes no está solo en los resultados visibles, sino en cómo los acompaño durante todo el proceso. Hoy quiero compartirte cómo la educación y la transparencia han sido mis mejores herramientas para fidelizar pacientes y generar una relación de confianza real. Caso 1: Decir “no” también construye confianza Una paciente joven llegó solicitando un aumento de labios con volumen exagerado. Aunque técnicamente podía hacerlo, sentí que no era lo adecuado para su armonía facial. Le mostré ejemplos, le expliqué los riesgos estéticos a largo plazo y le ofrecí una alternativa más natural. Al principio dudó, pero semanas después regresó. Aceptó el tratamiento sugerido, quedó encantada con el resultado… y hoy es una de mis pacientes más leales. Me recomienda constantemente porque, según ella, “fui el primero que no buscó venderle algo, sino orientarla. Caso 2: El poder del antes y después explicado Otro caso que recuerdo bien es el de un paciente que no notaba los cambios tras su tratamiento de toxina botulínica. En lugar de entrar en defensiva, le mostré sus fotos clínicas comparativas, le expliqué qué músculos habían sidotratados y cómo eso influía en la expresión. Cuando entendió el proceso, no solo quedó conforme, sino que comenzó a valorar más cada detalle del tratamiento. Hoy sigue confiando en mí y siempre pide que le muestre su evolución en cada sesión. Mi enfoque: educar, explicar, acompañar Creo firmemente que parte de nuestro rol como médicos estéticos es educar al paciente: explicarle qué necesita, qué no necesita, y por qué. Incluso cuando eso signifique rechazar un procedimiento o corregir expectativas poco realistas. La transparencia genera respeto, y el respeto se convierte en fidelidad. Fidelizar a un paciente no se trata de convencer, sino de acompañar con criterio, empatía y conocimiento. La educación es una forma de cuidado. Y cuando los pacientes lo sienten, siempre vuelven',
        'image': 'assets/blog/example.png',
        'date': '28/03/2024',
        'author': 'Centro Gerena',
      },
      {
        'title': 'Ácido hialurónico en Centro Técnica Lengua y Odontología',
        'content': 'Si algo he aprendido en mi práctica como médico estético es que la clave para construir relaciones duraderas con mis pacientes no está solo en los resultados visibles, sino en cómo los acompaño durante todo el proceso. Hoy quiero compartirte cómo la educación y la transparencia han sido mis mejores herramientas para fidelizar pacientes y generar una relación de confianza real. Caso 1: Decir “no” también construye confianza Una paciente joven llegó solicitando un aumento de labios con volumen exagerado. Aunque técnicamente podía hacerlo, sentí que no era lo adecuado para su armonía facial. Le mostré ejemplos, le expliqué los riesgos estéticos a largo plazo y le ofrecí una alternativa más natural. Al principio dudó, pero semanas después regresó. Aceptó el tratamiento sugerido, quedó encantada con el resultado… y hoy es una de mis pacientes más leales. Me recomienda constantemente porque, según ella, “fui el primero que no buscó venderle algo, sino orientarla. Caso 2: El poder del antes y después explicado Otro caso que recuerdo bien es el de un paciente que no notaba los cambios tras su tratamiento de toxina botulínica. En lugar de entrar en defensiva, le mostré sus fotos clínicas comparativas, le expliqué qué músculos habían sidotratados y cómo eso influía en la expresión. Cuando entendió el proceso, no solo quedó conforme, sino que comenzó a valorar más cada detalle del tratamiento. Hoy sigue confiando en mí y siempre pide que le muestre su evolución en cada sesión. Mi enfoque: educar, explicar, acompañar Creo firmemente que parte de nuestro rol como médicos estéticos es educar al paciente: explicarle qué necesita, qué no necesita, y por qué. Incluso cuando eso signifique rechazar un procedimiento o corregir expectativas poco realistas. La transparencia genera respeto, y el respeto se convierte en fidelidad. Fidelizar a un paciente no se trata de convencer, sino de acompañar con criterio, empatía y conocimiento. La educación es una forma de cuidado. Y cuando los pacientes lo sienten, siempre vuelven',
        'image': 'assets/blog/example.png',
        'date': '28/03/2024',
        'author': 'Dr. Estética',
      },
      {
        'title': 'Nutrición Estética: Cómo lograr tratamientos naturales y beneficiosos',
        'content': 'Si algo he aprendido en mi práctica como médico estético es que la clave para construir relaciones duraderas con mis pacientes no está solo en los resultados visibles, sino en cómo los acompaño durante todo el proceso. Hoy quiero compartirte cómo la educación y la transparencia han sido mis mejores herramientas para fidelizar pacientes y generar una relación de confianza real. Caso 1: Decir “no” también construye confianza Una paciente joven llegó solicitando un aumento de labios con volumen exagerado. Aunque técnicamente podía hacerlo, sentí que no era lo adecuado para su armonía facial. Le mostré ejemplos, le expliqué los riesgos estéticos a largo plazo y le ofrecí una alternativa más natural. Al principio dudó, pero semanas después regresó. Aceptó el tratamiento sugerido, quedó encantada con el resultado… y hoy es una de mis pacientes más leales. Me recomienda constantemente porque, según ella, “fui el primero que no buscó venderle algo, sino orientarla. Caso 2: El poder del antes y después explicado Otro caso que recuerdo bien es el de un paciente que no notaba los cambios tras su tratamiento de toxina botulínica. En lugar de entrar en defensiva, le mostré sus fotos clínicas comparativas, le expliqué qué músculos habían sidotratados y cómo eso influía en la expresión. Cuando entendió el proceso, no solo quedó conforme, sino que comenzó a valorar más cada detalle del tratamiento. Hoy sigue confiando en mí y siempre pide que le muestre su evolución en cada sesión. Mi enfoque: educar, explicar, acompañar Creo firmemente que parte de nuestro rol como médicos estéticos es educar al paciente: explicarle qué necesita, qué no necesita, y por qué. Incluso cuando eso signifique rechazar un procedimiento o corregir expectativas poco realistas. La transparencia genera respeto, y el respeto se convierte en fidelidad. Fidelizar a un paciente no se trata de convencer, sino de acompañar con criterio, empatía y conocimiento. La educación es una forma de cuidado. Y cuando los pacientes lo sienten, siempre vuelven',
        'image': 'assets/blog/example.png',
        'date': '28/03/2024',
        'author': 'Dra. Nutrición Estética',
      },
    ];
  }

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

  List<Map<String, String>> getSocialArticles() {
    return [
      {
        'title': 'Experiencias de pacientes: testimonios reales',
        'content': 'Si algo he aprendido en mi práctica como médico estético es que la clave para construir relaciones duraderas con mis pacientes no está solo en los resultados visibles, sino en cómo los acompaño durante todo el proceso. Hoy quiero compartirte cómo la educación y la transparencia han sido mis mejores herramientas para fidelizar pacientes y generar una relación de confianza real. Caso 1: Decir “no” también construye confianza Una paciente joven llegó solicitando un aumento de labios con volumen exagerado. Aunque técnicamente podía hacerlo, sentí que no era lo adecuado para su armonía facial. Le mostré ejemplos, le expliqué los riesgos estéticos a largo plazo y le ofrecí una alternativa más natural. Al principio dudó, pero semanas después regresó. Aceptó el tratamiento sugerido, quedó encantada con el resultado… y hoy es una de mis pacientes más leales. Me recomienda constantemente porque, según ella, “fui el primero que no buscó venderle algo, sino orientarla. Caso 2: El poder del antes y después explicado Otro caso que recuerdo bien es el de un paciente que no notaba los cambios tras su tratamiento de toxina botulínica. En lugar de entrar en defensiva, le mostré sus fotos clínicas comparativas, le expliqué qué músculos habían sidotratados y cómo eso influía en la expresión. Cuando entendió el proceso, no solo quedó conforme, sino que comenzó a valorar más cada detalle del tratamiento. Hoy sigue confiando en mí y siempre pide que le muestre su evolución en cada sesión. Mi enfoque: educar, explicar, acompañar Creo firmemente que parte de nuestro rol como médicos estéticos es educar al paciente: explicarle qué necesita, qué no necesita, y por qué. Incluso cuando eso signifique rechazar un procedimiento o corregir expectativas poco realistas. La transparencia genera respeto, y el respeto se convierte en fidelidad. Fidelizar a un paciente no se trata de convencer, sino de acompañar con criterio, empatía y conocimiento. La educación es una forma de cuidado. Y cuando los pacientes lo sienten, siempre vuelven',
        'image': 'assets/blog/example.png',
        'date': 'Hace 1 día',
        'author': 'Dr. María González',
      },
      {
        'title': 'Comunidad médica: intercambio de conocimientos',
        'content': 'Si algo he aprendido en mi práctica como médico estético es que la clave para construir relaciones duraderas con mis pacientes no está solo en los resultados visibles, sino en cómo los acompaño durante todo el proceso. Hoy quiero compartirte cómo la educación y la transparencia han sido mis mejores herramientas para fidelizar pacientes y generar una relación de confianza real. Caso 1: Decir “no” también construye confianza Una paciente joven llegó solicitando un aumento de labios con volumen exagerado. Aunque técnicamente podía hacerlo, sentí que no era lo adecuado para su armonía facial. Le mostré ejemplos, le expliqué los riesgos estéticos a largo plazo y le ofrecí una alternativa más natural. Al principio dudó, pero semanas después regresó. Aceptó el tratamiento sugerido, quedó encantada con el resultado… y hoy es una de mis pacientes más leales. Me recomienda constantemente porque, según ella, “fui el primero que no buscó venderle algo, sino orientarla. Caso 2: El poder del antes y después explicado Otro caso que recuerdo bien es el de un paciente que no notaba los cambios tras su tratamiento de toxina botulínica. En lugar de entrar en defensiva, le mostré sus fotos clínicas comparativas, le expliqué qué músculos habían sidotratados y cómo eso influía en la expresión. Cuando entendió el proceso, no solo quedó conforme, sino que comenzó a valorar más cada detalle del tratamiento. Hoy sigue confiando en mí y siempre pide que le muestre su evolución en cada sesión. Mi enfoque: educar, explicar, acompañar Creo firmemente que parte de nuestro rol como médicos estéticos es educar al paciente: explicarle qué necesita, qué no necesita, y por qué. Incluso cuando eso signifique rechazar un procedimiento o corregir expectativas poco realistas. La transparencia genera respeto, y el respeto se convierte en fidelidad. Fidelizar a un paciente no se trata de convencer, sino de acompañar con criterio, empatía y conocimiento. La educación es una forma de cuidado. Y cuando los pacientes lo sienten, siempre vuelven',
        'image': 'assets/blog/example.png',
        'date': '28/03/2024',
        'author': 'Dr. Carlos Méndez',
      },
      {
        'title': 'Tendencias en medicina estética 2024',
        'content': 'Si algo he aprendido en mi práctica como médico estético es que la clave para construir relaciones duraderas con mis pacientes no está solo en los resultados visibles, sino en cómo los acompaño durante todo el proceso. Hoy quiero compartirte cómo la educación y la transparencia han sido mis mejores herramientas para fidelizar pacientes y generar una relación de confianza real. Caso 1: Decir “no” también construye confianza Una paciente joven llegó solicitando un aumento de labios con volumen exagerado. Aunque técnicamente podía hacerlo, sentí que no era lo adecuado para su armonía facial. Le mostré ejemplos, le expliqué los riesgos estéticos a largo plazo y le ofrecí una alternativa más natural. Al principio dudó, pero semanas después regresó. Aceptó el tratamiento sugerido, quedó encantada con el resultado… y hoy es una de mis pacientes más leales. Me recomienda constantemente porque, según ella, “fui el primero que no buscó venderle algo, sino orientarla. Caso 2: El poder del antes y después explicado Otro caso que recuerdo bien es el de un paciente que no notaba los cambios tras su tratamiento de toxina botulínica. En lugar de entrar en defensiva, le mostré sus fotos clínicas comparativas, le expliqué qué músculos habían sidotratados y cómo eso influía en la expresión. Cuando entendió el proceso, no solo quedó conforme, sino que comenzó a valorar más cada detalle del tratamiento. Hoy sigue confiando en mí y siempre pide que le muestre su evolución en cada sesión. Mi enfoque: educar, explicar, acompañar Creo firmemente que parte de nuestro rol como médicos estéticos es educar al paciente: explicarle qué necesita, qué no necesita, y por qué. Incluso cuando eso signifique rechazar un procedimiento o corregir expectativas poco realistas. La transparencia genera respeto, y el respeto se convierte en fidelidad. Fidelizar a un paciente no se trata de convencer, sino de acompañar con criterio, empatía y conocimiento. La educación es una forma de cuidado. Y cuando los pacientes lo sienten, siempre vuelven',
        'image': 'assets/blog/example.png',
        'date': '28/03/2024',
        'author': 'Dra. Ana Rodríguez',
      },
    ];
  }

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