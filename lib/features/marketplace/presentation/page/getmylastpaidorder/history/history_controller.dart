import 'package:gerena/features/marketplace/domain/entities/orders/orders_entity.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_my_order_usecase.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final GetMyOrderUsecase getMyOrderUsecase;
  
  HistoryController({required this.getMyOrderUsecase});

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
    
    ordersList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    orders.value = ordersList;
    
  } catch (e) {
    errorMessage.value = 'Error al cargar los pedidos: $e';
    print('Error en HistoryController: $e');
  } finally {
    isLoading.value = false;
  }
}

  Future<void> refresh() => loadOrders();
Map<String, List<OrderEntity>> get ordersByMonth {
  final Map<String, List<OrderEntity>> grouped = {};

  for (var order in orders) {
    final monthYear = getMonthYear(order.createdAt);
    if (!grouped.containsKey(monthYear)) {
      grouped[monthYear] = [];
    }
    grouped[monthYear]!.add(order);
  }

  final sortedKeys = grouped.keys.toList()
    ..sort((a, b) => _parseMonthYear(b).compareTo(_parseMonthYear(a)));

  return {for (var key in sortedKeys) key: grouped[key]!};
}
DateTime _parseMonthYear(String monthYear) {
  final months = {
    'ENERO': 1, 'FEBRERO': 2, 'MARZO': 3, 'ABRIL': 4,
    'MAYO': 5, 'JUNIO': 6, 'JULIO': 7, 'AGOSTO': 8,
    'SEPTIEMBRE': 9, 'OCTUBRE': 10, 'NOVIEMBRE': 11, 'DICIEMBRE': 12,
  };
  final parts = monthYear.split(' ');
  final month = months[parts[0]] ?? 1;
  final year = int.parse(parts[1]);
  return DateTime(year, month);
}
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