import 'package:managegym/db/database_connection.dart';
import 'package:postgres/postgres.dart';

class Categoria {
  final int id;
  final String titulo;

  Categoria({required this.id, required this.titulo});

  factory Categoria.fromRow(List<dynamic> row) => Categoria(
        id: row[0] is int ? row[0] : int.tryParse(row[0].toString()) ?? 0,
        titulo: row[1].toString(),
      );
}

class CategoriaModel {
  static Future<List<Categoria>> obtenerTodasLasCategorias() async {
    try {
      final results = await Database.conn.execute(
        Sql.named("SELECT id, titulo FROM categorias ORDER BY id DESC"),
      );
      return results.map((row) => Categoria.fromRow(row)).toList();
    } catch (e) {
      print("Error al obtener las categorias: $e");
      return [];
    }
  }

  static Future<Categoria?> insertarCategoria({required String titulo}) async {
    try {
      final results = await Database.conn.execute(
        Sql.named("INSERT INTO categorias (titulo) VALUES (@titulo) RETURNING id, titulo"),
        parameters: {'titulo': titulo},
      );
      if (results.isNotEmpty) {
        return Categoria.fromRow(results.first);
      }
      return null;
    } catch (e) {
      print("Error en insertarCategoria: $e");
      return null;
    }
  }

  static Future<bool> eliminarCategoria(int id) async {
    try {
      await Database.conn.execute(
        Sql.named("DELETE FROM categorias WHERE id=@id"),
        parameters: {'id': id},
      );
      return true;
    } catch (e) {
      print("Error al eliminar la categoria: $e");
      return false;
    }
  }
}