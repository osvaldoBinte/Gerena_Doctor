import 'package:gerena/common/errors/convert_message.dart';
import 'package:gerena/features/marketplace/domain/entities/orders/orders_entity.dart';
import 'package:gerena/features/marketplace/domain/usecase/get_my_last_paid_order_usecase.dart';
import 'package:get/get.dart';

class GetMyLastPaidOrderController extends GetxController {
  final GetMyLastPaidOrderUsecase getMyLastPaidOrderUsecase;
  
  GetMyLastPaidOrderController({required this.getMyLastPaidOrderUsecase});

  final Rx<OrderEntity?> lastPaidOrder = Rx<OrderEntity?>(null);
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadLastPaidOrder();
  }

  Future<void> loadLastPaidOrder() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final order = await getMyLastPaidOrderUsecase.execute();
      lastPaidOrder.value = order;
      
    } catch (e) {
      errorMessage.value = cleanExceptionMessage(e);
      print('Error en GetMyLastPaidOrderController: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String get displayFolio {
    if (lastPaidOrder.value == null) return 'N/A';
    return lastPaidOrder.value!.hasFolio 
        ? lastPaidOrder.value!.folio! 
        : '#${lastPaidOrder.value!.id}';
  }

  bool get hasOrder => lastPaidOrder.value != null;

  String? get currentShippingStatus => lastPaidOrder.value?.shippingStatus;

  Future<void> refresh() => loadLastPaidOrder();
}