import 'dart:convert';
import 'package:gerena/features/auth/data/model/loginResponse/user_model.dart';
import 'package:gerena/features/auth/domain/entities/response/login_response_entity.dart';
import 'package:get/get.dart';
import 'package:gerena/common/constants/constants.dart';
import 'package:gerena/features/auth/data/model/loginResponse/login_response_model.dart';
import 'package:gerena/framework/preferences_service.dart';

class AuthService extends GetxService {
  static final AuthService _instance = AuthService._internal();
  final PreferencesUser _prefsUser = PreferencesUser();

  LoginResponseModel? _cachedUserData;

  factory AuthService() => _instance;

  AuthService._internal();

  Future<AuthService> init() async {
    await getUserData();
    return this;
  }

  Future<LoginResponseModel?> getUserData() async {
    if (_cachedUserData != null) return _cachedUserData;

    try {
      final sessionJson = await _prefsUser.loadPrefs(
        type: String,
        key: AppConstants.accesos,
      );

      if (sessionJson != null && sessionJson.isNotEmpty) {
        final Map<String, dynamic> sessionMap = jsonDecode(sessionJson);
        _cachedUserData = LoginResponseModel.fromJson(sessionMap);
        print('✅ Datos de usuario obtenidos correctamente');
        return _cachedUserData;
      }

      return null;
    } catch (e) {
      print('❌ Error al obtener datos de usuario: $e');
      return null;
    }
  }

  Future<String?> getToken() async {
    final userData = await getUserData();
    return userData?.token;
  }

  Future<String?> getUsuarioEmail() async {
    final userData = await getUserData();
    return userData?.user.email;
  }

  Future<int?> getUsuarioId() async {
    final userData = await getUserData();
    return userData?.user.id;
  }

  Future<String?> getRol() async {
    final userData = await getUserData();
    return userData?.user.rol;
  }

  Future<String?> getNombreCompleto() async {
    final userData = await getUserData();
    return userData?.user.nombreCompleto;
  }

  Future<String?> getTelefono() async {
    final userData = await getUserData();
    return userData?.user.telefono;
  }

 Future<bool> saveLoginResponse(LoginResponseEntity loginResponse) async {
  try {
    final LoginResponseModel modelToSave;
    
    if (loginResponse is LoginResponseModel) {
      modelToSave = loginResponse;
    } else {
      final userModel = UserModel(
        id: loginResponse.user.id,
        email: loginResponse.user.email,
        rol: loginResponse.user.rol,
        nombreCompleto: loginResponse.user.nombreCompleto,
        telefono: loginResponse.user.telefono,
      );
      
      modelToSave = LoginResponseModel(
        token: loginResponse.token,
        user: userModel,
      );
    }
    
    _cachedUserData = modelToSave;

     _prefsUser.savePrefs(
      type: String,
      key: AppConstants.accesos,
      value: jsonEncode(modelToSave.toJson()),
    );

    print('✅ Datos de login guardados correctamente');
    return true;
  } catch (e) {
    print('❌ Error al guardar datos de login: $e');
    return false;
  }
}
  Future<bool> logout() async {
    try {
      _cachedUserData = null;
      await _prefsUser.removePreferences();
      print('✅ Sesión cerrada correctamente');
      return true;
    } catch (e) {
      print('❌ Error al cerrar sesión: $e');
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final userData = await getUserData();
    return userData != null && userData.token.isNotEmpty;
  }

  Future<bool> hasRole(String role) async {
    final userData = await getUserData();
    return userData?.user.rol == role;
  }

  Future<bool> isDoctor() async => hasRole('doctor');
  
  Future<bool> isPaciente() async => hasRole('paciente');

  Future<Map<String, dynamic>?> getUserInfo() async {
    final userData = await getUserData();
    if (userData == null) return null;
    
    return {
      'token': userData.token,
      'id': userData.user.id,
      'email': userData.user.email,
      'rol': userData.user.rol,
      'nombreCompleto': userData.user.nombreCompleto,
      'telefono': userData.user.telefono,
    };
  }

  // Método para actualizar solo datos del usuario sin cambiar el token
  Future<bool> updateUserInfo({
    String? nombreCompleto,
    String? telefono,
  }) async {
    try {
      final userData = await getUserData();
      if (userData == null) return false;

      final updatedUser = UserModel(
        id: userData.user.id,
        email: userData.user.email,
        rol: userData.user.rol,
        nombreCompleto: nombreCompleto ?? userData.user.nombreCompleto,
        telefono: telefono ?? userData.user.telefono,
      );

      final updatedLoginResponse = LoginResponseModel(
        token: userData.token,
        user: updatedUser,
      );

      return await saveLoginResponse(updatedLoginResponse);
    } catch (e) {
      print('❌ Error al actualizar info de usuario: $e');
      return false;
    }
  }
}