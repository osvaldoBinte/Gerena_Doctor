import 'package:gerena/features/blog/domain/entities/blog_gerena_entity.dart';

class BlogGerenaModel extends BlogGerenaEntity {
  BlogGerenaModel({required super.id, required super.title, required super.content, required super.imageUrl,super.date});

factory BlogGerenaModel.fromJson(Map<String, dynamic> json) {
  final contenido = json['contenidoCompleto'] ?? json['resumen'] ?? '';
    final date = json['actualizadoEn'] ?? json['creadoEn'] ?? '';

  return BlogGerenaModel(
    id: json['id'] ?? 0, 
    title: json['titulo'] ?? '', 
    content: contenido,
    imageUrl: json['imagenUrl'] ?? '',
    date: date
  );
}

}