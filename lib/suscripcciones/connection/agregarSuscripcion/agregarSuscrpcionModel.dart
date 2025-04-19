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
      print('Insertar tipo membresía: $titulo, $descripcion, $precio, $tiempoDuracion');
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
        // results es List<List<dynamic>>
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
}