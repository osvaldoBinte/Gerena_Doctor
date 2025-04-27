import 'package:flutter/widgets.dart';
import 'package:postgres/postgres.dart';

class VentaProducto {
  final int id;
  final int idProducto;
  final int? idUsuario;
  final String? numeroTransaccion;
  final int cantidadProductosVendidos;
  final double precio;
  final DateTime? fechaVenta;

  VentaProducto({
    required this.id,
    required this.idProducto,
    this.idUsuario,
    this.numeroTransaccion,
    required this.cantidadProductosVendidos,
    required this.precio,
    this.fechaVenta,
  });

  factory VentaProducto.fromMap(Map<String, dynamic> map) => VentaProducto(
        id: map['id'] is String ? int.parse(map['id']) : map['id'],
        idProducto: map['idproducto'] is String ? int.parse(map['idproducto']) : map['idproducto'],
        idUsuario: map['idusuario'] != null
            ? (map['idusuario'] is String ? int.parse(map['idusuario']) : map['idusuario'])
            : null,
        numeroTransaccion: map['numerotransaccion']?.toString(),
        cantidadProductosVendidos: map['cantidadproductosvendidos'] is String
            ? int.parse(map['cantidadproductosvendidos'])
            : map['cantidadproductosvendidos'],
        precio: map['precio'] is String
            ? double.parse(map['precio'])
            : (map['precio'] as num).toDouble(),
        fechaVenta: map['fechaventa'] != null
            ? DateTime.tryParse(map['fechaventa'].toString())
            : null,
      );

  factory VentaProducto.fromRow(List<dynamic> row) => VentaProducto(
        id: row[0],
        idProducto: row[1],
        idUsuario: row[2],
        numeroTransaccion: row[3]?.toString(),
        cantidadProductosVendidos: row[4],
        precio: row[5] is num ? (row[5] as num).toDouble() : double.parse(row[5].toString()),
        fechaVenta: row.length > 6 && row[6] != null ? DateTime.tryParse(row[6].toString()) : null,
      );
}

class VentaProductoDB {
  // Registrar una venta de producto
  static Future<int?> registrarVenta({
    required int idProducto,
    int? idUsuario,
    String? numeroTransaccion,
    required int cantidadProductosVendidos,
    required double precio,
    required dynamic conn,
  }) async {
    try {
      final sql = Sql.named('''
        INSERT INTO ventaProductos (
          idProducto, idUsuario, numeroTransaccion, 
          cantidadProductosVendidos, precio
        ) VALUES (
          @idProducto, @idUsuario, @numeroTransaccion, 
          @cantidadProductosVendidos, @precio
        ) RETURNING id;
      ''');

      final result = await conn.execute(sql, parameters: {
        'idProducto': idProducto,
        'idUsuario': idUsuario,
        'numeroTransaccion': numeroTransaccion,
        'cantidadProductosVendidos': cantidadProductosVendidos,
        'precio': precio,
      });

      if (result.isNotEmpty) {
        return result.first[0] as int;
      }
      return null;
    } catch (e) {
      print('Error al registrar venta: $e');
      return null;
    }
  }

