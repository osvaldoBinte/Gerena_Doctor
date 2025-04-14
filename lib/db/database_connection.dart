import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  factory DatabaseService() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
     -- Creación de tablas para sistema de control de acceso con huellas digitales
-- Con sincronización local y en la nube
-- SQLite

-- Tabla de Usuarios
CREATE TABLE IF NOT EXISTS Usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    apellidos TEXT NOT NULL,
    correo TEXT UNIQUE,
    telefono TEXT,
    fechaNacimiento DATE,
    fechaRegistro DATE DEFAULT (DATE('now')),
    registroHuella INTEGER DEFAULT 0, -- BOOLEAN en SQLite se maneja como INTEGER
    sincronizarNube INTEGER DEFAULT 1, -- BOOLEAN en SQLite se maneja como INTEGER
    idNube TEXT UNIQUE
);

-- Índices para la tabla Usuarios
CREATE INDEX IF NOT EXISTS idx_usuarios_nombre ON Usuarios(nombre, apellidos);
CREATE INDEX IF NOT EXISTS idx_usuarios_correo ON Usuarios(correo);
CREATE INDEX IF NOT EXISTS idx_usuarios_idnube ON Usuarios(idNube);

-- Tabla de Registro de Huellas
CREATE TABLE IF NOT EXISTS RegistroHuellas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    idUsuario INTEGER NOT NULL,
    plantillaHuella BLOB NOT NULL, -- Almacena la información biométrica
    hashHuella TEXT NOT NULL, -- Hash para verificación
    fechaRegistro TEXT DEFAULT (DATETIME('now')),
    sincronizacionNube INTEGER DEFAULT 0, -- BOOLEAN en SQLite se maneja como INTEGER
    idNube TEXT UNIQUE,
    FOREIGN KEY (idUsuario) REFERENCES Usuarios(id) ON DELETE CASCADE
);

-- Índices para la tabla RegistroHuellas
CREATE INDEX IF NOT EXISTS idx_huellas_idusuario ON RegistroHuellas(idUsuario);
CREATE INDEX IF NOT EXISTS idx_huellas_idnube ON RegistroHuellas(idNube);

-- Tabla de Membresías
CREATE TABLE IF NOT EXISTS Membresia (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    idUsuario INTEGER NOT NULL,
    tipoMembresia TEXT NOT NULL, -- Ej: "Básica", "Premium", "VIP"
    duracion TEXT NOT NULL,
    titulo TEXT NOT NULL,
    descripcion TEXT NOT NULL,
    Precio TEXT NOT NULL,
    fechaInicio DATE NOT NULL DEFAULT (DATE('now')),
    fechaFin DATE,
    statusMembresia TEXT NOT NULL DEFAULT 'Activa', -- Activa, Suspendida, Cancelada, etc.
    sincronizacionNube INTEGER DEFAULT 0, -- BOOLEAN en SQLite se maneja como INTEGER
    idNube TEXT UNIQUE,
    FOREIGN KEY (idUsuario) REFERENCES Usuarios(id) ON DELETE CASCADE
);

-- Índices para la tabla Membresia
CREATE INDEX IF NOT EXISTS idx_membresia_idusuario ON Membresia(idUsuario);
CREATE INDEX IF NOT EXISTS idx_membresia_status ON Membresia(statusMembresia);
CREATE INDEX IF NOT EXISTS idx_membresia_fechas ON Membresia(fechaInicio, fechaFin);
CREATE INDEX IF NOT EXISTS idx_membresia_idnube ON Membresia(idNube);

-- Tabla de Registro de Accesos
CREATE TABLE IF NOT EXISTS RegistroAccesos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    idUsuario INTEGER NOT NULL,
    idHuella INTEGER NOT NULL,
    fechaEntrada TEXT NOT NULL DEFAULT (DATETIME('now')),
    fechaSalida TEXT,
    sincronizacionNube INTEGER DEFAULT 0, -- BOOLEAN en SQLite se maneja como INTEGER
    idNube TEXT UNIQUE,
    FOREIGN KEY (idUsuario) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (idHuella) REFERENCES RegistroHuellas(id) ON DELETE CASCADE
);

