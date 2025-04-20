import 'package:flutter/widgets.dart';
import 'package:postgres/postgres.dart';

class Usuario {
  final int id;
  final String nombre;
  final String apellidos;
  final String correo;
  final String telefono;
  final DateTime? fechaNacimiento;
  final String sexo;
  final String? status;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.correo,
    required this.telefono,
    this.fechaNacimiento,
    required this.sexo,
    this.status,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) => Usuario(
        id: map['id'] is String ? int.parse(map['id']) : map['id'],
        nombre: map['nombre']?.toString() ?? '',
        apellidos: map['apellidos']?.toString() ?? '',
        correo: map['correo']?.toString() ?? '',
        telefono: map['telefono']?.toString() ?? '',
        fechaNacimiento: map['fechanacimiento'] != null
            ? DateTime.tryParse(map['fechanacimiento'].toString())
            : null,
        sexo: map['sexo']?.toString() ?? '',
        status: map['status']?.toString(),
      );
}

class UsuarioDB {
  static Future<int?> crearUsuario({
    required String nombre,
    required String apellidos,
    required String correo,
    required String telefono,
    DateTime? fechaNacimiento,
    required String sexo,
    required dynamic conn,
  }) async {
    try {
      final sql = Sql.named('''
        INSERT INTO usuarios (
          nombre, apellidos, correo, telefono, fechaNacimiento, sexo
        ) VALUES (
          @nombre, @apellidos, @correo, @telefono, @fechaNacimiento, @sexo
        ) RETURNING id;
      ''');

      final result = await conn.execute(sql, parameters: {
        'nombre': nombre,
        'apellidos': apellidos,
        'correo': correo,
        'telefono': telefono,
        'fechaNacimiento': fechaNacimiento?.toIso8601String(),
        'sexo': sexo,
      });

      if (result.isNotEmpty) {
        return result.first[0] as int;
      }
      return null;
    } catch (e) {
      print('Error al crear usuario: $e');
      return null;
    }
  }

  static Future<int?> crearMetodoAcceso({
    required int idUsuario,
    required String tipoAcceso,
    required dynamic conn,
  }) async {
    try {
      final sql = Sql.named('''
        INSERT INTO metodoAcceso (idUsuario, tipoAcceso)
        VALUES (@idUsuario, @tipoAcceso)
        RETURNING id;
      ''');
      final result = await conn.execute(sql, parameters: {
        'idUsuario': idUsuario,
        'tipoAcceso': tipoAcceso,
      });
      return result.isNotEmpty ? result.first[0] as int : null;
    } catch (e) {
      print('Error al crear método de acceso: $e');
      return null;
    }
  }

  static Future<void> crearCodigoQR({
    required String qr,
    required int idUsuario,
    required int idMetodoAcceso,
    required dynamic conn,
  }) async {
    try {
      final sql = Sql.named('''
        INSERT INTO codigoQR (codigoQr, idUsuario, idMetodoAcceso)
        VALUES (@codigoQr, @idUsuario, @idMetodoAcceso)
      ''');
      await conn.execute(sql, parameters: {
        'codigoQr': qr,
        'idUsuario': idUsuario,
        'idMetodoAcceso': idMetodoAcceso,
      });
    } catch (e) {
      print('Error al crear QR: $e');
    }
  }

  static Future<void> crearRegistroHuella({
    required String plantilla,
    required int idMetodoAcceso,
    required dynamic conn,
  }) async {
    try {
      final sql = Sql.named('''
        INSERT INTO registroHuellas (plantillaHuella, hashHuella, idMetodoAcceso)
        VALUES (@plantilla, @hash, @idMetodoAcceso)
      ''');
      await conn.execute(sql, parameters: {
        'plantilla': plantilla,
        'hash': plantilla.hashCode.toString(),
        'idMetodoAcceso': idMetodoAcceso,
      });
    } catch (e) {
      print('Error al crear huella: $e');
    }
  }

