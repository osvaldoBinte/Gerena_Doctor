import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

class HistorialDePedidosContent extends StatelessWidget {
  const HistorialDePedidosContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GerenaColors.backgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderCard(
              fecha: 'MIÉRCOLES 05 MARZO 2025',
              folio: 'Folio: 00122357',
              estatus: 'Estatus: Entregado',
              productos: [
                _ProductoData(
                  nombre: 'RED VOLUMEN',
                  descripcion: 'El Ácido hialurónico, fabricado con la propia tecnología especializada, tiene efectos duraderos debido a su excelente resistencia enzimática a la descomposición hasta en el cuerpo a pesar de una pequeña cantidad de BDDE.',
                  precio: '\$1,500.00 MXN',
                  cantidad: 'x5',
                ),
                _ProductoData(
                  nombre: 'JADE CAIN PLUS+',
                  descripcion: 'Crema anestésica local con un efecto más fuerte.',
                  precio: '\$1,600.00 MXN',
                  cantidad: 'x2',
                ),
              ],
              total: 'TOTAL= \$10,700.00 MXN',
            ),
            
            const SizedBox(height: 20),
            
            _buildOrderCard(
              fecha: 'MIÉRCOLES 05 MARZO 2025',
              folio: 'Folio: 00121587',
              estatus: 'Estatus: Entregado',
              productos: [
                _ProductoData(
                  nombre: 'LIPORASE',
                  descripcion: 'La Liporase puede utilizar para disolver los nódulos dérmicos o para maximizar la función de las inyecciones lipolíticas. Liporase, también conocida como hialuronidasa, es un modificador tisular indicado para líquidos subcutáneos para lograr la absorción máxima.',
                  precio: '\$250.00 MXN',
                  cantidad: 'x5',
                ),
                _ProductoData(
                  nombre: 'GELOSOME SOFT',
                  descripcion: 'Colocado en la superficie para el tratamiento facial y el rejuvenecimiento de la piel para brindar perfecta satisfacción y seguridad. Gelosome te trata con pieles naturales más suaves y saludables.',
                  precio: '\$1,500.00 MXN',
                  cantidad: 'x2',
                ),
              ],
              total: 'TOTAL= \$4,250.00 MXN',
            ),
            
            const SizedBox(height: 30),
            
            _buildResumenDelMes(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required String fecha,
    required String folio,
    required String estatus,
    required List<_ProductoData> productos,
    required String total,
  }) {
    return Card(
      elevation: GerenaColors.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: GerenaColors.mediumBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fecha,
                      style: GerenaColors.headingSmall.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      folio,
                      style: GerenaColors.bodySmall,
                    ),
                  ],
                ),
                Text(
                  estatus,
                  style: GerenaColors.bodySmall,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            ...productos.map((producto) => _buildProductoItem(producto)),
            
            const SizedBox(height: 16),
            
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                total,
                style: GerenaColors.headingSmall.copyWith(fontSize: 14),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 100,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GerenaColors.accentColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'FACTURAR',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 120,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GerenaColors.secondaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'VOLVER A PEDIR',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductoItem(_ProductoData producto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: GerenaColors.backgroundColorfondo,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [GerenaColors.lightShadow],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/productoenventa.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: GerenaColors.backgroundColorfondo,
                    child: Icon(
                      Icons.inventory,
                      color: GerenaColors.textSecondaryColor,
                      size: 30,
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  style: GerenaColors.headingSmall.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  producto.descripcion,
                  style: GerenaColors.bodySmall.copyWith(
                    fontSize: 11,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  producto.precio,
                  style: GerenaColors.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 8),
          
          Text(
            producto.cantidad,
            style: GerenaColors.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumenDelMes() {
    return Card(
      elevation: GerenaColors.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: GerenaColors.mediumBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RESUMEN DEL MES',
              style: GerenaColors.headingSmall.copyWith(fontSize: 15),
            ),
            
            const SizedBox(height: 20),
            
            _buildResumenItem('Subtotal', '\$16,200.00 MXN', false),
            const SizedBox(height: 8),
            _buildResumenItem('Puntos acumulados utilizados', '-\$100.00 MXN', true),
            const SizedBox(height: 8),
            _buildResumenItem('Descuentos y promociones', '- \$1,150.00 MXN', true),
            const SizedBox(height: 8),
            _buildResumenItem('Gastos de envío', '\$250.00MXN', false),
            const SizedBox(height: 8),
            _buildResumenItem('*IVA', '\$2,432.00MXN', false),
            
            const SizedBox(height: 16),
            
            Container(
              height: 1,
              color: GerenaColors.dividerColor,
            ),
            
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL:',
                  style: GerenaColors.headingSmall.copyWith(fontSize: 16),
                ),
                Text(
                  '\$17,632.00 MXN',
                  style: GerenaColors.headingSmall.copyWith(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenItem(String concepto, String monto, bool esDescuento) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            concepto,
            style: GerenaColors.bodyMedium.copyWith(
              color: esDescuento ? GerenaColors.warningColor : GerenaColors.textPrimaryColor,
            ),
          ),
        ),
        Text(
          monto,
          style: GerenaColors.bodyMedium.copyWith(
            color: esDescuento ? GerenaColors.warningColor : GerenaColors.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ProductoData {
  final String nombre;
  final String descripcion;
  final String precio;
  final String cantidad;

  _ProductoData({
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.cantidad,
  });
}