-- Índices para la tabla RegistroAccesos
CREATE INDEX IF NOT EXISTS idx_accesos_idusuario ON RegistroAccesos(idUsuario);
CREATE INDEX IF NOT EXISTS idx_accesos_idhuella ON RegistroAccesos(idHuella);
CREATE INDEX IF NOT EXISTS idx_accesos_fechas ON RegistroAccesos(fechaEntrada, fechaSalida);
CREATE INDEX IF NOT EXISTS idx_accesos_idnube ON RegistroAccesos(idNube);

-- Tabla de Pagos
CREATE TABLE IF NOT EXISTS Pagos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    idUsuario INTEGER NOT NULL,
    idMembresia INTEGER NOT NULL,
    monto REAL NOT NULL, -- DECIMAL en SQLite se usa como REAL
    fechaPago TEXT NOT NULL DEFAULT (DATETIME('now')),
    metodoPago TEXT NOT NULL, -- Efectivo, Tarjeta, Transferencia, etc.
    sincronizacionNube INTEGER DEFAULT 0, -- BOOLEAN en SQLite se maneja como INTEGER
    idNube TEXT UNIQUE,
    FOREIGN KEY (idUsuario) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (idMembresia) REFERENCES Membresia(id) ON DELETE CASCADE
);

-- Índices para la tabla Pagos
CREATE INDEX IF NOT EXISTS idx_pagos_idusuario ON Pagos(idUsuario);
CREATE INDEX IF NOT EXISTS idx_pagos_idmembresia ON Pagos(idMembresia);
CREATE INDEX IF NOT EXISTS idx_pagos_fechapago ON Pagos(fechaPago);
CREATE INDEX IF NOT EXISTS idx_pagos_idnube ON Pagos(idNube);

-- Tabla de Control de Sincronización
CREATE TABLE IF NOT EXISTS ControlSincronizacion (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombreTabla TEXT NOT NULL,
    idRegistro INTEGER NOT NULL,
    ultimaSincronizacion TEXT NOT NULL DEFAULT (DATETIME('now')),
    estadoSincronizacion TEXT NOT NULL DEFAULT 'Pendiente', -- Pendiente, Completada, Error
    intentos INTEGER DEFAULT 0,
    mensajeError TEXT
);

-- Índices para la tabla ControlSincronizacion
CREATE INDEX IF NOT EXISTS idx_sync_nombreTabla ON ControlSincronizacion(nombreTabla);
CREATE INDEX IF NOT EXISTS idx_sync_estado ON ControlSincronizacion(estadoSincronizacion);
CREATE INDEX IF NOT EXISTS idx_sync_ultSincro ON ControlSincronizacion(ultimaSincronizacion);

-- Triggers para marcar cambios para sincronización
CREATE TRIGGER IF NOT EXISTS sync_usuarios_trigger
AFTER INSERT ON Usuarios
FOR EACH ROW
WHEN NEW.sincronizarNube = 1
BEGIN
    INSERT INTO ControlSincronizacion (nombreTabla, idRegistro)
    VALUES ('Usuarios', NEW.id);
END;

CREATE TRIGGER IF NOT EXISTS sync_huellas_trigger
AFTER INSERT ON RegistroHuellas
FOR EACH ROW
BEGIN
    INSERT INTO ControlSincronizacion (nombreTabla, idRegistro)
    VALUES ('RegistroHuellas', NEW.id);
END;

CREATE TRIGGER IF NOT EXISTS sync_membresia_trigger
AFTER INSERT ON Membresia
FOR EACH ROW
BEGIN
    INSERT INTO ControlSincronizacion (nombreTabla, idRegistro)
    VALUES ('Membresia', NEW.id);
END;

CREATE TRIGGER IF NOT EXISTS sync_accesos_trigger
AFTER INSERT ON RegistroAccesos
FOR EACH ROW
BEGIN
    INSERT INTO ControlSincronizacion (nombreTabla, idRegistro)
    VALUES ('RegistroAccesos', NEW.id);
END;

CREATE TRIGGER IF NOT EXISTS sync_pagos_trigger
AFTER INSERT ON Pagos
FOR EACH ROW
BEGIN
    INSERT INTO ControlSincronizacion (nombreTabla, idRegistro)
    VALUES ('Pagos', NEW.id);
END;
    ''');
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}
