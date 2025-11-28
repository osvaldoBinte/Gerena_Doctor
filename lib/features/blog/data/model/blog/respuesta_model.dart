import 'package:gerena/features/blog/domain/entities/blog_social_entity.dart';

class RespuestaModel extends RespuestaEntity {
  RespuestaModel({
    required super.id,
    required super.preguntaId,
    required super.usuarioId,
    required super.contenido,
    required super.actualizadoEn,
    super.usuarioNombre
  });

  factory RespuestaModel.fromJson(Map<String, dynamic> json) {
    return RespuestaModel(
      id: json['id'],
      preguntaId: json['preguntaId'],
      usuarioId: json['usuarioId'],
      contenido: json['contenido'],
      actualizadoEn:json['actualizadoEn'],
      usuarioNombre:json['usuarioNombre']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'preguntaId': preguntaId,
      'usuarioId': usuarioId,
      'contenido': contenido,
      'actualizadoEn': actualizadoEn,
    };
  }
}
