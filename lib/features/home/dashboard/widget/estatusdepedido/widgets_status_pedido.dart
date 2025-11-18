import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/home/dashboard/widget/estatusdepedido/estatus_de_pedido.dart';
import 'package:get/get.dart';

class StatusCardWidget extends StatelessWidget {
  const StatusCardWidget({Key? key}) : super(key: key);

  String get folio => '00122357';

  List<Map<String, dynamic>> get predefinedStatuses => [
    {
      'imagePath': 'assets/icons/confirmado.png',
      'text': 'Confirmado',
      'isActive': false,
    },
    {
      'imagePath': 'assets/icons/preparando.png',
      'text': 'Preparando pedido',
      'isActive': false,
    },
    {
      'imagePath': 'assets/icons/truck.png',
      'text': 'Enviado',
      'isActive': true,  
    },
    {
      'imagePath': 'assets/icons/entregado.png',
      'text': 'Recibido',
      'isActive': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                onTap: () => _showEstatusModal(),
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
                        folio,
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
            children: _buildStatusRow(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStatusRow() {
    List<Widget> widgets = [];
    
    for (int i = 0; i < predefinedStatuses.length; i++) {
      widgets.add(_buildStatusItem(
        predefinedStatuses[i]['imagePath'], 
        predefinedStatuses[i]['text'], 
        isActive: predefinedStatuses[i]['isActive']
      ));
      
      if (i < predefinedStatuses.length - 1) {
        widgets.add(_buildStatusLine(
          isActive: predefinedStatuses[i]['isActive']
        ));
      }
    }
    
    return widgets;
  }

  void _showEstatusModal() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return const EstatusDePedido();
      },
    );
  }

  Widget _buildStatusItem(String imagePath, String text, {required bool isActive}) {
    return GestureDetector(
      onTap: isActive ? _showEstatusModal : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            color: isActive ? GerenaColors.secondaryColor : GerenaColors.primaryColor,
            width: 20,
            height: 20,
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
                 fontWeight: FontWeight.bold,
                color: isActive ? GerenaColors.secondaryColor : GerenaColors.primaryColor,
                height: 1.2, 
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusLine({required bool isActive}) {
    return Container(
      width: 20,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: isActive ? GerenaColors.secondaryColor : Colors.grey,
    );
  }
}