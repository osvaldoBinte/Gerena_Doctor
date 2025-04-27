import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managegym/db/database_connection.dart';
import 'package:managegym/productos/presentation/productos/crearProducto/connection/producto_model.dart';
import 'package:managegym/productos/presentation/ventaProducto/ventaProducto_model.dart';
import 'package:uuid/uuid.dart';

class ProductoCarrito {
  final Producto producto;
  final RxInt cantidad;

  ProductoCarrito({
    required this.producto,
    int cantidad = 1,
  }) : cantidad = cantidad.obs;

  double get subtotal => producto.precioVenta * cantidad.value;
}

class VentaProductosController extends GetxController {
  // Controladores de texto
  final TextEditingController buscadorProductoController = TextEditingController();
  final TextEditingController buscadorClienteController = TextEditingController();
  final TextEditingController pagoController = TextEditingController();
  
  // FormKey para validación
  final formKey = GlobalKey<FormState>();
  
  // Estados de la interfaz
  final isLoading = false.obs;
  final isSearchingProducts = false.obs;
  final isSearchingClients = false.obs;
  final isProcessingVenta = false.obs;
  
  // Alias para compatibilidad con la interfaz existente
  RxBool get isSearching => isSearchingProducts;
  
  // Lista de productos encontrados en la búsqueda
  final productosEncontrados = <Producto>[].obs;
  
  // Lista de productos en el carrito de compra
  final productosCarrito = <ProductoCarrito>[].obs;
  
  // Cliente seleccionado (opcional)
  final idClienteSeleccionado = RxnInt(null);
  final nombreClienteSeleccionado = ''.obs;
  
  // Cálculo de totales
  final totalVenta = 0.0.obs;
  final pagoCon = 0.0.obs;
  final cambio = 0.0.obs;
  
 @override
void onInit() {
  super.onInit();
  
  // Inicializar la conexión a la base de datos si es necesario
  try {
    initializeDB().then((_) {
      // Cargar todos los productos al inicio
      cargarTodosLosProductos();
    });
  } catch (e) {
    print("Error inicializando DB: $e");
  }
  
  // Configurar listener para el campo de pago
  pagoController.addListener(_calcularCambio);
  
  // Configurar listener para actualizar total cuando cambie el carrito
  ever(productosCarrito, (_) => _calcularTotal());
}

// Método para cargar todos los productos
Future<void> cargarTodosLosProductos() async {
  try {
    isSearchingProducts.value = true;
    
    // Obtener todos los productos
    final productos = await ProductoDB.obtenerProductos(
      conn: Database.conn,
    );
    
    productosEncontrados.value = productos;
    
    if (productos.isEmpty) {
      print('No hay productos registrados en la base de datos');
    } else {
      print('Se cargaron ${productos.length} productos');
    }
  } catch (e) {
    print('Error al cargar productos: $e');
   
  } finally {
    isSearchingProducts.value = false;
  }
}
  