  // Obtener todas las ventas
  static Future<List<VentaProducto>> obtenerVentas({
    required dynamic conn,
    int? limit,
    int? offset,
    String? numeroTransaccion,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    try {
      // Construir cláusulas de la consulta
      final whereConditions = <String>[];
      final parameters = <String, dynamic>{};

      if (numeroTransaccion != null) {
        whereConditions.add('numeroTransaccion = @numeroTransaccion');
        parameters['numeroTransaccion'] = numeroTransaccion;
      }

      if (fechaInicio != null) {
        whereConditions.add('DATE(created_at) >= @fechaInicio');
        parameters['fechaInicio'] = fechaInicio.toIso8601String().split('T')[0];
      }

      if (fechaFin != null) {
        whereConditions.add('DATE(created_at) <= @fechaFin');
        parameters['fechaFin'] = fechaFin.toIso8601String().split('T')[0];
      }

      String whereClause = whereConditions.isNotEmpty
          ? 'WHERE ${whereConditions.join(' AND ')}'
          : '';

      String limitClause = limit != null ? 'LIMIT $limit' : '';
      String offsetClause = offset != null ? 'OFFSET $offset' : '';

      final sql = '''
        SELECT id, idProducto, idUsuario, numeroTransaccion, 
               cantidadProductosVendidos, precio, created_at
        FROM ventaProductos
        $whereClause
        ORDER BY created_at DESC
        $limitClause
        $offsetClause
      ''';

      final result = await conn.execute(
        Sql.named(sql),
        parameters: parameters,
      );

      return result.map<VentaProducto>((row) => VentaProducto.fromRow(row)).toList();
    } catch (e) {
      print('Error al obtener ventas: $e');
      return [];
    }
  }

  // Obtener ventas por número de transacción
  static Future<List<VentaProducto>> obtenerVentasPorTransaccion({
    required String numeroTransaccion,
    required dynamic conn,
  }) async {
    try {
      final sql = Sql.named('''
        SELECT id, idProducto, idUsuario, numeroTransaccion, 
               cantidadProductosVendidos, precio
        FROM ventaProductos
        WHERE numeroTransaccion = @numeroTransaccion
        ORDER BY id
      ''');

      final result = await conn.execute(
        sql,
        parameters: {'numeroTransaccion': numeroTransaccion},
      );

      return result.map<VentaProducto>((row) => VentaProducto.fromRow(row)).toList();
    } catch (e) {
      print('Error al obtener ventas por transacción: $e');
      return [];
    }
  }

  // Obtener ventas por usuario
  static Future<List<VentaProducto>> obtenerVentasPorUsuario({
    required int idUsuario,
    required dynamic conn,
  }) async {
    try {
      final sql = Sql.named('''
        SELECT id, idProducto, idUsuario, numeroTransaccion, 
               cantidadProductosVendidos, precio
        FROM ventaProductos
        WHERE idUsuario = @idUsuario
        ORDER BY created_at DESC
      ''');

      final result = await conn.execute(
        sql,
        parameters: {'idUsuario': idUsuario},
      );

      return result.map<VentaProducto>((row) => VentaProducto.fromRow(row)).toList();
    } catch (e) {
      print('Error al obtener ventas por usuario: $e');
      return [];
    }
  }

  // Eliminar una venta (posiblemente para cancelaciones)
  static Future<bool> eliminarVenta({
    required int id,
    required dynamic conn,
  }) async {
    try {
      final sql = Sql.named('''
        DELETE FROM ventaProductos
        WHERE id = @id
      ''');

      await conn.execute(sql, parameters: {'id': id});
      return true;
    } catch (e) {
      print('Error al eliminar venta: $e');
      return false;
    }
  }

  // Calcular ventas totales en un período
  static Future<double> calcularVentasTotales({
    required dynamic conn,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    try {
      final whereConditions = <String>[];
      final parameters = <String, dynamic>{};

      if (fechaInicio != null) {
        whereConditions.add('DATE(created_at) >= @fechaInicio');
        parameters['fechaInicio'] = fechaInicio.toIso8601String().split('T')[0];
      }

      if (fechaFin != null) {
        whereConditions.add('DATE(created_at) <= @fechaFin');
        parameters['fechaFin'] = fechaFin.toIso8601String().split('T')[0];
      }

      String whereClause = whereConditions.isNotEmpty
          ? 'WHERE ${whereConditions.join(' AND ')}'
          : '';

      final sql = '''
        SELECT SUM(precio) as total
        FROM ventaProductos
        $whereClause
      ''';

      final result = await conn.execute(
        Sql.named(sql),
        parameters: parameters,
      );

      if (result.isEmpty || result.first[0] == null) {
        return 0.0;
      }

      final total = result.first[0];
      return total is num ? total.toDouble() : double.parse(total.toString());
    } catch (e) {
      print('Error al calcular ventas totales: $e');
      return 0.0;
    }
  }
}