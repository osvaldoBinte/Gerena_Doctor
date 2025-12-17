import 'package:gerena/features/user/domain/entities/getuser/search_profile_request_entity.dart';

class SearchProfileRequestModel extends SearchProfileRequestEntity {
  SearchProfileRequestModel(
      {super.busqueda,
      super.rol,
      super.especialidad,
      required,
      super.pagina,
      super.registrosPorPagina});
  factory SearchProfileRequestModel.fromEntity(
      SearchProfileRequestEntity entity) {
    return SearchProfileRequestModel(
        busqueda: entity.busqueda,
        rol: entity.rol,
        especialidad: entity.especialidad,
        pagina: entity.pagina,
        registrosPorPagina: entity.registrosPorPagina
        );
  }
  Map<String, dynamic> toJson() {
    return {
      'busqueda': busqueda,
      'rol': rol,
      'especialidad': especialidad,
      'pagina': pagina,
      'registrosPorPagina': registrosPorPagina
    };
  }
}
