import 'package:flutter/widgets.dart';
import 'package:postgres/postgres.dart';

class Producto {
  final int id;
  final String titulo;
  final String? descripcion;
  final double precioVenta;
  final int stock;
  final DateTime? fechaRegistro;
  final int? idCategoria;
  final int? idCodigoBarras;

  Producto({
    required this.id,
    required this.titulo,
    this.descripcion,
    required this.precioVenta,
    required this.stock,
    this.fechaRegistro,
    this.idCategoria,
    this.idCodigoBarras,
  });

  factory Producto.fromMap(Map<String, dynamic> map) => Producto(
    id: map['id'] is String ? int.parse(map['id']) : map['id'],
    titulo: map['titulo']?.toString() ?? '',
    descripcion: map['descripcion']?.toString(),
    precioVenta: map['precioventa'] is String 
        ? double.parse(map['precioventa']) 
        : (map['precioventa'] as num).toDouble(),
    stock: map['stock'] is String ? int.parse(map['stock']) : map['stock'],
    fechaRegistro: map['fecharegistro'] != null
        ? DateTime.tryParse(map['fecharegistro'].toString())
        : null,
    idCategoria: map['idcategoria'] != null 
        ? (map['idcategoria'] is String ? int.parse(map['idcategoria']) : map['idcategoria'])
        : null,
    idCodigoBarras: map['idcodigobarras'] != null 
        ? (map['idcodigobarras'] is String ? int.parse(map['idcodigobarras']) : map['idcodigobarras'])
        : null,
  );
}

class ProductoDB {
  static Future<int?> crearProducto({
    required String titulo,
    String? descripcion,
    required double precioVenta,
    required int stock,
    int? idCategoria,
    int? idCodigoBarras,
    required dynamic conn,
  }) async {
    try {
      final sql = Sql.named('''
        INSERT INTO producto (
          titulo, descripcion, precioVenta, stock, idCategoria, idCodigoBarras
        ) VALUES (
          @titulo, @descripcion, @precioVenta, @stock, @idCategoria, @idCodigoBarras
        ) RETURNING id;
      ''');

      final result = await conn.execute(sql, parameters: {
        'titulo': titulo,
        'descripcion': descripcion,
        'precioVenta': precioVenta,
        'stock': stock,
        'idCategoria': idCategoria,
        'idCodigoBarras': idCodigoBarras,
      });

      if (result.isNotEmpty) {
        return result.first[0] as int;
      }
      return null;
    } catch (e) {
      print('Error al crear producto: $e');
      return null;
    }
  }

  static Future<bool> editarProducto({
    required int id,
    String? titulo,
    String? descripcion,
    double? precioVenta,
    int? stock,
    int? idCategoria,
    int? idCodigoBarras,
    required dynamic conn,
  }) async {
    try {
      // Construimos la consulta SQL dinámicamente con los campos que se actualizarán
      var updateFields = <String>[];
      var parameters = <String, dynamic>{'id': id};

      if (titulo != null) {
        updateFields.add('titulo = @titulo');
        parameters['titulo'] = titulo;
      }
      if (descripcion != null) {
        updateFields.add('descripcion = @descripcion');
        parameters['descripcion'] = descripcion;
      }
      if (precioVenta != null) {
        updateFields.add('precioVenta = @precioVenta');
        parameters['precioVenta'] = precioVenta;
      }
      if (stock != null) {
        updateFields.add('stock = @stock');
        parameters['stock'] = stock;
      }
      if (idCategoria != null) {
        updateFields.add('idCategoria = @idCategoria');
        parameters['idCategoria'] = idCategoria;
      }
      if (idCodigoBarras != null) {
        updateFields.add('idCodigoBarras = @idCodigoBarras');
        parameters['idCodigoBarras'] = idCodigoBarras;
      }

      // Si no hay campos para actualizar, retornamos sin hacer cambios
      if (updateFields.isEmpty) {
        return false;
      }

      final sql = Sql.named('''
        UPDATE producto 
        SET ${updateFields.join(', ')}
        WHERE id = @id
      ''');

      await conn.execute(sql, parameters: parameters);
      return true;
    } catch (e) {
      print('Error al editar producto: $e');
      return false;
    }
  }

  // static Future<bool> actualizarStock({
  //   required int id,
  //   required int cantidad,
  //   required dynamic conn,
  // }) async {
  //   try {
  //     final sql = Sql.named('''
  //       UPDATE producto 
  //       SET stock = stock + @cantidad
  //       WHERE id = @id
  //     ''');

