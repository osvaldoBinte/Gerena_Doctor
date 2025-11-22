import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/presentation/page/getmylastpaidorder/estatusdepedido/estatus_de_pedido.dart';
import 'package:gerena/features/marketplace/presentation/page/getmylastpaidorder/get_my_last_paid_order_controller.dart';
import 'package:get/get.dart';

class StatusCardWidget extends StatelessWidget {
  const StatusCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GetMyLastPaidOrderController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingCard();
      }

      if (controller.errorMessage.isNotEmpty) {
        return _buildErrorCard(controller.errorMessage.value);
      }

      if (!controller.hasOrder) {
        return _buildEmptyCard();
      }

      return _buildOrderCard(controller);
    });
  }

  Widget _buildLoadingCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: GerenaColors.smallBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: GerenaColors.smallBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: Text(
        message,
        style: const TextStyle(color: GerenaColors.textPrimaryColor, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: GerenaColors.smallBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: Text(
        'No hay pedidos pagados',
        style: TextStyle(
          fontSize: 12,
          color: GerenaColors.textPrimaryColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOrderCard(GetMyLastPaidOrderController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: GerenaColors.smallBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'ESTATUS DE PEDIDO:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: GerenaColors.textPrimaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
               // onTap: () => _showEstatusModal(controller),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'FOLIO',
                        style: TextStyle(
                          fontSize: 10,
                          color: GerenaColors.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        controller.displayFolio,
                        style: TextStyle(
                          fontSize: 12,
                          color: GerenaColors.textPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildStatusRow(controller.currentShippingStatus),
          ),
        ],
      ),
    );
  }

  int _getCurrentStatusIndex(String? shippingStatus) {
    if (shippingStatus == null || shippingStatus.isEmpty) {
      return 0; 
    }

    final status = shippingStatus.toUpperCase().trim();
    
    switch (status) {
      case 'POR ENTREGAR':
        return 1; 
      case 'EN RUTA':
        return 2;
      case 'ENTREGADO':
        return 3; 
      default:
        return 0;
    }
  }

  List<Map<String, dynamic>> _getPredefinedStatuses(String? currentStatus) {
    final currentIndex = _getCurrentStatusIndex(currentStatus);
    
    return [
      {
        'imagePath': 'assets/icons/confirmado.png',
        'text': 'Confirmado',
        'isActive': currentIndex >= 0,
        'statusIndex': 0,
      },
      {
        'imagePath': 'assets/icons/preparando.png',
        'text': 'Preparando pedido',
        'isActive': currentIndex >= 1,
        'statusIndex': 1,
      },
      {
        'imagePath': 'assets/icons/truck.png',
        'text': 'Enviado',
        'isActive': currentIndex >= 2,
        'statusIndex': 2,
      },
      {
        'imagePath': 'assets/icons/entregado.png',
        'text': 'Recibido',
        'isActive': currentIndex >= 3,
        'statusIndex': 3,
      },
    ];
  }

  List<Widget> _buildStatusRow(String? currentStatus) {
    List<Widget> widgets = [];
    final statuses = _getPredefinedStatuses(currentStatus);
    final currentIndex = _getCurrentStatusIndex(currentStatus);
    
    for (int i = 0; i < statuses.length; i++) {
      widgets.add(_buildStatusItem(
        statuses[i]['imagePath'], 
        statuses[i]['text'], 
        isActive: statuses[i]['isActive'],
        isCurrent: currentIndex == i,
      ));
      
      if (i < statuses.length - 1) {
        widgets.add(_buildStatusLine(
          isActive: currentIndex > i 
        ));
      }
    }
    
    return widgets;
  }

  void _showEstatusModal(GetMyLastPaidOrderController controller) {
    if (!controller.hasOrder) return;

    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return const EstatusDePedido();
      },
    );
  }

  Widget _buildStatusItem(
    String imagePath, 
    String text, 
    {
      required bool isActive,
      bool isCurrent = false,
    }
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: isCurrent ? const EdgeInsets.all(4) : null,
          decoration: isCurrent ? BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: GerenaColors.secondaryColor,
              width: 2,
            ),
          ) : null,
          child: Image.asset(
            imagePath,
            color: isActive 
                ? GerenaColors.secondaryColor 
                : GerenaColors.primaryColor.withOpacity(0.4),
            width: 20,
            height: 20,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 50, 
          height: 32, 
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 8, 
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive 
                  ? GerenaColors.secondaryColor 
                  : GerenaColors.primaryColor.withOpacity(0.4),
              height: 1.2, 
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusLine({required bool isActive}) {
    return Container(
      width: 20,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: isActive 
          ? GerenaColors.secondaryColor 
          : Colors.grey.withOpacity(0.4),
    );
  }
}