  static Future<int?> crearVentaMembresia({
    required int idTipoMembresia,
    required int idUsuario,
    required double precio,
    required int duracion,
    required dynamic conn,
  }) async {
    try {
      final sql = Sql.named('''
        INSERT INTO "ventamembresías" (idTipoMembresia, idUsuario, precio, duracion)
        VALUES (@idTipoMembresia, @idUsuario, @precio, @duracion)
        RETURNING id;
      ''');
      final result = await conn.execute(sql, parameters: {
        'idTipoMembresia': idTipoMembresia,
        'idUsuario': idUsuario,
        'precio': precio,
        'duracion': duracion,
      });
      return result.isNotEmpty ? result.first[0] as int : null;
    } catch (e) {
      print('Error al crear venta membresía: $e');
      return null;
    }
  }

  static Future<int?> crearMembresiaUsuario({
    required int idUsuario,
    required int idVentaMembresia,
    required DateTime inicio,
    required DateTime fin,
    required dynamic conn,
  }) async {
    try {
      final sql = Sql.named('''
        INSERT INTO membresiaUsuario (idUsuario, id_ventaMembresia, fechaInicio, fechaFin)
        VALUES (@idUsuario, @idVentaMembresia, @fechaInicio, @fechaFin)
        RETURNING id;
      ''');
      final result = await conn.execute(sql, parameters: {
        'idUsuario': idUsuario,
        'idVentaMembresia': idVentaMembresia,
        'fechaInicio': inicio.toIso8601String(),
        'fechaFin': fin.toIso8601String(),
      });
      return result.isNotEmpty ? result.first[0] as int : null;
    } catch (e) {
      print('Error al crear membresía usuario: $e');
      return null;
    }
  }

  static Future<int?> crearHistorialPago({
    required int idMembresiaUsuario,
    required double montoPago,
    required String metodoPago,
    String? numeroReferencia,
    DateTime? fechaProximoPago,
    required dynamic conn,
  }) async {
    debugPrint('Creando historial de pago...');
    debugPrint('ID Membresía Usuario: $idMembresiaUsuario');
    debugPrint('Monto Pago: $montoPago');
    debugPrint('Método Pago: $metodoPago');
    debugPrint('Número Referencia: $numeroReferencia');
    debugPrint('Fecha Próximo Pago: ${fechaProximoPago?.toIso8601String()}');
    try {
      final sql = Sql.named('''
        INSERT INTO historialPagos (
          idMembresiaUsuario, montoPago, metodoPago, estado, 
          numeroReferencia, fechaProximoPago
        ) VALUES (
          @idMembresiaUsuario, @montoPago, @metodoPago, 'pagado', 
          @numeroReferencia, @fechaProximoPago
        ) RETURNING id;
      ''');
      final result = await conn.execute(sql, parameters: {
        'idMembresiaUsuario': idMembresiaUsuario,
        'montoPago': montoPago,
        'metodoPago': metodoPago,
        'numeroReferencia': numeroReferencia,
        'fechaProximoPago': fechaProximoPago?.toIso8601String(),
      });
      if (result.isNotEmpty) {
        print('Historial de pago creado ID: ${result.first[0]}');
        return result.first[0] as int;
      }
      return null;
    } catch (e) {
      print('Error al crear historial de pago: $e');
      return null;
    }
  }

  static Future<List<Usuario>> obtenerUsuarios({required dynamic conn}) async {
    try {
      final result = await conn.execute(
        'SELECT id, nombre, apellidos, correo, telefono, fechaNacimiento, sexo, status FROM usuarios'
      );
      return result.map<Usuario>((row) {
        // Los índices deben coincidir con el orden del SELECT arriba
        return Usuario(
          id: row[0],
          nombre: row[1]?.toString() ?? '',
          apellidos: row[2]?.toString() ?? '',
          correo: row[3]?.toString() ?? '',
          telefono: row[4]?.toString() ?? '',
          fechaNacimiento: row[5] != null ? DateTime.tryParse(row[5].toString()) : null,
          sexo: row[6]?.toString() ?? '',
          status: row[7]?.toString(),
        );
      }).toList();
    } catch (e) {
      print('Error al obtener usuarios: $e');
      return [];
    }
  }
}