  //     await conn.execute(sql, parameters: {
  //       'id': id,
  //       'cantidad': cantidad,
  //     });
  //     return true;
  //   } catch (e) {
  //     print('Error al actualizar stock: $e');
  //     return false;
  //   }
  // }
static Future<bool> establecerStock({
  required int id,
  required int cantidad,
  required dynamic conn,
}) async {
  try {
    final sql = Sql.named('''
      UPDATE producto 
      SET stock = @cantidad
      WHERE id = @id
    ''');

    await conn.execute(sql, parameters: {
      'id': id,
      'cantidad': cantidad,
    });
    return true;
  } catch (e) {
    print('Error al establecer stock: $e');
    return false;
  }
}
  static Future<Producto?> obtenerProductoPorId({
    required int id,
    required dynamic conn,
  }) async {
    try {
      final sql = Sql.named('''
        SELECT id, titulo, descripcion, precioVenta, stock, 
               fechaRegistro, idCategoria, idCodigoBarras
        FROM producto
        WHERE id = @id
      ''');

      final result = await conn.execute(sql, parameters: {'id': id});
      if (result.isNotEmpty) {
        final row = result.first;
        return Producto(
          id: row[0],
          titulo: row[1]?.toString() ?? '',
          descripcion: row[2]?.toString(),
          precioVenta: row[3] is num ? (row[3] as num).toDouble() : double.parse(row[3].toString()),
          stock: row[4] is int ? row[4] : int.parse(row[4].toString()),
          fechaRegistro: row[5] != null ? DateTime.tryParse(row[5].toString()) : null,
          idCategoria: row[6] != null ? (row[6] is int ? row[6] : int.parse(row[6].toString())) : null,
          idCodigoBarras: row[7] != null ? (row[7] is int ? row[7] : int.parse(row[7].toString())) : null,
        );
      }
      return null;
    } catch (e) {
      print('Error al obtener producto por ID: $e');
      return null;
    }
  }

  static Future<List<Producto>> obtenerProductos({
    required dynamic conn,
    int? limit,
    int? offset,
    String? orderBy,
    bool ascendente = true,
    int? filtroCategoria,
  }) async {
    try {
      // Construir la consulta con filtros opcionales
      var whereClause = filtroCategoria != null ? 'WHERE idCategoria = @filtroCategoria' : '';
      var orderClause = orderBy != null 
          ? 'ORDER BY $orderBy ${ascendente ? 'ASC' : 'DESC'}'
          : 'ORDER BY id ASC';
      var limitClause = limit != null ? 'LIMIT $limit' : '';
      var offsetClause = offset != null ? 'OFFSET $offset' : '';
      
      final sql = '''
        SELECT id, titulo, descripcion, precioVenta, stock, 
               fechaRegistro, idCategoria, idCodigoBarras
        FROM producto
        $whereClause
        $orderClause
        $limitClause
        $offsetClause
      ''';

      var parameters = <String, dynamic>{};
      if (filtroCategoria != null) {
        parameters['filtroCategoria'] = filtroCategoria;
      }

      final result = await conn.execute(
        Sql.named(sql),
        parameters: parameters,
      );
      
      return result.map<Producto>((row) {
        return Producto(
          id: row[0],
          titulo: row[1]?.toString() ?? '',
          descripcion: row[2]?.toString(),
          precioVenta: row[3] is num ? (row[3] as num).toDouble() : double.parse(row[3].toString()),
          stock: row[4] is int ? row[4] : int.parse(row[4].toString()),
          fechaRegistro: row[5] != null ? DateTime.tryParse(row[5].toString()) : null,
          idCategoria: row[6] != null ? (row[6] is int ? row[6] : int.parse(row[6].toString())) : null,
          idCodigoBarras: row[7] != null ? (row[7] is int ? row[7] : int.parse(row[7].toString())) : null,
        );
      }).toList();
    } catch (e) {
      print('Error al obtener productos: $e');
      return [];
    }
  }

  static Future<List<Producto>> buscarProductos({
    required String termino,
    required dynamic conn,
  }) async {
    try {
      final sql = Sql.named('''
        SELECT id, titulo, descripcion, precioVenta, stock, 
               fechaRegistro, idCategoria, idCodigoBarras
        FROM producto
        WHERE 
          titulo ILIKE @termino OR
          descripcion ILIKE @termino
        ORDER BY titulo ASC
      ''');

      final result = await conn.execute(sql, parameters: {
        'termino': '%$termino%',
      });
      
      return result.map<Producto>((row) {
        return Producto(
          id: row[0],
          titulo: row[1]?.toString() ?? '',
          descripcion: row[2]?.toString(),
          precioVenta: row[3] is num ? (row[3] as num).toDouble() : double.parse(row[3].toString()),
          stock: row[4] is int ? row[4] : int.parse(row[4].toString()),
          fechaRegistro: row[5] != null ? DateTime.tryParse(row[5].toString()) : null,
          idCategoria: row[6] != null ? (row[6] is int ? row[6] : int.parse(row[6].toString())) : null,
          idCodigoBarras: row[7] != null ? (row[7] is int ? row[7] : int.parse(row[7].toString())) : null,
        );
      }).toList();
    } catch (e) {
      print('Error al buscar productos: $e');
      return [];
    }
  }

  static Future<bool> eliminarProducto({
    required int id,
    required dynamic conn,
  }) async {
    try {
      final sql = Sql.named('''
        DELETE FROM producto
        WHERE id = @id
      ''');

      await conn.execute(sql, parameters: {'id': id});
      return true;
    } catch (e) {
      print('Error al eliminar producto: $e');
      return false;
    }
  }
}