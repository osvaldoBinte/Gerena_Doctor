class SearchProfileRequestEntity {
  final String?busqueda;
  final String?rol;
  final String? especialidad;
  final int? pagina;
  final int?registrosPorPagina;
  SearchProfileRequestEntity({
     this.busqueda,
     this.rol,
     this.especialidad,
     this.pagina,
     this.registrosPorPagina,
  });
}