import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/presentation/page/getmylastpaidorder/get_my_last_paid_order_controller.dart';
import 'package:gerena/features/marketplace/presentation/page/getmylastpaidorder/widget/status_card_loading.dart';
import 'package:gerena/features/marketplace/presentation/page/getmylastpaidorder/widgets_status_pedido.dart';
import 'package:get/get.dart';

class StatusCardModal extends StatelessWidget {
  const StatusCardModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Material(
        color: Colors.black54,
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width < 800 
                  ? MediaQuery.of(context).size.width * 0.9  
                  : MediaQuery.of(context).size.width * 0.5,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Estado de tu pedido',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: GerenaColors.textPrimaryColor,
                          ),
                        ),
                      IconButton(
  icon: Image.asset(
    'assets/icons/close.png',
                 width: 20,
    height: 20,
  ),
  onPressed: () => Navigator.of(context).pop(),
  splashRadius: 20,
)

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: StatusCardWidget(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}