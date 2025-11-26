import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/presentation/page/getmylastpaidorder/history/history_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistorialDePedidosContent extends StatelessWidget {
  const HistorialDePedidosContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();

    return Scaffold(
      backgroundColor: GerenaColors.backgroundColor,
     appBar: GetPlatform.isMobile
    ? AppBar(
        backgroundColor: GerenaColors.backgroundColorFondo,
        elevation: 4,
        shadowColor: GerenaColors.shadowColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: GerenaColors.textPrimaryColor,
          ),
          onPressed: () {
                                      Get.offAllNamed(RoutesNames.homePage);

          },
        ),
        title: Text(
          'Historial de Pedidos',
          style: GerenaColors.headingMedium.copyWith(fontSize: 18),
        ),
      )
    : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: GerenaColors.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refresh,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (controller.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 64,
                  color: GerenaColors.textSecondaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'No tienes pedidos aún',
                  style: GerenaColors.headingMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '¡Realiza tu primera compra!',
                  style: GerenaColors.bodyMedium.copyWith(
                    color: GerenaColors.textSecondaryColor,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...controller.orders.map((order) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildOrderCard(controller, order),
                )),

                const SizedBox(height: 30),

             //   _buildResumenDelMes(controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOrderCard(HistoryController controller, order) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
      locale: 'es_MX',
    );

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.formatDate(order.createdAt),
                        style: GerenaColors.headingSmall.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.hasFolio 
                            ? 'Folio: ${order.folio}'
                            : 'Pedido #${order.id}',
                        style: GerenaColors.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor(order.status),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    controller.getStatusText(order.status),
                    style: GerenaColors.bodySmall.copyWith(
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            if (order.shippingStatus != null && order.shippingStatus!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    size: 16,
                    color: GerenaColors.secondaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Envío: ${order.shippingStatus}',
                    style: GerenaColors.bodySmall.copyWith(
                      color: GerenaColors.secondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 20),

            ...order.details.map((detail) => _buildProductoItem(
            nombre: detail.medicationName,
            precio: currencyFormat.format(detail.unitPrice),
            cantidad: 'x${detail.quantity}',
            subtotal: currencyFormat.format(detail.subtotal),
            fotos: detail.fotos, 
          )),
            const SizedBox(height: 16),

            if (order.hasDiscount) ...[
              _buildTotalRow(
                'Subtotal:',
                currencyFormat.format(order.totalOriginal),
                isSubtotal: true,
              ),
              _buildTotalRow(
                'Descuento por puntos:',
                '- ${currencyFormat.format(order.discountByPoints)}',
                isDiscount: true,
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
            ],

            _buildTotalRow(
              'TOTAL:',
              '${currencyFormat.format(order.total)} MXN',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildProductoItem({
  required String nombre,
  required String precio,
  required String cantidad,
  required String subtotal,
  List<String>? fotos,
}) {
  final fotoUrl = fotos != null && fotos.isNotEmpty ? fotos.first : null;

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
            child: fotoUrl != null && fotoUrl.isNotEmpty
                ? Image.network(
                    fotoUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                          color: GerenaColors.primaryColor,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholderImage();
                    },
                  )
                : _buildPlaceholderImage(),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nombre,
                style: GerenaColors.headingSmall.copyWith(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Precio unitario: $precio',
                style: GerenaColors.bodySmall.copyWith(
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Subtotal: $subtotal',
                style: GerenaColors.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Text(
          cantidad,
          style: GerenaColors.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

// ⭐ Agregar widget helper para placeholder
Widget _buildPlaceholderImage() {
  return Image.asset(
    '',
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
  );
}

  Widget _buildTotalRow(String label, String amount, {
    bool isTotal = false,
    bool isDiscount = false,
    bool isSubtotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal 
              ? GerenaColors.headingSmall.copyWith(fontSize: 16)
              : GerenaColors.bodyMedium.copyWith(
                  color: isDiscount ? GerenaColors.warningColor : null,
                ),
        ),
        Text(
          amount,
          style: isTotal
              ? GerenaColors.headingSmall.copyWith(fontSize: 16)
              : GerenaColors.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDiscount ? GerenaColors.warningColor : null,
                ),
        ),
      ],
    );
  }

  Widget _buildResumenDelMes(HistoryController controller) {
    
    final now = DateTime.now();
    final currentMonthYear = controller.getMonthYear(now);
    
    final subtotal = controller.getSubtotalForMonth(currentMonthYear);
    final discounts = controller.getDiscountsForMonth(currentMonthYear);
    final total = controller.getTotalForMonth(currentMonthYear);
    final pointsUsed = controller.getTotalPointsUsedForMonth(currentMonthYear);

    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
      locale: 'es_MX',
    );

    final shipping = total > 0 ? 250.0 : 0.0;
    final iva = (subtotal + shipping - discounts) * 0.16;
    final finalTotal = subtotal + shipping + iva - discounts;

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
              'RESUMEN DEL MES - $currentMonthYear',
              style: GerenaColors.headingSmall.copyWith(fontSize: 15),
            ),

            const SizedBox(height: 20),

            _buildResumenItem(
              'Subtotal',
              '${currencyFormat.format(subtotal)} MXN',
              false,
            ),
            if (pointsUsed > 0) ...[
              const SizedBox(height: 8),
              _buildResumenItem(
                'Puntos utilizados ($pointsUsed pts)',
                '- ${currencyFormat.format(discounts)} MXN',
                true,
              ),
            ],
            const SizedBox(height: 8),
            _buildResumenItem(
              'Gastos de envío',
              '${currencyFormat.format(shipping)} MXN',
              false,
            ),
            const SizedBox(height: 8),
            _buildResumenItem(
              '*IVA (16%)',
              '${currencyFormat.format(iva)} MXN',
              false,
            ),

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
                  '${currencyFormat.format(finalTotal)} MXN',
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
              color: esDescuento
                  ? GerenaColors.warningColor
                  : GerenaColors.textPrimaryColor,
            ),
          ),
        ),
        Text(
          monto,
          style: GerenaColors.bodyMedium.copyWith(
            color: esDescuento
                ? GerenaColors.warningColor
                : GerenaColors.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'entregado':
        return Colors.green;
      case 'pagado':
      case 'enviado':
        return Colors.blue;
      case 'pendiente':
        return Colors.orange;
      case 'cancelado':
        return Colors.red;
      default:
        return GerenaColors.textSecondaryColor;
    }
  }
}