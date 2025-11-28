class BlogSocialEntity {
  final int id;
  final String? titulo;
  final String? descripcion;
  final String? imagenUrl;

  final String? tipoPregunta;
  final int? respuestasCount;
  final String? creadoEn;
  final List<RespuestaEntity>? respuestas;

  BlogSocialEntity({
    required this.id,
    this.titulo,
    this.descripcion,
    this.imagenUrl,
    this.tipoPregunta,
    this.respuestasCount,
    this.creadoEn,
    this.respuestas,
  });
}

class RespuestaEntity {
  final int id;
  final int? preguntaId;
  final int? usuarioId;
  final String? contenido;
  final String? actualizadoEn;
  final String? usuarioNombre;

  RespuestaEntity({
    required this.id,
    this.preguntaId,
    this.usuarioId,
    this.contenido,
    this.actualizadoEn,
    this.usuarioNombre
  });
}
