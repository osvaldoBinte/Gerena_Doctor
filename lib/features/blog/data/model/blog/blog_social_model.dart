import 'package:gerena/features/blog/data/model/blog/respuesta_model.dart';
import 'package:gerena/features/blog/domain/entities/blog_social_entity.dart';

class BlogSocialModel extends BlogSocialEntity {
  BlogSocialModel({
    required super.id,
    super.titulo,
    super.descripcion,
    super.imagenUrl,
    super.tipoPregunta,
    super.respuestasCount,
    super.creadoEn,
    super.respuestas,
  });

  factory BlogSocialModel.fromJson(Map<String, dynamic> json) {
    return BlogSocialModel(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      imagenUrl: json['imagenUrl'],
      tipoPregunta: json['tipoPregunta'],
      respuestasCount: json['respuestasCount'],
      creadoEn: json['creadoEn'],
      respuestas: json['respuestas'] != null
          ? (json['respuestas'] as List)
              .map((e) => RespuestaModel.fromJson(e))
              .toList()
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'imagenUrl': imagenUrl,
      'tipoPregunta': tipoPregunta,
      'respuestasCount': respuestasCount,
      'creadoEn': creadoEn,
      'respuestas': respuestas != null
          ? respuestas!
              .map((e) => (e as RespuestaModel).toJson())
              .toList()
          : null,
    };
  }
}
