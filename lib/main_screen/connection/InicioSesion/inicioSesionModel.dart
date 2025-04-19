import 'package:managegym/db/database_connection.dart';
import 'package:postgres/postgres.dart';

class Administrador {
  final int id;
  final int idUsuario;
  final String correo;

  Administrador({
    required this.id,
    required this.idUsuario,
    required this.correo,
  });

    factory Administrador.fromMap(Map<String, dynamic> map) {
    return Administrador(
        id: map['id'] is String ? int.parse(map['id']) : map['id'] as int,
        idUsuario: map['idusuario'] is String ? int.parse(map['idusuario']) : map['idusuario'] as int,
        correo: map['correo'] as String,
    );
    }
}

class InicioSesionModel {
  static Future<Administrador?> obtenerAdministrador(String correo, String contrasena) async {
    try {
      print('Tipos de parámetros:');
      print('Correo tipo: ${correo.runtimeType}, valor: $correo');
      print('Contraseña tipo: ${contrasena.runtimeType}, valor: $contrasena');
      print('Entre');
      
      final sql = Sql.named("SELECT id, idUsuario, correo FROM administrador WHERE correo = @correo AND contrasena = @contrasena LIMIT 1");
      final results = await Database.conn.execute(sql, parameters: {'correo': correo, 'contrasena': contrasena});
      
      print('results: $results');
      if (results.isNotEmpty) {
        final row = results.first;
        
        // Hacemos conversiones seguras de tipo
        final id = row[0] is int ? row[0] as int : int.tryParse(row[0].toString()) ?? 0;
        final idUsuario = row[1] is int ? row[1] as int : int.tryParse(row[1].toString()) ?? 0;
        final correoUsuario = row[2].toString();
        
        return Administrador(
          id: id,
          idUsuario: idUsuario,
          correo: correoUsuario,
        );
      }
      return null;
    } catch (e) {
      print('Error en obtenerAdministrador: $e');
      return null;
    }
  }
}