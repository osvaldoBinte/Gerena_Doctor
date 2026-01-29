import 'package:gerena/features/user/domain/entities/getuser/search_profile_entity.dart';

class SearchProfileModel extends SearchProfileEntity {
  SearchProfileModel(
      {required super.userId,
      required super.fullName,
      super.specialty,
      super.profilePictureUrl,
      super.expreriecetime,
      super.address,
      super.bibliography,
      super.averagerating,
      super.username,
      super.rol});

  factory SearchProfileModel.fromJson(Map<String, dynamic> json) {
    return SearchProfileModel(
        userId: json['userId'] ?? 0,
        fullName: json['nombreCompleto'] ?? 'Sin nombre',
        username: json['usuario'] ?? '',
        specialty: json['especialidad'],
        profilePictureUrl: json['foto'],
        expreriecetime: json['experienciaTiempo'],
        address: json['direccion'],
        bibliography: json['biografia'],
        averagerating: (json['promedioCalificacion'] as num?)?.toDouble(),
        rol: json['rol']);
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nombreCompleto': fullName,
      'especialidad': specialty,
      'supername': username,
      'foto': profilePictureUrl,
      'experienciaTiempo': expreriecetime,
      'direccion': address,
      'biografia': bibliography,
      'rol': rol
    };
  }
}
