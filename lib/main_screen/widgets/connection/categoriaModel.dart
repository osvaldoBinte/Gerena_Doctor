import 'package:managegym/db/database_connection.dart';
import 'package:postgres/postgres.dart';

class Categoria {
  final int id;
  final String titulo;
  final String descripcion;
  final double precio;
  final int tiempoDuracion; // en horas

  Categoria({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.precio,
    required this.tiempoDuracion,
  });

  factory Categoria.fromRow(List<dynamic> row) {
    return Categoria(
      id: row[0] is int ? row[0] : int.tryParse(row[0].toString()) ?? 0,
      titulo: row[1].toString(),
      descripcion: row[2].toString(),
      precio: row[3] is double ? row[3] : double.tryParse(row[3].toString()) ?? 0.0,
      tiempoDuracion: row[4] is int ? row[4] : int.tryParse(row[4].toString()) ?? 0,
    );
  }
}

class CategoriaModel {
  static Future<List<Categoria>> obtenerTodasLasCategorias() async {
    try {
      final results = await Database.conn.execute(
        "SELECT id, titulo, descripcion, precio, tiempoDuracion FROM tipomembresia ORDER BY id DESC"
      );
      return results.map((row) => Categoria.fromRow(row)).toList();
    } catch (e) {
      print("Error al obtener las categorias: $e");
      return [];
    }
  }

  static Future<Categoria?> insertarTipoMembresia({
    required String titulo,
    required String descripcion,
    required double precio,
    required int tiempoDuracion,
  }) async {
    try {
      final sql = Sql.named("""
        INSERT INTO tipomembresia (titulo, descripcion, precio, tiempoDuracion)
        VALUES (@titulo, @descripcion, @precio, @tiempoDuracion)
        RETURNING id, titulo, descripcion, precio, tiempoDuracion
      """);
      final results = await Database.conn.execute(sql, parameters: {
        'titulo': titulo,
        'descripcion': descripcion,
        'precio': precio,
        'tiempoDuracion': tiempoDuracion,
      });

      if (results.isNotEmpty) {
        return Categoria.fromRow(results.first);
      }
      return null;
    } catch (e) {
      print("Error en insertarTipoMembresia: $e");
      return null;
    }
  }

  static Future<bool> eliminarTipoMembresia(int id) async {
    try {
      final sql = Sql.named("DELETE FROM tipomembresia WHERE id=@id");
      final result = await Database.conn.execute(sql, parameters: {'id': id});
      return result.affectedRows > 0;
    } catch (e) {
      print("Error al eliminar la categoria: $e");
      return false;
    }
  }
}