  Future<void> initializeDB() async {
    try {
      try {
        // Verificar si la conexión ya existe
        Database.conn;
      } catch (e) {
        // Si hay un error, inicializar la conexión
        await Database.connect();
        print('✅ Conexión a la base de datos inicializada');
      }
    } catch (e) {
      print('❌ Error inicializando la conexión: $e');
      Get.snackbar(
        'Error de conexión',
        'No se pudo conectar a la base de datos: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  // BÚSQUEDA DE PRODUCTOS
  
  Future<void> buscarProductos(String termino) async {
  try {
    isSearchingProducts.value = true;
    
    if (termino.isEmpty) {
      // Si no hay término de búsqueda, cargar todos los productos
      final productos = await ProductoDB.obtenerProductos(
        conn: Database.conn,
      );
      
      productosEncontrados.value = productos;
    } else {
      // Buscar productos con el término
      final productos = await ProductoDB.buscarProductos(
        termino: termino,
        conn: Database.conn,
      );
      
      productosEncontrados.value = productos;
    }
    
    // Mensaje si no se encuentran productos
    if (productosEncontrados.isEmpty) {
      print('No se encontraron productos');
    }
  } catch (e) {
    print('Error al buscar productos: $e');
    Get.snackbar(
      'Error',
      'No se pudieron buscar los productos: $e',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  } finally {
    isSearchingProducts.value = false;
  }
}
  // MANEJO DEL CARRITO
  
  // Método original
  void agregarAlCarrito(Producto producto) {
    // Verificar si hay stock disponible
    if (producto.stock <= 0) {
      Get.snackbar(
        'Sin stock',
        'El producto ${producto.titulo} no tiene stock disponible',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // Buscar si el producto ya está en el carrito
    final index = productosCarrito.indexWhere((item) => item.producto.id == producto.id);
    
    if (index >= 0) {
      // Producto ya en carrito, verificar si hay suficiente stock
      final productoExistente = productosCarrito[index];
      if (productoExistente.cantidad.value >= producto.stock) {
        Get.snackbar(
          'Stock insuficiente',
          'No hay más unidades disponibles de ${producto.titulo}',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      // Incrementar cantidad
      productoExistente.cantidad.value++;
      Get.snackbar(
        'Producto añadido',
        'Se añadió una unidad más de ${producto.titulo}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1),
      );
    } else {
      // Añadir nuevo producto al carrito
      productosCarrito.add(ProductoCarrito(producto: producto));
      Get.snackbar(
        'Producto añadido',
        'Se añadió ${producto.titulo} al carrito',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1),
      );
    }
    
    _calcularTotal();
  }
  
  // Alias para mantener compatibilidad
  void agregarProductoAlCarrito(Producto producto) {
    agregarAlCarrito(producto);
  }
  
 void cambiarCantidadProducto(int index, int nuevaCantidad) {
  if (index < 0 || index >= productosCarrito.length) return;
  
  final productoCarrito = productosCarrito[index];
  final stockDisponible = productoCarrito.producto.stock;
  
  if (nuevaCantidad <= 0) {
    // Remover producto si la cantidad es 0 o menor
    productosCarrito.removeAt(index);
    Get.snackbar(
      'Producto eliminado',
      'Se eliminó ${productoCarrito.producto.titulo} del carrito',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 1),
    );
    return;
  }
  
  if (nuevaCantidad > stockDisponible) {
    nuevaCantidad = stockDisponible;
    Get.snackbar(
      'Stock limitado',
      'Solo hay $stockDisponible unidades disponibles',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  // Actualizar cantidad
  productoCarrito.cantidad.value = nuevaCantidad;
  _calcularTotal();
}
  
  void eliminarDelCarrito(int index) {
    if (index >= 0 && index < productosCarrito.length) {
      final producto = productosCarrito[index].producto;
      productosCarrito.removeAt(index);
      
      Get.snackbar(
        'Producto eliminado',
        'Se eliminó ${producto.titulo} del carrito',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1),
      );
      
      _calcularTotal();
    }
  }
  
  void limpiarCarrito() {
    productosCarrito.clear();
    _calcularTotal();
  }
  
  // CÁLCULOS
  
  void _calcularTotal() {
    double total = 0;
    for (var item in productosCarrito) {
      total += item.subtotal;
    }
    totalVenta.value = total;
    _calcularCambio();
  }
  
void _calcularCambio() {
  // Si el campo está vacío, asignar 0 tanto al pago como al cambio
  if (pagoController.text.isEmpty) {
    pagoCon.value = 0.0;
    cambio.value = 0.0;  // Ahora mostrará 0.00 en lugar de valor negativo
  } else {
    // Si hay un valor, calcularlo normalmente
    final pago = double.tryParse(pagoController.text) ?? 0.0;
    pagoCon.value = pago;
    cambio.value = pago - totalVenta.value;
  }
}
  
  // PROCESAR VENTA
  
  bool validarVenta() {
    if (productosCarrito.isEmpty) {
      Get.snackbar(
        'Carrito vacío',
        'No hay productos en el carrito para realizar la venta',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    
    final pago = double.tryParse(pagoController.text) ?? 0.0;
    if (pago <= 0) {
      Get.snackbar(
        'Pago inválido',
        'Ingrese un monto de pago válido',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    
    if (pago < totalVenta.value) {
      Get.snackbar(
        'Pago insuficiente',
        'El pago es menor que el total de la venta',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    
    return true;
  }
  
  Future<bool> procesarVenta() async {
    if (!validarVenta()) return false;
    
    try {
      isProcessingVenta.value = true;
      
      // Generar número de transacción único
      final String numeroTransaccion = Uuid().v4();
      
      // Iniciar transacción en la base de datos
      await Database.conn.execute('BEGIN');
      
      try {
        // Registrar ventas y actualizar inventario
        for (var productoCarrito in productosCarrito) {
          final producto = productoCarrito.producto;
          final cantidad = productoCarrito.cantidad.value;
          final subtotal = productoCarrito.subtotal;
          
          // 1. Registrar la venta
          final idVenta = await VentaProductoDB.registrarVenta(
            idProducto: producto.id,
            idUsuario: idClienteSeleccionado.value,
            numeroTransaccion: numeroTransaccion,
            cantidadProductosVendidos: cantidad,
            precio: subtotal,
            conn: Database.conn,
          );
          
          if (idVenta == null) {
            throw Exception('Error al registrar la venta para el producto ${producto.titulo}');
          }
          
          // 2. Actualizar stock del producto
          final nuevoStock = producto.stock - cantidad;
          final stockActualizado = await ProductoDB.asignarStock(
  id: producto.id,
  cantidad: nuevoStock,
  conn: Database.conn,
);
          
          if (!stockActualizado) {
            throw Exception('Error al actualizar el stock del producto ${producto.titulo}');
          }
        }
        
        // Si todo sale bien, confirmar la transacción
        await Database.conn.execute('COMMIT');
        
        // Limpiar formulario después de la venta
        _limpiarFormulario();
        
        Get.snackbar(
          'Venta exitosa',
          'La venta se ha procesado correctamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        
        return true;
      } catch (e) {
        // Si hay error, hacer rollback de la transacción
        await Database.conn.execute('ROLLBACK');
        throw e;
      }
    } catch (e) {
      print('Error al procesar la venta: $e');
      Get.snackbar(
        'Error en la venta',
        'Ocurrió un error al procesar la venta: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isProcessingVenta.value = false;
    }
  }
  
void _limpiarFormulario() {
  productosCarrito.clear();
  pagoController.clear();
  // buscadorProductoController.clear(); // ❌ comenta o elimina esta línea
  // buscadorClienteController.clear(); // ❌ comenta o elimina esta línea
  //productosEncontrados.clear();
  idClienteSeleccionado.value = null;
  nombreClienteSeleccionado.value = '';
  totalVenta.value = 0.0;
  pagoCon.value = 0.0;
  cambio.value = 0.0;
}

  // Función para cancelar la venta actual
  void cancelarVenta() {
    // Mostrar diálogo de confirmación
    Get.dialog(
      AlertDialog(
        title: Text('Cancelar venta'),
        content: Text('¿Estás seguro de que deseas cancelar la venta actual?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              _limpiarFormulario();
              Get.back();
            },
            child: Text('Sí'),
          ),
        ],
      ),
    );
  }
  
  // CLIENTE
  
  void seleccionarCliente(int id, String nombre) {
    idClienteSeleccionado.value = id;
    nombreClienteSeleccionado.value = nombre;
  }
  
  void cancelarSeleccionCliente() {
    idClienteSeleccionado.value = null;
    nombreClienteSeleccionado.value = '';
  }
  
  @override
  void onClose() {
    // Liberar recursos
    buscadorProductoController.dispose();
    buscadorClienteController.dispose();
    pagoController.dispose();
    super.onClose();
  }
}