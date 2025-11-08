class LoginResponseEntity {
  final String token;
  final  UserEntity user;

  LoginResponseEntity({
    required this.token,
    required this.user,
  });
}

class UserEntity {
  final int id;
  final String email;
  final String rol;
  final String nombreCompleto;
  final String telefono;
  final String stripeId;

  UserEntity({
    required this.id,
    required this.email,
    required this.rol,
    required this.nombreCompleto,
    required this.telefono,
    required this.stripeId,
  });
}