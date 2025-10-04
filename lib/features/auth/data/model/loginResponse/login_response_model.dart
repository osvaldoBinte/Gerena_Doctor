import 'package:gerena/features/auth/data/model/loginResponse/user_model.dart';
import 'package:gerena/features/auth/domain/entities/response/login_response_entity.dart';

class LoginResponseModel extends LoginResponseEntity {
  LoginResponseModel({
    required super.token,
    required super.user,
  });
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'],
      user: UserModel.fromJson(json['usuario']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'usuario': (user as UserModel).toJson(),
    };
  }

}