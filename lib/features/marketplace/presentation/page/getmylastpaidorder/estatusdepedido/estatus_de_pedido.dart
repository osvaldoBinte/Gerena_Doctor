import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:get/get.dart';

class EstatusDePedido extends StatelessWidget {
  const EstatusDePedido({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(
        begin: const Offset(0, 1), 
        end: Offset.zero,
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: Offset(0, offset.dy * MediaQuery.of(context).size.height),
          child: child,
        );
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        alignment: Alignment.bottomLeft,
        insetPadding: const EdgeInsets.only(left: 16, bottom: 0),
        child: Container(
          width: 430,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: GerenaColors.backgroundColor,
            borderRadius: GerenaColors.mediumBorderRadius,
            boxShadow: [GerenaColors.mediumShadow],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: GerenaColors.backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                        child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: GerenaColors.disabledColor.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/icons/close.png',
                                          width: 20,
    height: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildStatusTimeline(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ESTATUS DE PEDIDO:',
          style: GerenaColors.headingSmall.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EN RUTA DE ENTREGA',
                    style: GerenaColors.bodyMedium.copyWith(
                      fontSize: 12,
                      color: GerenaColors.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PAQUETERÍA:',
                    style: GerenaColors.bodyMedium.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Viernes, 28 de marzo',
                    style: GerenaColors.bodyMedium.copyWith(
                      fontSize: 12,
                      color: GerenaColors.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'FOLIO',
                  style: GerenaColors.bodySmall.copyWith(
                    fontSize: 10,
                    color: GerenaColors.textSecondaryColor,
                  ),
                ),
                Text(
                  '00122357',
                  style: GerenaColors.bodyMedium.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ESTAFETA',
                  style: GerenaColors.bodyMedium.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'TBM507220602488',
                  style: GerenaColors.bodySmall.copyWith(
                    fontSize: 10,
                    color: GerenaColors.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusTimeline() {
    final statusList = [
      _StatusItem(
        time: '8:20 AM',
        title: 'En ruta de entrega',
        location: 'Zapopan, JM.',
        isActive: true,
      ),
      _StatusItem(
        time: '5:14 PM',
        title: 'Paquete recibido en instalación del transportista',
        location: 'Zapopan, JM.',
        isActive: false,
      ),
      _StatusItem(
        time: '4:14 PM',
        title: 'Pedido recolectado',
        location: 'Guadalajara, JM.',
        isActive: false,
      ),
      _StatusItem(
        time: '3:20 PM',
        title: 'Guía de seguimiento generada',
        location: 'Guadalajara, JM.',
        isActive: false,
      ),
      _StatusItem(
        time: '1:35 PM',
        title: 'Confirmación de pedido',
        location: 'Guadalajara, JM.',
        isActive: false,
      ),
      _StatusItem(
        time: '3:04 PM',
        title: 'Pedido generado',
        location: 'Guadalajara, JM.',
        isActive: false,
      ),
    ];

    return Column(
      children: statusList.map((status) => _buildTimelineItem(status)).toList(),
    );
  }

  Widget _buildTimelineItem(_StatusItem status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              status.time,
              style: GerenaColors.bodySmall.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: status.isActive 
                    ? GerenaColors.primaryColor 
                    : GerenaColors.textSecondaryColor,
              ),
            ),
          ),
          
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: status.isActive 
                      ? GerenaColors.secondaryColor 
                      : Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),
              if (status != statusList.last)
                Container(
                  width: 2,
                  height: 40,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
            ],
          ),
          
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.title,
                  style: GerenaColors.bodyMedium.copyWith(
                    fontSize: 12,
                    fontWeight: status.isActive ? FontWeight.w600 : FontWeight.normal,
                    color: status.isActive 
                        ? GerenaColors.textPrimaryColor 
                        : GerenaColors.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status.location,
                  style: GerenaColors.bodySmall.copyWith(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<_StatusItem> get statusList => [
    _StatusItem(
      time: '8:20 AM',
      title: 'En ruta de entrega',
      location: 'Zapopan, JM.',
      isActive: true,
    ),
    _StatusItem(
      time: '5:14 PM',
      title: 'Paquete recibido en instalación del transportista',
      location: 'Zapopan, JM.',
      isActive: false,
    ),
    _StatusItem(
      time: '4:14 PM',
      title: 'Pedido recolectado',
      location: 'Guadalajara, JM.',
      isActive: false,
    ),
    _StatusItem(
      time: '3:20 PM',
      title: 'Guía de seguimiento generada',
      location: 'Guadalajara, JM.',
      isActive: false,
    ),
    _StatusItem(
      time: '1:35 PM',
      title: 'Confirmación de pedido',
      location: 'Guadalajara, JM.',
      isActive: false,
    ),
    _StatusItem(
      time: '3:04 PM',
      title: 'Pedido generado',
      location: 'Guadalajara, JM.',
      isActive: false,
    ),
  ];



class _StatusItem {
  final String time;
  final String title;
  final String location;
  final bool isActive;

  _StatusItem({
    required this.time,
    required this.title,
    required this.location,
    required this.isActive,
  });
}
