import 'package:managegym/db/database_connection.dart';
import 'package:postgres/postgres.dart';

class TipoMembresia {
  final int id;
  final String titulo;
  final String descripcion;
  final double precio;
  final int tiempoDuracion;

  TipoMembresia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.precio,
    required this.tiempoDuracion,
  });

  factory TipoMembresia.fromMap(Map<String, dynamic> map) {
    return TipoMembresia(
      id: map['id'] is String ? int.parse(map['id']) : map['id'] as int,
      titulo: map['titulo'] as String,
      descripcion: map['descripcion'] as String,
      precio: map['precio'] is String ? double.parse(map['precio']) : map['precio'] as double,
      tiempoDuracion: map['tiempoDuracion'] is String ? int.parse(map['tiempoDuracion']) : map['tiempoDuracion'] as int,
    );
  }
}

class AgregarSuscripcionModel {
  static Future<TipoMembresia?> insertarTipoMembresia({
    required String titulo,
    required String descripcion,
    required double precio,
    required int tiempoDuracion,
  }) async {
    try {
      final sql = Sql.named(
        "INSERT INTO tipomembresia (titulo, descripcion, precio, tiempoDuracion) "
        "VALUES (@titulo, @descripcion, @precio, @tiempoDuracion) "
        "RETURNING id, titulo, descripcion, precio, tiempoDuracion"
      );
      final results = await Database.conn.execute(sql, parameters: {
        'titulo': titulo,
        'descripcion': descripcion,
        'precio': precio,
        'tiempoDuracion': tiempoDuracion,
      });

      if (results.isNotEmpty) {
        final row = results.first;
        final id = row[0] is int ? row[0] as int : int.tryParse(row[0].toString()) ?? 0;
        final t = row[1].toString();
        final d = row[2].toString();
        final p = row[3] is double ? row[3] as double : double.tryParse(row[3].toString()) ?? 0.0;
        final td = row[4] is int ? row[4] as int : int.tryParse(row[4].toString()) ?? 0;
        return TipoMembresia(
          id: id,
          titulo: t,
          descripcion: d,
          precio: p,
          tiempoDuracion: td,
        );
      }
      return null;
    } catch (e) {
      print('Error en insertarTipoMembresia: $e');
      return null;
    }
  }

  static Future<List<TipoMembresia>> obtenerTodasLasSuscripciones() async {
    try {
      final results = await Database.conn.execute(
        "SELECT id, titulo, descripcion, precio, tiempoDuracion FROM tipomembresia ORDER BY id DESC",
      );
      return results.map((row) {
        return TipoMembresia(
          id: row[0] is int ? row[0] as int : int.tryParse(row[0].toString()) ?? 0,
          titulo: row[1].toString(),
          descripcion: row[2].toString(),
          precio: row[3] is double ? row[3] as double : double.tryParse(row[3].toString()) ?? 0.0,
          tiempoDuracion: row[4] is int ? row[4] as int : int.tryParse(row[4].toString()) ?? 0,
        );
      }).toList();
    } catch (e) {
      print('Error al obtener las suscripciones: $e');
      return [];
    }
  }

  static Future<bool> actualizarTipoMembresia({
    required int id,
    required String titulo,
    required String descripcion,
    required double precio,
    required int tiempoDuracion,
  }) async {
    try {
      final sql = Sql.named(
        "UPDATE tipomembresia SET titulo=@titulo, descripcion=@descripcion, precio=@precio, tiempoDuracion=@tiempoDuracion WHERE id=@id"
      );
      final result = await Database.conn.execute(sql, parameters: {
        'id': id,
        'titulo': titulo,
        'descripcion': descripcion,
        'precio': precio,
        'tiempoDuracion': tiempoDuracion,
      });
      return result.affectedRows > 0;
    } catch (e) {
      print('Error al actualizar: $e');
      return false;
    }
  }

  static Future<bool> eliminarTipoMembresia({
    required int id,
  }) async {
    try {
      final sql = Sql.named(
        "DELETE FROM tipomembresia WHERE id=@id"
      );
      final result = await Database.conn.execute(sql, parameters: {
        'id': id,
      });
      return result.affectedRows > 0;
    } catch (e) {
      print('Error al eliminar: $e');
      return false;
    }
  }
}