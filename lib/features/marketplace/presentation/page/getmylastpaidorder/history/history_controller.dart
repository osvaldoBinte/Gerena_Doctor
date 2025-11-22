import 'package:gerena/features/marketplace/domain/entities/orders/orders_entity.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_my_order_usecase.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final GetMyOrderUsecase getMyOrderUsecase;
  
  HistoryController({required this.getMyOrderUsecase});

  // Observables
  final orders = <OrderEntity>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final ordersList = await getMyOrderUsecase.execute();
      orders.value = ordersList;
      
    } catch (e) {
      errorMessage.value = 'Error al cargar los pedidos: $e';
      print('Error en HistoryController: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refrescar pedidos
  Future<void> refresh() => loadOrders();

  // Obtener pedidos agrupados por mes
  Map<String, List<OrderEntity>> get ordersByMonth {
    final Map<String, List<OrderEntity>> grouped = {};
    
    for (var order in orders) {
      final monthYear = getMonthYear(order.createdAt);
      if (!grouped.containsKey(monthYear)) {
        grouped[monthYear] = [];
      }
      grouped[monthYear]!.add(order);
    }
    
    return grouped;
  }

  // Calcular totales del mes actual
  double getTotalForMonth(String monthYear) {
    final ordersInMonth = ordersByMonth[monthYear] ?? [];
    return ordersInMonth.fold(0.0, (sum, order) => sum + order.total);
  }

  double getSubtotalForMonth(String monthYear) {
    final ordersInMonth = ordersByMonth[monthYear] ?? [];
    return ordersInMonth.fold(0.0, (sum, order) => sum + order.totalOriginal);
  }

  double getDiscountsForMonth(String monthYear) {
    final ordersInMonth = ordersByMonth[monthYear] ?? [];
    return ordersInMonth.fold(0.0, (sum, order) => sum + order.discountByPoints);
  }

  int getTotalPointsUsedForMonth(String monthYear) {
    final ordersInMonth = ordersByMonth[monthYear] ?? [];
    return ordersInMonth.fold(0, (sum, order) => sum + order.pointsUsed);
  }

  String getMonthYear(DateTime date) {
    final months = [
      'ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO',
      'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  // Helper para formatear fecha
  String formatDate(DateTime date) {
    final days = ['LUNES', 'MARTES', 'MIÉRCOLES', 'JUEVES', 'VIERNES', 'SÁBADO', 'DOMINGO'];
    final months = [
      'ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO',
      'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE'
    ];
    
    final dayName = days[date.weekday - 1];
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;
    
    return '$dayName $day $month $year';
  }

  // Helper para obtener el estado traducido
  String getStatusText(String status) {
    final statusMap = {
      'pendiente': 'Pendiente',
      'pagado': 'Pagado',
      'cancelado': 'Cancelado',
      'enviado': 'Enviado',
      'entregado': 'Entregado',
    };
    return statusMap[status.toLowerCase()] ?? status;
  }
}