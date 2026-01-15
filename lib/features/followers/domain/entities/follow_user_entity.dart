class FollowUserEntity {
  final int userId;
  String? fotoPerfil;
  final String username;
  final String rol;
   String? especialidad;

  FollowUserEntity({
    required this.userId,
    this.fotoPerfil,
    required this.username,
    required this.rol,
     this.especialidad
  });

 
}
