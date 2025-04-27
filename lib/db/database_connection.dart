import 'package:postgres/postgres.dart';

class Database {
  static late final Connection conn;

  static Future<void> connect()  async {
conn = await Connection.open(
  Endpoint(
    host: 'localhost',
    port: 5432,
    database: 'gym',
    username: 'postgres',
    password: '13960',
  ),
  settings: const ConnectionSettings(sslMode: SslMode.disable),
);
    print('✅ Conexión establecida con PostgreSQL.');
    await _crearTablasSiNoExisten();
  }

  static Future<void> _crearTablasSiNoExisten() async {
    try {
      // Ejecutar cada sentencia SQL por separado
      final statements = [
        // Tabla usuarios
        '''
        CREATE TABLE IF NOT EXISTS usuarios (
          id SERIAL PRIMARY KEY,
          nombre VARCHAR(100) NOT NULL,
          apellidos VARCHAR(100) NOT NULL,
          correo VARCHAR(150) UNIQUE NOT NULL,
          telefono VARCHAR(20),
          fechaNacimiento DATE,
          fechaRegistro DATE NOT NULL DEFAULT CURRENT_DATE,
          sexo VARCHAR(1) CHECK (sexo IN ('M', 'F')),
          peso DECIMAL(5,2),
          altura DECIMAL(5,2),
          imgPerfil VARCHAR(255),
          status VARCHAR(10) CHECK (status IN ('activo', 'inactivo', 'pendiente', 'suspendido')) DEFAULT 'activo',
          sincronizarNube BOOLEAN DEFAULT FALSE,
          idNube INTEGER
        )
        ''',
        
        // Tabla administrador - MODIFICADA para incluir correo y contraseña
        '''
        CREATE TABLE IF NOT EXISTS administrador (
          id SERIAL PRIMARY KEY,
          tipoAdmin VARCHAR(15) CHECK (tipoAdmin IN ('SuperAdmin', 'admin', 'secundario')) NOT NULL,
          idUsuario INTEGER NOT NULL REFERENCES usuarios(id),
          correo VARCHAR(150) UNIQUE NOT NULL,
          contrasena VARCHAR(255) NOT NULL
        )
        ''',
        
        // Tabla permisos
        '''
        CREATE TABLE IF NOT EXISTS permisos (
          id SERIAL PRIMARY KEY,
          idAdministrador INTEGER NOT NULL REFERENCES administrador(id),
          editar BOOLEAN DEFAULT FALSE,
          eliminar BOOLEAN DEFAULT FALSE,
          actualizar BOOLEAN DEFAULT FALSE,
          agregar BOOLEAN DEFAULT FALSE,
          todosLosPermisos BOOLEAN DEFAULT FALSE
        )
        ''',
        
        // Tabla registros
        '''
        CREATE TABLE IF NOT EXISTS registros (
          id SERIAL PRIMARY KEY,
          id_administrador INTEGER NOT NULL REFERENCES administrador(id),
          fecha DATE NOT NULL DEFAULT CURRENT_DATE,
          query TEXT
        )
        ''',
        
        // Tabla metodoAcceso
        '''
        CREATE TABLE IF NOT EXISTS metodoAcceso (
          id SERIAL PRIMARY KEY,
          idUsuario INTEGER NOT NULL REFERENCES usuarios(id),
          tipoAcceso VARCHAR(10) CHECK (tipoAcceso IN ('QR', 'Huella')) NOT NULL
        )
        ''',
        
        // Tabla registroAcceso
        '''
        CREATE TABLE IF NOT EXISTS registroAcceso (
          id SERIAL PRIMARY KEY,
          idUsuario INTEGER NOT NULL REFERENCES usuarios(id),
          idMetodoAcceso INTEGER NOT NULL REFERENCES metodoAcceso(id),
          registroEntrada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          registroSalida TIMESTAMP
        )
        ''',
        
        // Tabla codigoQR
        '''
        CREATE TABLE IF NOT EXISTS codigoQR (
          id SERIAL PRIMARY KEY,
          codigoQr VARCHAR(255) NOT NULL UNIQUE,
          fechaCreacion DATE NOT NULL DEFAULT CURRENT_DATE,
          idUsuario INTEGER NOT NULL REFERENCES usuarios(id),
          status VARCHAR(10) CHECK (status IN ('Activo', 'Inactivo')) DEFAULT 'Activo',
          idMetodoAcceso INTEGER NOT NULL REFERENCES metodoAcceso(id)
        )
        ''',
        
        // Tabla categorias
        '''
        CREATE TABLE IF NOT EXISTS categorias (
          id SERIAL PRIMARY KEY,
          titulo VARCHAR(100) NOT NULL
        )
        ''',
        
        // Tabla tipoMembresia
        '''
        CREATE TABLE IF NOT EXISTS tipoMembresia (
          id SERIAL PRIMARY KEY,
          titulo VARCHAR(100) NOT NULL,
          descripcion TEXT,
          precio DECIMAL(10,2) NOT NULL,
          tiempoDuracion INTEGER NOT NULL
        )
        ''',
        
        // Tabla ventaMembresías
        '''
        CREATE TABLE IF NOT EXISTS ventaMembresías (
          id SERIAL PRIMARY KEY,
          idTipoMembresia INTEGER NOT NULL REFERENCES tipoMembresia(id),
          idUsuario INTEGER NOT NULL REFERENCES usuarios(id),
          fechaCompra DATE NOT NULL DEFAULT CURRENT_DATE,
          precio DECIMAL(10,2) NOT NULL,
          duracion INTEGER NOT NULL
        )
        ''',
        
        // Tabla membresiaUsuario
        '''
        CREATE TABLE IF NOT EXISTS membresiaUsuario (
          id SERIAL PRIMARY KEY,
          idUsuario INTEGER NOT NULL REFERENCES usuarios(id),
          id_ventaMembresia INTEGER NOT NULL REFERENCES ventaMembresías(id),
          fechaInicio DATE NOT NULL DEFAULT CURRENT_DATE,
          fechaFin DATE NOT NULL,
          statusMembresia VARCHAR(10) CHECK (statusMembresia IN ('Activa', 'Inactiva')) DEFAULT 'Activa',
          sincronizacionNube BOOLEAN DEFAULT FALSE,
          idNube INTEGER
        )
        ''',
        
        // Tabla codigoBarras
        '''
        CREATE TABLE IF NOT EXISTS codigoBarras (
          id SERIAL PRIMARY KEY,
          codigoBarras VARCHAR(255) NOT NULL UNIQUE,
          fechaCreacion DATE NOT NULL DEFAULT CURRENT_DATE,
          fila_3 VARCHAR(255)
        )
        ''',
        
        // Tabla producto
        '''
          CREATE TABLE IF NOT EXISTS producto (
            id SERIAL PRIMARY KEY,
            titulo VARCHAR(100) NOT NULL,
            descripcion TEXT,
            precioVenta DECIMAL(10,2) NOT NULL,
            stock INTEGER NOT NULL DEFAULT 0,
            fechaRegistro DATE NOT NULL DEFAULT CURRENT_DATE,
            idCategoria INTEGER REFERENCES categorias(id),
            idCodigoBarras INTEGER REFERENCES codigoBarras(id),
            imagenProducto TEXT
          )
        ''',
        
        // Tabla ventaProductos
        '''
        CREATE TABLE IF NOT EXISTS ventaProductos (
          id SERIAL PRIMARY KEY,
          idProducto INTEGER NOT NULL REFERENCES producto(id),
          idUsuario INTEGER REFERENCES usuarios(id),
          numeroTransaccion VARCHAR(100),
          cantidadProductosVendidos INTEGER NOT NULL DEFAULT 1,
          precio DECIMAL(10,2) NOT NULL
        )
        ''',
        
        // Tabla registroHuellas
        '''
        CREATE TABLE IF NOT EXISTS registroHuellas (
          id SERIAL PRIMARY KEY,
          plantillaHuella TEXT NOT NULL,
          hashHuella VARCHAR(255) NOT NULL,
          fechaRegistro DATE NOT NULL DEFAULT CURRENT_DATE,
          sincronizacionNube BOOLEAN DEFAULT FALSE,
          idNube INTEGER,
          idMetodoAcceso INTEGER NOT NULL REFERENCES metodoAcceso(id)
        )
        ''',
        
        // Tabla actividades
        '''
        CREATE TABLE IF NOT EXISTS actividades (
          id SERIAL PRIMARY KEY,
          nombre VARCHAR(100) NOT NULL,
          descripcion TEXT,
          urlVideo VARCHAR(255),
          idCategoria INTEGER REFERENCES categorias(id),
          duracion INTEGER,
          nivelDificultad INTEGER CHECK (nivelDificultad BETWEEN 1 AND 5),
          instructor VARCHAR(100),
          fechaCreacion DATE NOT NULL DEFAULT CURRENT_DATE,
          horarios TEXT,
          capacidadMaxima INTEGER,
          sincronizarNube BOOLEAN DEFAULT FALSE,
          idNube INTEGER,
          estado VARCHAR(10) CHECK (estado IN ('activa', 'inactiva')) DEFAULT 'activa'
        )
        ''',
        
        // Tabla actividadUsuario
        '''
        CREATE TABLE IF NOT EXISTS actividadUsuario (
          id SERIAL PRIMARY KEY,
          idActividad INTEGER NOT NULL REFERENCES actividades(id),
          idUsuario INTEGER NOT NULL REFERENCES usuarios(id),
          fechaInscripcion DATE NOT NULL DEFAULT CURRENT_DATE,
          estado VARCHAR(15) CHECK (estado IN ('inscrito', 'completado', 'cancelado')) DEFAULT 'inscrito',
          asistencia BOOLEAN DEFAULT FALSE,
          calificacion INTEGER CHECK (calificacion BETWEEN 1 AND 5),
          comentarios TEXT
        )
        ''',
        
        // Tabla historialPagos
        '''
        CREATE TABLE IF NOT EXISTS historialPagos (
          id SERIAL PRIMARY KEY,
          idMembresiaUsuario INTEGER NOT NULL REFERENCES membresiaUsuario(id),
          fechaPago DATE NOT NULL DEFAULT CURRENT_DATE,
          montoPago DECIMAL(10,2) NOT NULL,
          metodoPago VARCHAR(50) NOT NULL,
          estado VARCHAR(10) CHECK (estado IN ('pagado', 'pendiente', 'rechazado')) DEFAULT 'pendiente',
          numeroReferencia VARCHAR(100),
          fechaProximoPago DATE
        )
        ''',
        
        // Tabla estadoSincronizacion
        '''
        CREATE TABLE IF NOT EXISTS estadoSincronizacion (
          id SERIAL PRIMARY KEY,
          ultimaSincronizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          entidadSincronizada VARCHAR(50) NOT NULL,
          elementosPendientes INTEGER DEFAULT 0,
          estadoSincronizacion VARCHAR(15) CHECK (estadoSincronizacion IN ('completado', 'pendiente', 'error')) DEFAULT 'pendiente',
          mensajeError TEXT,
          idDispositivo VARCHAR(100)
        )
        ''',
        
        // Índices
        'CREATE INDEX IF NOT EXISTS idx_usuarios_correo ON usuarios(correo)',
        'CREATE INDEX IF NOT EXISTS idx_administrador_correo ON administrador(correo)',
        'CREATE INDEX IF NOT EXISTS idx_membresiaUsuario_idUsuario ON membresiaUsuario(idUsuario)',
        'CREATE INDEX IF NOT EXISTS idx_membresiaUsuario_status ON membresiaUsuario(statusMembresia)',
        'CREATE INDEX IF NOT EXISTS idx_actividadUsuario_idUsuario ON actividadUsuario(idUsuario)',
        'CREATE INDEX IF NOT EXISTS idx_actividadUsuario_idActividad ON actividadUsuario(idActividad)',
        'CREATE INDEX IF NOT EXISTS idx_ventaProductos_idUsuario ON ventaProductos(idUsuario)',
        'CREATE INDEX IF NOT EXISTS idx_registroAcceso_idUsuario ON registroAcceso(idUsuario)',
        'CREATE INDEX IF NOT EXISTS idx_producto_categoria ON producto(idCategoria)'
      ];
      
      // Ejecutar cada sentencia por separado
      for (final sql in statements) {
        await conn.execute(sql);
      }
      
      print('✅ Tablas e índices creados o ya existen.');
    } catch (e) {
      print('❌ Error al crear las tablas: $e');
      // Opcionalmente, puedes relanzar la excepción si quieres que termine la aplicación
      rethrow;
    }
  }
  static Future<void> execute(String sql) async {
    try {
      await conn.execute(sql);
      print('✅ Consulta ejecutada: $sql');
    } catch (e) {
      print('❌ Error al ejecutar la consulta: $e');
    }
  }

  static Future<void> close() async {
    await conn.close();
    print('🔌 Conexión cerrada.');
  }

  
}